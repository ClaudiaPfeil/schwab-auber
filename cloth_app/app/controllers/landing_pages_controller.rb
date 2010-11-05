class LandingPagesController < ApplicationController
  layout "landing_page"

  def index
    redirect_to landing_page_path
  end

  def show
    category = Category.find_by_name("Landing_Page")
    @contents = category.contents
  end
 
end
