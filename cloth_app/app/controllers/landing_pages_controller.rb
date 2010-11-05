class LandingPagesController < ApplicationController
  include Cms
  layout "landing_page"

  def index
    redirect_to landing_page_path
  end

  def show
    @contents = get_content("Landing_Page")
  end
 
end
