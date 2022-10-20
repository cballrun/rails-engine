class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items

  def find_one(query)
    where("query ILIKE 'name'")

  end
end
