class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  has_many :purchases
end
