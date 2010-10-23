class LandingPagesController < ApplicationController
  layout "landing_page"
  before_filter :login_required

  def show
    category = Category.find_by_name("LandingPage")
    @landing_pages = category.contents
  end
 
end
