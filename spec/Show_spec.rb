require File.dirname(__FILE__) + '/database_spec_helper'

require './lib/Models/Show'

describe 'Show' do 
	it "should return the last submitted title as the current" do
		show = Show.create(:title => "This is a title")
		Show.current.title.should == "This is a title"
	end

	it "should return the last submitted title as the current even if we submit more titles" do
		show = Show.create(:title => "My first show")
		show = Show.create(:title => "This is a title")
		Show.current.title.should == "This is a title"
	end

end

