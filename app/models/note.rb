class Note < ActiveRecord::Base
  validates_presence_of [:text, :datetime]
  belongs_to :user
  has_one :priority
end
