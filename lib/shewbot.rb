require 'date'
require 'cinch'
require 'data_mapper'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)

if ENV['HEROKU_POSTGRESQL_IVORY_URL']
  DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_IVORY_URL'])
else
  DataMapper.setup(:default, {:adapter => 'postgres', :host => 'localhost', :username => 'vagrant', :database => "shewbot", :password => "vagrant"})
end

class Titles
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :user,         String    
  property :show,         String    # A varchar type string, for short strings
  property :title,        Text      # A text block, for longer string data.
  property :votes,        Integer
  property :updated_at,   DateTime  # A DateTime, for any date you might like.
end

class CurrentShow
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :show,         String    
  property :updated_at,   DateTime  # A DateTime, for any date you might like.
end

class Voters
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :voter,        String    
  property :title_id,     Integer  # A DateTime, for any date you might like.
end

DataMapper.finalize

DataMapper.auto_upgrade!

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = 'irc.freenode.org'
    c.channels = ["#5by5", "#5by5bottest"]
    c.nick = 'shewbot'
  end

  on :message, /@5by5: (.*?) with .*? is starting now/ do |m, show|
    if m.user.nick.downcase == 'showbot' || m.user.nick.downcase == '_holycow'
      Titles.all.destroy
      CurrentShow.all.destroy
      Voters.all.destroy

      CurrentShow.create(:show => show, :updated_at => m.time)
    end
  end

  on :message, /^!s (.*$)/ do |m, title|
    puts "Got title suggestion #{title}"

    currentshow = CurrentShow.first(:order => [ :updated_at.desc ])

    existingtitle = Titles.first(:title => title, :show => currentshow.show)

    if existingtitle

      voter_record = Voters.first(:voter => m.user.nick.downcase, :title_id => existingtitle.id)

      if voter_record
        m.user.send "Sorry, that title was already submitted by #{existingtitle.user} and you have already voted"
      else
        existingtitle.votes = existingtitle.votes + 1
        Voters.create(:voter => m.user.nick.downcase, :title_id => existingtitle.id)
        m.user.send "Sorry, that title was already submitted by #{existingtitle.user}, so your submission has been added as a vote"
      end
   else
      newtitle = Titles.create(:user => m.user.nick, :show => currentshow.show, :title => title, :updated_at => m.time, :votes => 1)
      Voters.create(:voter => m.user.nick.downcase, :title_id => newtitle.id)
    end
    
  end

  on :message, /^!list/ do |m|

    currentshow = CurrentShow.first(:order => [ :updated_at.desc ])

    title_set = Titles.all(:show => currentshow.show, :limit => 20, :order => [ :votes.desc, :updated_at.desc ])

    m.user.send "Title suggestions for #{currentshow.show} (#{title_set.count})"

    title_set.each do |title|
      m.user.send "'#{title.title}' suggested by #{title.user} (#{title.votes})"
    end
  end

  on :message, /^!latest/ do |m|

    currentshow = CurrentShow.first(:order => [ :updated_at.desc ])

    title_set = Titles.all(:show => currentshow.show, :limit => 20, :order => [ :updated_at.desc ])

    m.user.send "Title suggestions for #{currentshow.show} (#{title_set.count})"

    title_set.each do |title|
      m.user.send "'#{title.title}' suggested by #{title.user} (#{title.votes})"
    end
  end

  on :message, /^!help/ do |m|
    m.user.send "!s - suggest a title or vote up a title; !list - get a list of show titles ordered by votes, then submission time, limited to 20; !latest - last 20 submissions; !help - this"
  end
end

bot.start

