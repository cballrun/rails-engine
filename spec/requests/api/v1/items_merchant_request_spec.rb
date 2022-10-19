require 'rails_helper'

describe "Items Merchant API" do
  it 'can get an items merchant' do
    merch_1 = create(:merchant)
    merch_2 = create(:merchant)

    m1_item = create(:item, merchant: merch_1)
    m2_items = create_list(:item, 5, merchant: merch_2)

    get "/api/v1/items/#{m1_item.id}/merchant"
    
    merch_data = JSON.parse(response.body, symbolize_names: true)
    
    item_merch = merch_data[:data]

    expect(merch_data.count).to eq(1)
    expect(merch_data).to be_a(Hash)
  
    expect(item_merch[:id].to_i).to eq(merch_1.id)
    expect(item_merch[:type]).to eq("merchant")
    expect(item_merch[:attributes][:name]).to eq(merch_1.name)
  end
end