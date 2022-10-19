require 'rails_helper'

describe "Items API" do
  it 'sends a list of items' do
    create_list(:item, 3)
    
    get '/api/v1/items'

    expect(response).to be_successful

    item_data = JSON.parse(response.body, symbolize_names: true)


    
    items = item_data[:data]
    
    expect(items.count).to eq(3)

    items.each do |item|

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes].count).to eq(4)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  xit 'can get one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item_data = JSON.parse(response.body, symbolize_names: true)
    
    item = item_data[:data]

    expect(item).to have_key(:id)
    expect(item[:id].to_i).to eq(id)
   
    expect(item[:type]).to be_a(String)
    expect(item[:type]).to eq("item")

    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)
    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)
  end

  xit 'returns a 404 error for a non existent item id' do
    id = create(:item, id: 8).id

    get "/api/v1/items/9"

    expect(response).to_not be_successful
    expect(response).to have_http_status(404)
  end

end