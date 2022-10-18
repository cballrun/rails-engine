require 'rails_helper'

describe "Merchants API" do
  it 'sends a list of merchants' do
    x = create_list(:merchant, 3)
    binding.pry
  end
end