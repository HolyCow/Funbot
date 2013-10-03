require 'dm-core'

require './lib/Models/Title'

class Show
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :title,        String    
  property :updated_at,   DateTime, :default => DateTime.new()

  has n, :titles, :constraint => :destroy

  def self.current
    first(:order => [ :updated_at.desc, :id.desc ])
  end
end
