require 'date'
require 'cinch'
require 'data_mapper'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)


if ENV['HEROKU_POSTGRESQL_IVORY_URL']
  DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_IVORY_URL'])
else
  DataMapper.setup(:default, {:adapter => 'postgres', :host => 'localhost', :username => 'vagrant', :database => "shewbot", :password => "vagrant"})
end

class Titles
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :user,         String    
  property :show,         String    # A varchar type string, for short strings
  property :title,        Text      # A text block, for longer string data.
  property :votes,        Integer
  property :updated_at,   DateTime  # A DateTime, for any date you might like.
end

class CurrentShow
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :show,         String    
  property :updated_at,   DateTime  # A DateTime, for any date you might like.
end

class Voters
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :voter,        String    
  property :title_id,     Integer  # A DateTime, for any date you might like.
end

DataMapper.finalize

file = File.new(File.expand_path('titles.txt'), 'w+')

Titles.all(:order => [ :updated_at.asc ]).each do | m |
  formatted_string = '"' + m.title + '" by ' + m.user #+ " (#{m.votes})"

  puts( formatted_string )

  file.puts formatted_string

end

file.close






