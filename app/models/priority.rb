class Priority < ActiveRecord::Base
  validates_presence_of :description
  has_many :notes
end
