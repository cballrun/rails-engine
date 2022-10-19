require 'rails_helper'

describe "Items Merchant API" do
  it 'can get an items merchant' do
    merch_1 = create(:merchant)
    merch_2 = create(:merchant)

    m1_item = create(:item, merchant: merch_1)
    m2_items = create_list(:item, 5, merchant: merch_2)

    get "/api/v1/items/#{m1_item.id}/merchants/#{merch_1.id}"
    
    # merch_item_data = JSON.parse(response.body, symbolize_names: true)

    # m1_items_data = merch_items_data[:data]

    # expect(merch_items_data).to be_a(Hash)
    # expect(merch_items_data.count).to eq(1)

    # expect(m1_items_data.count).to eq(5)

    # m1_items_data.each do |item|
    #   expect(item[:id].to_i).to be_a(Integer)
    #   expect(item[:type]).to eq("item")
      
    #   expect(item[:attributes].count).to eq(4)
    #   expect(item[:attributes][:unit_price]).to be_a(Float)
  
    #   expect(item[:attributes][:merchant_id]).to eq(merch_1.id)
    # end
  end
end