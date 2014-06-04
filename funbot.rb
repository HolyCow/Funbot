
require 'cinch'

require 'dm-core'
require 'dm-timestamps'
require 'dm-constraints'

class Quote
  include DataMapper::Resource

  property :id,           Serial
  property :macro,        String,  :index => true
  property :quote,        String
  property :live,         Boolean, :default => false
  property :created_at,   DateTime
end

if ENV['DATABASE_URL']
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else 
  DataMapper.setup(:default, 'sqlite:test.db')
end

DataMapper.finalize
DataMapper.auto_upgrade!

bot = Cinch::Bot.new do

  configure do |c|
    c.server   = 'irc.freenode.org'
    c.channels = ['#' + ENV['channel']]
    c.nick = ENV['botname']
  end

  on :message, /^!quote (.*?) (.+)/ do |m, macro, quote|
    puts "Got quote suggestions #{macro} - #{quote}"
    if !['help', 'quote'].include?(macro)
      Quote.create(:macro => macro, :quote => quote)
    end
    m.user.send "Quote has been added to the queue and will not be available immediately"
  end

  on :message, /^!([^ ]+) ?$/ do |m, macro|
    puts "Got #{macro}"
    if !['help', 'quote'].include?(macro)
      quotes = Quote.all(:macro => macro)
      if quotes.length > 0
        m.reply quotes.sample.quote
      end
    end
  end

  on :message, /^!help/ do |m|
    m.user.send "Add a quote: !quote <macro> <quote>; Available macros: !" + 
      Quote.all(:conditions => { :live => true }, :fields => [:macro]).map{ |x| x.macro }.join(', !',)
  end

end

bot.start
