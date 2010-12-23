# To change this template, choose Tools | Templates
# and open the template in the editor.

class CouponsController < ApplicationController

  def index

  end

  def show

  end

  def new
    @coupon = Coupon.new()
  end

  def create
    @coupon = Coupon.new(params[:coupon])
    if @coupon.save
      redirect_to coupons_path, :notice => I18n.t(:coupon_created)
    else
      render :action => :new, :notice => I18n.t(:coupon_not_created)
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  
end
