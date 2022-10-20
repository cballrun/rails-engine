require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id } #check
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end
  
  describe 'class methods' do
    it 'can find all items in a search by name' do
      i1 = create(:item, name: "Titanium Ring")
      i2 = create(:item, name: "Goldfish")
      i3 = create(:item, name: "Suffering")
      i4 = create(:item, name: "Cheese")
      i5 = create(:item, name: "Ring Pop")

      expect(Item.find_all_by_name("ring").count).to eq(3)
      expect(Item.find_all_by_name("ring")).to include(i1)
      expect(Item.find_all_by_name("ring")).to include(i3)
      expect(Item.find_all_by_name("ring")).to include(i5)
      expect(Item.find_all_by_name("ring")).to_not include(i2)
    end

    it 'can find all items in a search by minimum price' do
      i1 = create(:item, name: "Titanium Ring", unit_price: 51.0)
      i2 = create(:item, name: "Ring Pop", unit_price: 50.55)
      i3 = create(:item, name: "Suffering", unit_price: 48.00)
      i4 = create(:item, name: "Cheese", unit_price: 125)
      i5 = create(:item, name: "Goldfish", unit_price: 383.45)

      expect(Item.find_by_min_price(50.55).count).to eq(4)
      expect(Item.find_by_min_price(50.55)).to include(i2)
      expect(Item.find_by_min_price(50.55)).to_not include(i3)
      expect(Item.find_by_min_price(50.55)).to include(i5)
      expect(Item.find_by_min_price(50.55)).to include(i4)
    end


    it 'can find all items in a search by maximum price' do
      i1 = create(:item, name: "Titanium Ring", unit_price: 51.0)
      i2 = create(:item, name: "Ring Pop", unit_price: 50.55)
      i3 = create(:item, name: "Suffering", unit_price: 48.00)
      i4 = create(:item, name: "Cheese", unit_price: 125)
      i5 = create(:item, name: "Goldfish", unit_price: 383.45)

      expect(Item.find_by_max_price(50.55).count).to eq(2)
      expect(Item.find_by_max_price(50.55)).to include(i2)
      expect(Item.find_by_max_price(50.55)).to include(i3)
      expect(Item.find_by_max_price(50.55)).to_not include(i5)
    end


    it 'can find all items in price range' do
      i1 = create(:item, name: "Titanium Ring", unit_price: 51.0)
      i2 = create(:item, name: "Ring Pop", unit_price: 50.55)
      i3 = create(:item, name: "Suffering", unit_price: 48.00)
      i4 = create(:item, name: "Cheese", unit_price: 125)
      i5 = create(:item, name: "Goldfish", unit_price: 383.45)
      i6 = create(:item, name: "Cup", unit_price: 124.55)
  

      expect(Item.find_by_price_range(50.56, 125.50).count).to eq(3)
      expect(Item.find_by_price_range(50.56, 125.50)).to include(i1)
      expect(Item.find_by_price_range(50.56, 125.50)).to include(i4)
      expect(Item.find_by_price_range(50.56, 125.50)).to include(i6)
    end


  end




end
