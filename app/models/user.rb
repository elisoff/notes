class User < ActiveRecord::Base
  validates_presence_of :name
  validates :email,
            presence: true,
            email_format: { message: "is this an email address?" }
  
  has_many :notes
end
