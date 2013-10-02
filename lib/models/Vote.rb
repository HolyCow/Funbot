require 'data_mapper'
require 'dm-serializer'
require 'dm-types'

class Vote
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key  
  property :voter_ip,     IPAddress
  
  belongs_to :title
end
