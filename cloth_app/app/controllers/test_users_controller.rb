class UsersController < ApplicationController
  before_filter :init_user, :action => {:show, :edit, :update, :destroy}

  def index
    @users = User.all
  end

  def show
    redirect_to edit_User_path
  end

  def new
    @user = User.new()
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to edit_user_path(@user), :notice => 'User successfully created'
    else
      flash[:error] = "User doesn't saved"
      render  :action => 'new'
    end
  end

  def edit; end

  def update
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user), :notice => 'User successfully updated'
    else
      flash[:error] = 'User not updated'
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy if @user.destroyable?
    redirect_to users_path
  end

  private

    def init_user
      init_current_object { @user = User.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end

end
