class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id #check

  belongs_to :merchant

  def self.find_all_by_name(query)
    where("name ILIKE ?", "%#{query}%")
  end

  def self.find_by_max_price(maxprice)
    where("unit_price <= ?", maxprice)
  end

  def self.find_by_min_price(minprice)
    where("unit_price >= ?", minprice)
  end

  def self.find_by_price_range(minprice, maxprice)
    where(unit_price: minprice..maxprice)
  end
end