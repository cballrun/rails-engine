class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items

  def self.find_one(query)
    where("name ILIKE ?", "%#{query}%")

  end
end
