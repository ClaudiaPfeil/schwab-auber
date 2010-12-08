# To change this template, choose Tools | Templates
# and open the template in the editor.

class LeadsController
  before_filter :init_lead, :action => [:show, :edit, :update, :destroy]

  def index

  end

  def show

  end

  def new

  end

  def create

  end

  def update

  end

  def destroy

  end

  private

    def init_lead
      init_current_object { @lead = Lead.find_by_user_id(params[:id])  }
    end

    def init_current_object
      @current_object = yield
    end
end
