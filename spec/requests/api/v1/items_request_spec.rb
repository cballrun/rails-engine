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
      expect(item[:attributes]).to have_key(:merchant_id)
    end
  end

  it 'can get one item by its id' do
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
    expect(item[:attributes][:unit_price]).to be_a(Float)
    expect(item[:attributes]).to have_key(:merchant_id)
  end

  it 'can create a new item' do
    merchant = create(:merchant)
    item_params = ({
      name: "Plumbus",
      description: "A plain old plumbus",
      unit_price: 384.04,
      merchant_id: merchant.id
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to be_successful

    new_item = Item.last
    
    expect(new_item.name).to eq(item_params[:name])
    expect(new_item.description).to eq(item_params[:description])
    expect(new_item.unit_price).to eq(item_params[:unit_price])
    expect(new_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can destroy an item' do
    item = create(:item)

    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{item.id}"
  
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Plumbus" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
  
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Plumbus")
  end

  it 'can find all items in a search by name' do
    merch = create(:merchant)
    
    i1 = create(:item, name: "Titanium Ring", merchant: merch)
    i2 = create(:item, name: "Ring Pop", merchant: merch)
    i3 = create(:item, name: "Suffering", merchant: merch)
    i4 = create(:item, name: "Cheese")
    i5 = create(:item, name: "Goldfish")

    get "/api/v1/items/find_all?name=ring"

    items_data = JSON.parse(response.body, symbolize_names: true)

    items = items_data[:data]
    
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item[:id].to_i).to be_a(Integer)
      expect(item[:type]).to eq("item")
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to eq(merch.id)
    end
  end

  it 'can find items in a search equal to or below a minimum price' do
    i1 = create(:item, name: "Titanium Ring", unit_price: 51.0)
    i2 = create(:item, name: "Ring Pop", unit_price: 50.55)
    i3 = create(:item, name: "Suffering", unit_price: 48.00)
    i4 = create(:item, name: "Cheese", unit_price: 125)
    i5 = create(:item, name: "Goldfish", unit_price: 383.45)

    get "/api/v1/items/find_all?min_price=50.55"

    items_data = JSON.parse(response.body, symbolize_names: true)

    items = items_data[:data]

    expect(items.count).to eq(4)

    items.each do |item|
      expect(item[:id].to_i).to be_a(Integer)
      expect(item[:type]).to eq("item")
      expect(item[:attributes][:description]).to be_a(String)
    end
  end

  it 'can find items in a search equal to or below a maximum' do
    i1 = create(:item, name: "Titanium Ring", unit_price: 51.0)
    i2 = create(:item, name: "Ring Pop", unit_price: 50.55)
    i3 = create(:item, name: "Suffering", unit_price: 48.00)
    i4 = create(:item, name: "Cheese", unit_price: 125)
    i5 = create(:item, name: "Goldfish", unit_price: 383.45)
  
    get "/api/v1/items/find_all?max_price=50.55"
  
    items_data = JSON.parse(response.body, symbolize_names: true)
  
    items = items_data[:data]
  
    expect(items.count).to eq(2)
  
    items.each do |item|
      expect(item[:id].to_i).to be_a(Integer)
      expect(item[:type]).to eq("item")
      expect(item[:attributes][:description]).to be_a(String)
    end
  end

  it 'can find items in a search between a minimum and maximum price' do
    i1 = create(:item, name: "Titanium Ring", unit_price: 51.0)
    i2 = create(:item, name: "Ring Pop", unit_price: 50.55)
    i3 = create(:item, name: "Suffering", unit_price: 48.00)
    i4 = create(:item, name: "Cheese", unit_price: 125)
    i5 = create(:item, name: "Goldfish", unit_price: 383.45)
    i6 = create(:item, name: "Cup", unit_price: 124.55)

    get "/api/v1/items/find_all?max_price=125.50&min_price=50.56"

    items_data = JSON.parse(response.body, symbolize_names: true)

    items = items_data[:data]
    
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item[:id].to_i).to be_a(Integer)
      expect(item[:type]).to eq("item")
      expect(item[:attributes][:description]).to be_a(String)
    end
  end

  describe 'sad path' do
    context 'item show' do
      it 'returns a 404 error for a non existent item id' do
        id = create(:item, id: 8).id

        get "/api/v1/items/9"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end

    context 'item update' do
      xit 'returns a 404 for a non existent item id' do
        item = create(:item)
        # binding.pry
        item_params = { name: "Plumbus" }
        headers = {"CONTENT_TYPE" => "application/json"}
        new_id = item.id + 15
      
        patch "/api/v1/items/#{new_id}", headers: headers, params: JSON.generate({item: item_params})

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
        expect(Item.last.name).to eq(item.name)
      end

      xit 'returns a 404 for a non existent merchant id' do
        merch = create(:merchant, id: 58)
        item = create(:item, merchant: merch)
        item_params = { name: "Plumbus" }
       
        item.merchant_id = merch.id + 100
       
        headers = {"CONTENT_TYPE" => "application/json"}
        
        patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
        expect(Item.last.name).to eq(item.name)
      end
    end
  end

end