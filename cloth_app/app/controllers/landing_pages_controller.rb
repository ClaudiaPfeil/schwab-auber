class LandingPagesController < ApplicationController
  include Cms
  layout "landing_page"

  def index
    redirect_to landing_page_path
  end

  # Titel: Anzeige der LandingPage
  # Beschreibung: Tracking der Clicks durch gesetztes Cookie  & Zuordnung zu dem einladenden Kunden falls vorhanden
  def show
    if params[:id]
      user_id = params[:id].slice!
      # breef if cookie exist? otherwise set cookie with user_id
      if cookies[:invited]
        cookie_key = cookies[:invited].split("cookie_key").second.split("remote_ip").first
        click = Click.find_by_user_id_and_cookie_key(user_id, cookie_key)
        click.update_attribute(:number, click.number + 1)
      else
        set_cookie(user_id)
        cookie = cookies[:invited]
        Click.create(cookie)
      end
      # save user data in table
      
    end
    @contents = get_content("LandingPage")
  end

  private
  
    def set_cookie(user_id)
      cookies[:invited] = {
                            :value => {:user_id => user_id,
                                       :number => 1,
                                       :remote_ip => request.remote_ip,
                                       :cookie_key  =>  NumberGenerator.alphanumeric({:prefix => "CO-", :length => 9}),
                                       :clicker_key =>  NumberGenerator.alphanumeric({:prefix => "CU-", :length => 9}),
                                       :cookie_expires_at  => 3.months.from_now
                                      },
                            :expires => 3.months.from_now
                          }
    end
end
