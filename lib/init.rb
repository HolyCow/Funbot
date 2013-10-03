require 'dm-core'
require 'dotenv'

if ARGV.first
  Dotenv.load(ARGV.first)
else
  Dotenv.load
end

configure :development do 
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper::Logger.new($stdout, :debug)
end

configure :test do 
  DataMapper.setup(:default, "sqlite::memory:")
end

DataMapper.finalize
DataMapper.auto_upgrade!
