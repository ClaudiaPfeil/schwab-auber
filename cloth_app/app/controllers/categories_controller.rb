class CategoriesController < ApplicationController
  before_filter :init_category, :action => [:edit, :update, :destroy, :show]
  

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new()
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to edit_category_path(@category), :notice => I18n.t(:category_created)
    else
      @category = @category
      @notice = I18n.t(:category_not_created)
      render :action => 'new'
    end
  end

  def edit;  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to edit_category_path(@category), :notice => I18n.t(:category_updated)
    else
      @category = @category
      @notice = I18n.t(:category_not_updated)
      render :action => 'edit'
    end
  end

  def show
    
  end

  def destroy
    @category.destroy if @category.destroyable?
    redirect_to categories_path
  end

  private

    def init_category
      init_current_object { @category = Category.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end

end
