
require './lib/Models/TwitterOps'

describe 'TwitterOps' do 
	it "should return the name of the show on match" do
		show_name = TwitterOps::Tweets.parse_tweet('Quit! with @danbenjamin is starting now', '(.*?) with .*? is starting now')

		show_name.should == 'Quit!'
	end

	it "should return false on non-match" do
		show_name = TwitterOps::Tweets.parse_tweet('Just posted Quit! with @danbenjamin', '(.*?) with .*? is starting now')

		show_name.should == false
	end

end

