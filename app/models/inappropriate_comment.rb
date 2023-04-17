class InappropriateComment < ApplicationRecord
  
  validates :comment, presence: true
  
end
