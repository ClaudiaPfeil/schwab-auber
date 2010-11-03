class PackagesController < ApplicationController
  before_filter :init_package, :action => [:show, :edit, :update, :destroy]
  before_filter :login_required
  load_and_authorize_resource

  def index
    @packages = Package.where(:user_id => current_user.id)
  end

  def show
    redirect_to packages_path(@package)
  end

  def new
    @package = Package.new()
  end

  def create
    @package = Package.new(params[:packages])

    if @package.save
      redirect_to packages_path(@package), :notice => "Package created successfully"
    else
      render :action => 'new', :notice => "Package wasn't created"
    end
    
  end

  def edit; end

  def update
    if @package.update_attributes(params[:package])
      redirect_to packages_path(@package), :notice => "Package updated successfully"
    else
      render :action => 'edit', :notice => "Package wasn't updated"
    end
  end

  def destroy
    @package.destroy if @package.destroyable?
    redirect_to packages_path
  end

  def search
    search_type, search_key = params[:search_type], params[:search_key]
    Package.search_by_attributes(search_key, search_type)#.paginate(pagination_defaults)
  end

  private

    def init_package
      init_current_object { @package = Package.where(:id => params[:id], :user_id => current_user.id)}
    end

    def init_current_object
      @current_object = yield
    end
end
