class User < ApplicationRecord
    
    validates :email, presence: true
    validates :email, uniqueness: { case_sensitive: false }

    has_many :user_events
    has_many :events, through: :user_events

end
