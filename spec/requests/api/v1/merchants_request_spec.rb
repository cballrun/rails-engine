require 'rails_helper'

describe "Merchants API" do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)
    
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(merchants.count).to eq(3)

    merchants.each do |merch|
      expect(merch).to have_key(:id)
      expect(merch[:id]).to be_a(Integer)

      expect(merch).to have_key(:name)
      expect(merch[:name]).to be_a(String)
    end
  end
end