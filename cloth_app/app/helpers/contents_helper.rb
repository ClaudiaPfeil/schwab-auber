module ContentsHelper

  def create_path(string)
    "%s?preview=true" % string
  end

  def select_cols
    snippet = "<div class='tr'>"
      Content.columns.each do |content|
        snippet + "<div class='td'><b>" + content.name.to_s.camelize + "</b></div>"
      end
    snippet + "</div>"
  end


end
