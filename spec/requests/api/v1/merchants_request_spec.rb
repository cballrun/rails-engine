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
  end
end