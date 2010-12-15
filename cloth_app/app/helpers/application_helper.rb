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

  def create_link(link, model, method)
    @content  = content_tag(:div, '', :class => "tr span-22")
    @content  << content_tag(:div, '', :class => "td first")

    if can? method, model
      @content  << content_tag(:div, link, :class => "td span-22 right")
    end

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

  def create_header2_with_link(titel, link, model, method)
    content = content_tag(:h2, titel)
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
  
  def create_table_header(cols)
    @content = content_tag(:div, '', :class => "tr span-22")
    @content << content_tag(:div, '', :class => "td first")
    cols.each do |col|
      @content << content_tag(:b, I18n.t(col.to_s), :class => "td span-4")
    end
    @content << content_tag(:div, '', :class => "td last")
    @content << content_tag(:br, '')
    @content
  end

  def create_list_table(rows, model)
    
    rows.each do |row|
      @content = content_tag(:div, '', :class => "tr span-22")
      @content << content_tag(:div, '', :class => "td first")
      
      cols = ListView.get_entries(model, row, [:full_name, :serial_number, :kind, :created_at], {:full_name => :user, :serial_number => :package})
      if cols
        cols.each do |col|
          @content << content_tag(:div, col.to_s, :class => "td span-4")
        end
      end
      @content << content_tag(:div, '', :class => "td last")
      
    end
    
    @content << content_tag(:br, '')
    @content

  end

  def create_table_list_view(cols)

    @content = content_tag(:div, '', :class => "tr span-22")
    @content << content_tag(:div, '', :class => "td first")

    if cols
      cols.each do |col|
        if col == 0 || col == 1
          col == true ? col = "Ja" : col = "Nein"
        end
        
        @content << content_tag(:div, col, :class => "td span-4")
      end
    end
    @content << content_tag(:div, '', :class => "td last")


    @content << content_tag(:br, '')
    @content

  end

  def create_table_list_view_with_link(link, model, method, cols)

    @content = content_tag(:div, '', :class => "tr span-22")
    @content << content_tag(:div, '', :class => "td first")

    if cols
      cols.each do |col|
        if col == 0 || col == 1
          col == true ? col = "Ja" : col = "Nein"
        end

        @content << content_tag(:div, col, :class => "td span-4")
      end
    end

    if can? method, model
      @content  << content_tag(:div, link, :class => "td last")
    end

    @content << content_tag(:br, '')
    @content

  end
  
end
