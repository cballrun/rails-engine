class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    merchant = Merchant.find_one(params[:name])
    render json: MerchantSerializer.new(merchant)
  end

end