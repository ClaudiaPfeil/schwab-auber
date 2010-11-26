# Titel:  Preise-Kontroller
# Autor:  Claudia Pfeil
# Datum:  26.11.2010

class PricesController < ApplicationController
  before_filter :init_price, :action  =>  [:show, :edit, :update, :destroy]

  def index
    @prices = Price.all
  end

  def show; end

  def new
    @price  = Price.new()
  end

  def create
    @price  = Price.new(params[:price])
    if @price.save
      redirect_to prices_path, :notice  =>  :price_created
    else
      render  :action =>  "new",  :notice =>  :price_not_created
    end
  end

  def edit; end

  def update
    if @price.update_attributes(params[:price])
      redirect_to prices_path, :notice  =>  :price_updated
    else
      render  :action =>  'edit', :notice =>  :price_not_updated
    end
  end

  def destroy
   @price.destroy if @price.is_destroyable?
   redirect_to  prices_path
  end

  private
    def init_price
      init_current_object { @price  = Price.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end

end
