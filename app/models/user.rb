class User < ActiveRecord::Base
	has_many :user_to_events
	has_many :events, :through => :user_to_events
	validates :name, :uniqueness => true
end
