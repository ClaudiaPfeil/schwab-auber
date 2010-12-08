class BillsController < ApplicationController
  before_filter :init_bill, :on => [:show, :new, :edit, :destroy, :search]

  layout 'bills/bill'

  def index
    @bills = Order.all
  end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  def search
    
  end

  private

    def init_bill
      init_current_object { @bill = Order.find_by_id(params[:id].slice!) }
    end

    def init_current_object
      @current_object = yield
    end
  
end
