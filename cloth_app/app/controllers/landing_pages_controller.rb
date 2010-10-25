class LandingPagesController < ApplicationController
  layout "landing_page"

  def show
    category = Category.find_by_name("LandingPage")
    @landing_pages = category.contents
  end
 
end
