class Event < ActiveRecord::Base
	has_many :user_to_events
	has_many :users, :through => :user_to_events
	validates :name, :uniqueness => true
end
