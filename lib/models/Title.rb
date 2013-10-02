require 'data_mapper'
require 'dm-serializer'

class Title
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :user,         String    
  property :title,        String,  :length => 100, :message => "That suggestion was too long."
  property :title_lc,     String,  :length => 100
  property :vote_count,   Integer
  property :updated_at,   DateTime  # A DateTime, for any date you might like.

  belongs_to :show
  has n, :votes

end
