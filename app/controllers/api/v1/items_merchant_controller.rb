class Api::V1::ItemsMerchantController < ApplicationController

  # def index
  #   merch = Merchant.find(params[:merchant_id])
  #   render json: MerchantSerializer.new(Merchant.find(params[:id]))
  # end

  def show
    item = Item.find(params[:item_id])
    render json: MerchantSerializer.new(item.merchant)
  end
end