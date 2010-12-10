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

  def formatted_date(date)
    date.strftime("%d.%m.%Y") unless date.nil?
  end

  def create_header(titel)
    content = content_tag(:h1, titel)
    @content  = content_tag(:div, '', :class => "tr span-22")
    @content  << content_tag(:div, '', :class => "td first")
    @content  << content_tag(:div, content, :class => "td span-16")
    @content  << content_tag(:div, '', :class => "td last")
    @content  << content_tag(:br, '')
    @content
  end

  def create_header_with_link(titel, link, model, method)
    content = content_tag(:h1, titel)
    content_next = content_tag(:br, '')
    
    @content  = content_tag(:div, '', :class => "tr span-22")
    @content  << content_tag(:div, '', :class => "td first")
    @content  << content_tag(:div, content, :class => "td span-16")
    
    if can? method, model   
      content_next << link
      @content  << content_tag(:div, content_next, :class => "td span-4")
    end
    
    @content  << content_tag(:div, '', :class => "td last")
    @content  << content_tag(:br, '')
    @content
  end

  def create_header_with_form(titel, form)
    content = render :partial => form

    @content = content_tag(:div, ' ', :class => "td first")
    @content << content_tag(:div, ' ', :class => "td span-18")
    @content << content_tag(:h1, titel)
    @content << content_tag(:br, content)
    @content << content_tag(:div,' ', :class => "td last")

    @content

  end

  def create_div_with_form(form, additonal = nil)
    content = render :partial => form
    content_next = render :partial => additonal

    @content  = content_tag(:div, '', :class => "tr span-22")
    @content  << content_tag(:div, '', :class => "td first")
    @content  << content_tag(:div, content, :class => "td span-14")
    @content  << content_tag(:div, content_next , :class => "td span-6") if content_next
    @content  << content_tag(:div, '', :class => "td last")
    @content  << content_tag(:br, '')
    @content
  end
  
end
