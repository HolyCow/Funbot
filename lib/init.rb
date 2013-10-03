require 'dm-core'
require 'dm-migrations'
require 'dotenv'

if ARGV.first
  Dotenv.load(ARGV.first)
else
  Dotenv.load
end

if ENV['DATABASE_URL']
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else 
  DataMapper.setup(:default, "sqlite::memory:")
end

DataMapper.finalize
DataMapper.auto_upgrade!
