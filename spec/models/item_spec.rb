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
  end


end
