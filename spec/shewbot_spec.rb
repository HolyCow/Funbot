requre File.dirname(__FILE) + '/spec_helper'

describe 'Shewbot' do 
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	it 'should run a simple test' do
		get '/'
		last_response.status.should == 200
	end
end
