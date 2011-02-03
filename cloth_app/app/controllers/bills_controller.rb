class BillsController < ApplicationController
  require 'princely'
  before_filter :init_bill, :on => [:show, :new, :edit, :destroy, :search]

  layout 'bills/bill'

  def index
    @bills = Order.all if current_user
  end

  def show
    respond_to do |format|
      format.html

      format.pdf do
        render :pdf => "Rechnung", :stylesheets => ["pdf", "blueprint/src/grid"], :layout => "bills/bill"
      end
    end
  end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  def search
    
  end

  private

    def init_bill
      init_current_object { @bill = Order.find_by_id(params[:id]) }
    end

    def init_current_object
      @current_object = yield
    end
  
end
