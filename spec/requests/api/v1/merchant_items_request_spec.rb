require 'rails_helper'

describe "Merchant Items API" do
  it 'can get all of one merchants items' do
    merch_1 = create(:merchant)
    merch_2 = create(:merchant)

    m1_items = create_list(:item, 5, merchant: merch_1)
    m2_items = create_list(:item, 5, merchant: merch_2)

    get "/api/v1/merchants/#{merch_1.id}/items"
    
    merch_items_data = JSON.parse(response.body, symbolize_names: true)

    m1_items_data = merch_items_data[:data]

    expect(merch_items_data).to be_a(Hash)
    expect(merch_items_data.count).to eq(1)

    expect(m1_items_data.count).to eq(5)

    m1_items_data.each do |item|
      expect(item[:id].to_i).to be_a(Integer)
      expect(item[:type]).to eq("item")
      
      expect(item[:attributes].count).to eq(4)
      expect(item[:attributes][:unit_price]).to be_a(Float)
  
      expect(item[:attributes][:merchant_id]).to eq(merch_1.id)
    end
  end

  describe 'sad path' do
    it 'returns a 404 error for a non existent merchant id' do
      id = create(:merchant, id: 8).id

      get "/api/v1/merchants/9/items"

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end
  end
end