require 'rails_helper'

describe "Merchants API" do
  describe 'retrieval' do
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
  end

  describe 'sad path' do
    it 'returns a 404 error for a non existent merchant id' do
      id = create(:merchant, id: 8).id

      get "/api/v1/merchants/9"

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end
  end

  describe 'search' do
    it "finds one merchant in a search" do
      m1 = create(:merchant, name: "Randy")
      m2 = create(:merchant, name: "Julian")
      m3 = create(:merchant, name: "Bubbles")
      m4 = create(:merchant, name: "Ring World")
      m5 = create(:merchant, name: "Turing School")
      m6 = create(:merchant, name: "Ring Yorld")
      m7 = create(:merchant, name: "Ring Zorld")
      
      get "/api/v1/merchants/find?name=ring"

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      merchant = merchant_data[:data]

      expect(merchant[:id].to_i).to eq(m4.id)
      expect(merchant[:attributes][:name]).to eq("Ring World")
    end
  end

end