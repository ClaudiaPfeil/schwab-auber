class CategoriesController < ApplicationController
  before_filter :init_category, :action => {:edit, :update, :destroy, :show}
  before_filter :login_required
  #load_and_authorize_resource :through => :contents
  

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new()
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to edit_category_path(@category), :notice => "Category successfully created"
    else
      render :action => 'new'
    end
  end

  def edit;  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to edit_category_path(@category), :notice => "Category successfully updated"
    else
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
