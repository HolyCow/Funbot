require 'twitter'

module TwitterOps
	class Tweets
		def self.last_tweet(twitter_user)
		  status = Twitter.user_timeline(twitter_user).first
		  return status.text
		end

		def self.parse_tweet(tweet, regex)
		    if tweet =~ /#{regex}/
	    	  return Regexp.last_match[1]
	    	end

	    	return false
		end
	end
end
