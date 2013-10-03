require 'dm-core'
require 'dm-timestamps'
require 'dm-constraints'

require './lib/Models/Title'

class Show
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :title,        String    
  property :created_at,   DateTime

  has n, :titles, :constraint => :destroy

  def self.current
    first(:order => [ :created_at.desc, :id.desc ])
  end
end
