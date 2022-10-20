class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id #check

  belongs_to :merchant

  def self.find_all_by_name(query)
    where("name ILIKE ?", "%#{query}%")
  end
end