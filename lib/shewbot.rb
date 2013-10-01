require 'date'
require 'cinch'
require 'dotenv'
require 'twitter'
require 'mail'

if ARGV.first
  Dotenv.load(ARGV.first)
else
  Dotenv.load
end

require './lib/database'

ENV['BOTNAME'] ||= 'Shewbot'
ENV['BOTCHANNEL'] ||= '5by5'

ENV['BOTCHANNEL'] = '#' + ENV['BOTCHANNEL']



class TimedEvents
  include Cinch::Plugin

  timer 30, :method => :send_timer_message

  def send_timer_message
    puts 'Checking twitter'

    puts ENV['TWITTER_REGEX']

    puts last_tweet

    if last_tweet =~ /#{ENV['TWITTER_REGEX']}/
      new_show = Regexp.last_match[1]

      currentshow = Show.current

      if currentshow && new_show == Show.current.title
        return
      end

      if ENV['EMAIL_ON_NEW_SHOW'] == 1

        options = { :address              => ENV['EMAIL_SERVER'],
                    :port                 => ENV['EMAIL_PORT'],
                    :domain               => ENV['EMAIL_DOMAIN'],
                    :user_name            => ENV['EMAIL_USER'],
                    :password             => ENV['EMAIL_PASSWORD'],
                    :authentication       => ENV['EMAIL_AUTH'],
                    :enable_starttls_auto => true  }

        puts options

        Mail.defaults do
          delivery_method :smtp, options
        end

        emailbody = ''

        Title.all.each do | t |
          emailbody << "#{t.title}, #{t.user}, #{t.votes}\n"
        end

        if currentshow
          Mail.deliver do
                 to ENV['EMAIL_TO']
               from ENV['EMAIL_USER']
            subject "Titles for #{currentshow.title}"
               body emailbody
          end
        end
      end

      if ENV['DELETE_ON_NEW_SHOW'] == 1
        Title.all.destroy
        Show.all.destroy
        Vote.all.destroy
      end

      Show.create(:title => new_show, :updated_at => Time.new)
    end

  end

end


bot = Cinch::Bot.new do

  configure do |c|
    c.server   = ENV['IRC_SERVER']
    c.channels = [ENV['BOTCHANNEL']]
    c.nick = ENV['BOTNAME']
    c.plugins.plugins = [TimedEvents]
  end

  on :message, /@5by5: (.*?) with .*? is starting now/ do |m, show|

    if m.user.nick.downcase == 'showbot' || m.user.nick.downcase == '_holycow'
      emailbody = ''

      puts "---------------"
      puts "Email on new show = " + ENV['EMAIL_ON_NEW_SHOW']
      puts "---------------"

      if ENV['EMAIL_ON_NEW_SHOW']

        options = { :address              => ENV['EMAIL_SERVER'],
                    :port                 => ENV['EMAIL_PORT'],
                    :domain               => ENV['EMAIL_DOMAIN'],
                    :user_name            => ENV['EMAIL_USER'],
                    :password             => ENV['EMAIL_PASSWORD'],
                    :authentication       => ENV['EMAIL_AUTH'],
                    :enable_starttls_auto => true  }

        puts options

        Mail.defaults do
          delivery_method :smtp, options
        end

        Title.all.each do | t |
          emailbody << "#{t.title}, #{t.user}, #{t.votes}\n"
        end

        currentshow = Show.current

        if currentshow
          Mail.deliver do
                 to ENV['EMAIL_TO']
               from ENV['EMAIL_USER']
            subject "Titles for #{currentshow.title}"
               body emailbody
          end
        end
      end

      if ENV['DELETE_ON_NEW_SHOW']
        Title.all.destroy
        Show.all.destroy
        Vote.all.destroy
      end

      Show.create(:title => show, :updated_at => m.time)
    end
  end

  on :message, /^!s (.*$)/ do |m, title|
    puts "Got title suggestion #{title}"

    currentshow = Show.current

    existingtitle = currentshow.titles.first(:title_lc => title.downcase)

    if existingtitle
      m.user.send "Sorry, that title was already submitted by #{existingtitle.user}"
    else

      newtitle = currentshow.titles.create(:user => m.user.nick, :title => title, :title_lc => title.downcase, :updated_at => m.time, :vote_count => 0)
      puts newtitle
    end
    
  end

  on :message, /^!help/ do |m|
    m.user.send "!s - suggest a title; !last - I'll tell you what last tweet by @#{ENV['TWITTER_USER']}; !help - this"
  end

  on :message, /^!last/ do |m|
    m.user.send last_tweet
  end

end

def last_tweet
  Twitter.configure do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
    config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
  end

  status = Twitter.user_timeline(ENV['TWITTER_USER']).first
  return status.text
end

bot.start

