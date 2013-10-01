require 'data_mapper'
require 'dm-migrations'
require 'dm-serializer'

if ENV['DATABASE_URL']
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, {:adapter => 'postgres', :host => 'localhost', :username => 'vagrant', :database => "shewbot", :password => "vagrant"})
end

class Show
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :title,        String    
  property :updated_at,   DateTime  # A DateTime, for any date you might like.

  has n, :titles

  def self.current
    first(:order => [ :updated_at.desc ])
  end
end

class Title
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :user,         String    
  property :title,        String
  property :title_lc,     String
  property :vote_count,   Integer
  property :updated_at,   DateTime  # A DateTime, for any date you might like.

  belongs_to :show
  has n, :votes

end

class Vote
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :voter,        Integer   
  
  belongs_to :title
end

DataMapper.finalize

DataMapper.auto_upgrade!