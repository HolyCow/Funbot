require File.dirname(__FILE__) + '/database_spec_helper'

require './lib/Models/Show'

describe 'Title' do 
	it "should return the added vote and vote count should go up" do
		show = Show.create(:title => "This is a title")
		title = show.titles.create(:user => 'Nobody', :title => "Nothing", :title_lc => "nothing")
		vote = title.upvote('10.10.10.10')
		vote.voter_ip.should == '10.10.10.10'
		title.vote_count.should == 1
	end

	it "should not increment the vote count by 2" do
		show = Show.create(:title => "This is a title")
		title = show.titles.create(:user => 'Nobody', :title => "Nothing", :title_lc => "nothing")
		vote = title.upvote('10.10.10.10')
		vote = title.upvote('10.10.10.10')
		title.vote_count.should == 1
	end

	it "should not allow titles longer than 100 characters with zero votes" do
		show = Show.create(:title => "This is a title")
		title = show.titles.create(:user => 'Nobody', :title => 'a' * 100)
		title.user.should == 'Nobody'
		title.title.should == 'a' * 100
	end

	it "should start titles with zero votes" do
		show = Show.create(:title => "This is a title")
		title = show.titles.create(:user => 'Nobody', :title => 'a')
		title.vote_count.should == 0
	end

end

