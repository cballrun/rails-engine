class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render status: 404
    end
  end

  def find
    if !Merchant.find_one(params[:name]).nil?
      merchant = Merchant.find_one(params[:name])
      render json: MerchantSerializer.new(merchant)
    else
      render json: { data: {} }
    end
  end

end