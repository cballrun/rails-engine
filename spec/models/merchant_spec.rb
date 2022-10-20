require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items}
  end

  describe 'class methods' do
    it 'can find one merchant who is first in alphabetical order by name with a partial search' do
      m1 = create(:merchant, name: "Randy")
      m2 = create(:merchant, name: "Julian")
      m3 = create(:merchant, name: "Bubbles")
      m4 = create(:merchant, name: "Ring World")
      m5 = create(:merchant, name: "Turing School")
      m6 = create(:merchant, name: "Ring Yorld")
      m6 = create(:merchant, name: "Ring Zorld")

      
      expect(Merchant.find_one("ring")).to eq(m4)
    end
  end

end