class Api::V1::MerchantItemsController < ApplicationController

  def index
    merch = Merchant.find(params[:merchant_id])
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end