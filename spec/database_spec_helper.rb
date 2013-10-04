require 'rspec'

require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite::memory:")
DataMapper.finalize
DataMapper.auto_upgrade!

RSpec.configure do |config|
	config.after(:all) do
		Show.all.destroy
	end
end
