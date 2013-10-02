require 'data_mapper'
require 'dm-serializer'

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
