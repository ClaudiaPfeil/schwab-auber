# To change this template, choose Tools | Templates
# and open the template in the editor.

class ClicksController
  before_filter :init_click, :action => [:edit, :show, :update, :destroy]

  def index

  end

  def show

  end

  def new

  end

  def edit

  end

  def update

  end

  def destroy

  end

  def search

  end

  private

    def init_click
      init_current_object { @click = Click.find_by_user_id(params[:id])}
    end

    def init_current_object
      @current_object =  yield
    end
end
