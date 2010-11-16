module ApplicationHelper

  def get_notices
    if params[:notice]
     result = "<div class='notice'>"
     params[:notice].each do |notice|
          result = + notice.to_s
     end
    result = + "</div>"
    result
   end
  end
end
