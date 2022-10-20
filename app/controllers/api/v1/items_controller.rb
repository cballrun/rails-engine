class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render status: 404
    end
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: 201
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render status: 404
    end
  end

  def find_all
    if params[:name]
      render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
    elsif params[:max_price] && params[:min_price]
      render json: ItemSerializer.new(Item.find_by_price_range(params[:min_price], params[:max_price]))
    elsif params[:min_price]
      render json: ItemSerializer.new(Item.find_by_min_price(params[:min_price]))
    elsif params[:max_price]
      render json: ItemSerializer.new(Item.find_by_max_price(params[:max_price]))
    else
      "peepoop"
    end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end