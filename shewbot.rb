require 'date'
require 'cinch'
require 'mail'
require 'twitter'

require './lib/Models/Show'
require './lib/Models/TwitterOps'

require './lib/init'

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end

ENV['BOTCHANNEL'] = '#' + ENV['BOTCHANNEL']

class TimedEvents
  include Cinch::Plugin

  timer 30, :method => :send_timer_message

  def send_timer_message

    show_name = TwitterOps::Tweets.parse_tweet(TwitterOps::Tweets.last_tweet(ENV['TWITTER_USER']), ENV['TWITTER_REGEX'])

    if show_name

      current_show = Show.current

      if current_show && show_name == current_show.title
        return
      end

      Show.create(:title => show_name)

      if ENV['EMAIL_ON_NEW_SHOW'] && ENV['EMAIL_ON_NEW_SHOW'].to_i == 1 && current_show

        options = { :address              => ENV['EMAIL_SERVER'],
                    :port                 => ENV['EMAIL_PORT'],
                    :domain               => ENV['EMAIL_DOMAIN'],
                    :user_name            => ENV['EMAIL_USER'],
                    :password             => ENV['EMAIL_PASSWORD'],
                    :authentication       => ENV['EMAIL_AUTH'],
                    :enable_starttls_auto => true  }

        puts 'EMAIL OPTIONS: ' + options

        Mail.defaults do
          delivery_method :smtp, options
        end

        emailbody = ''

        Title.all.each do | t |
          emailbody << "#{t.title}, #{t.user}, #{t.vote_count}\n"
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

      puts 'DELETE_ON_NEW_SHOW: ' + ENV['DELETE_ON_NEW_SHOW']

      if ENV['DELETE_ON_NEW_SHOW'] && ENV['DELETE_ON_NEW_SHOW'].to_i == 1 && current_show
        puts "Deleting all records"
        Show.destroy
      end

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

  on :message, /^!s (.*$)/ do |m, title|
    puts "Got title suggestion #{title}"

    currentshow = Show.current

    existingtitle = currentshow.titles.first(:title_lc => title.downcase)

    if existingtitle
      m.user.send "Sorry, that title was already submitted by #{existingtitle.user}"
    else

      newtitle = currentshow.titles.create(:user => m.user.nick, :title => title, :title_lc => title.downcase, :vote_count => 0)
      puts newtitle
    end
    
  end

  on :message, /^!help/ do |m|
    m.user.send "!s - suggest a title; !last - I'll tell you the last tweet by @#{ENV['TWITTER_USER']}; !help - this"
  end

  on :message, /^!last/ do |m|
    m.user.send last_tweet
  end

end

def last_tweet
  status = Twitter.user_timeline(ENV['TWITTER_USER']).first
  return status.text
end

bot.start

