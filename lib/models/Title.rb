require 'dm-core'
require 'dm-constraints'

require './lib/Models/Vote'

class Title
  include DataMapper::Resource

  property :id,           Serial
  property :user,         String    
  property :title,        String,   :length => 100, :message => "That suggestion was too long."
  property :title_lc,     String,   :length => 100
  property :vote_count,   Integer,  :default => 0
  property :updated_at,   DateTime, :default => DateTime.new()

  belongs_to :show
  has n, :votes, :constraint => :destroy

  def upvote(voter_ip)
  	vote = votes.create(:voter_ip => voter_ip)
	update(:vote_count => votes.count)
	save
	vote
  end

end
