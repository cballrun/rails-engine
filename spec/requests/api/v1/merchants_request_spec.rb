require 'rails_helper'

describe "Merchants API" do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)
    
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchant_data = JSON.parse(response.body, symbolize_names: true)
    
    merchants = merchant_data[:data]
    
    expect(merchants.count).to eq(3)

    merchants.each do |merch|

      expect(merch).to have_key(:id)
      expect(merch[:id]).to be_a(String)

      expect(merch).to have_key(:type)
      expect(merch[:type]).to eq("merchant")

      expect(merch).to have_key(:attributes)
      expect(merch[:attributes]).to be_a(Hash)

      expect(merch[:attributes]).to have_key(:name)
      expect(merch[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant_data = JSON.parse(response.body, symbolize_names: true)
    
    merchant = merchant_data[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id].to_i).to eq(id)
   
    expect(merchant[:type]).to be_a(String)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  xit 'returns a 404 error for a non existent merchant id' do
    id = create(:merchant, id: 8).id

    get "/api/v1/merchants/9"

    expect(response).to_not be_successful
    expect(response).to have_http_status(404)
  end

  it 'can get all of one merchants items' do
    merch_1 = create(:merchant)
    merch_2 = create(:merchant)

    m1_items = create_list(:item, 5, merchant: merch_1)
    m2_items = create_list(:item, 5, merchant: merch_2)
    
  end

end