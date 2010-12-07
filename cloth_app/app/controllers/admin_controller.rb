# Titel:  Admin Controller
# Autor:  Claudia Pfeil
# Datum:  07.12.10
# Beschreibung: Administration von KidsKarton.de,z.B. Anzeige der Clicks der geworbenen Kunden und von wem sie geworben worden

class AdminController < ApplicationController

  def index

  end

  def show
    
  end

  def new

  end

  def create

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

    def init_admin
      current_object { @admin = Admin.find_by_id(params[:id])}
    end

    def current_object
      @current_object = yield
    end
  
end
