require File.join(File.dirname(__FILE__), '..', 'web.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test

RSpec.configure do |config|
	
end


describe 'Shewbot' do
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	it 'should have first title submitted' do
		Show.create(:title => "This is a title")
		get '/'
		last_response.status.should == 200
		last_response.body.should include('This is a title')
	end

	it 'should have second title submitted' do
		Show.create(:title => "This is a title")
		Show.create(:title => "This is also a title")
		get '/'
		last_response.status.should == 200
		last_response.body.should include('This is also a title')
	end

	it 'should return a zero count for titles' do
		get '/count'
		last_response.status.should == 200
		last_response.body.should == '0'
	end

	it 'should return a one count for titles' do
		show = Show.create(:title => "Show title")

		show.titles.create(:user => 'Nobody', :title => "Nothing", :title_lc => "nothing")

		get '/count'
		last_response.status.should == 200
		last_response.body.should == '1'
	end

	it 'should give a vote to a title' do
		show = Show.create(:title => "Show title")

		title = show.titles.create(:user => 'Nobody', :title => "Nothing", :title_lc => "nothing")

		get "/titles/#{title.id}/vote"
		last_response.status.should == 200
		last_response.body.should == '1'
	end

	it 'should should not increase vote count on double vote' do
		show = Show.create(:title => "Show title")

		title = show.titles.create(:user => 'Nobody', :title => "Nothing", :title_lc => "nothing")

		get "/titles/#{title.id}/vote"
		get "/titles/#{title.id}/vote"
		last_response.status.should == 200
		last_response.body.should == '1'
	end

end

