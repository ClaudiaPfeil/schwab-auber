module ApplicationHelper

  def get_notices
    result = ''
    if params[:notice]
      params[:notice].each do |notice|
          result += notice.to_s
      end
    elsif flash[:warning] || flash[:notice] || flash[:error]
      flash[:warning] ? result += flash[:warning].to_s : ( flash[:notice] ? result += flash[:notice].to_s : result += flash[:error].to_s)
    end
    @content = content_tag(:div, result, :class => 'notice') unless result.blank?
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

  def create_list_table_with_ar(ar, titles)
    @content = content_tag(:div, '', :class => "tr span-22")
    @content << content_tag(:div, '', :class => "td first")
    
    titles.each do |title|
      
      if title.to_s == "created_at"
        entry = formatted_date(ar.first.attributes[title.to_s]) unless ar.blank?
      else
        entry = ar.first.attributes[title.to_s] unless ar.blank?
      end
      
      @content << content_tag(:div, entry , :class => "td span-4")
      
    end
     
    @content << content_tag(:div, '', :class => "td last")
    @content << content_tag(:br, '')
    @content

  end

  def create_list_table_with_hash(ar, titles)
    @content = content_tag(:div, '', :class => "tr span-22")
    @content << content_tag(:div, '', :class => "td first")
   
    titles.each do |title|
      if title.to_s == "created_at"
        entry = formatted_date(ar.first[1].attributes[title.to_s]) unless ar.blank? || ar.nil?
      elsif title.to_s == "amount"
        entry = ar.first[0] unless ar.blank? || ar.nil?
      elsif title.to_s == "membership"
        ar.first[1].attributes[title.to_s] == 1 ? entry = "Premium" : entry = "Basis" unless ar.blank? || ar.nil?
      else
        entry = ar.first[1].attributes[title.to_s] unless ar.blank? || ar.nil?
      end
      
      @content << content_tag(:div, entry , :class => "td span-4")
    end

    @content << content_tag(:div, '', :class => "td last")
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

  
  def get_price
    price = 0.0
    user = current_user
    membership = user.membership
    prices = Price.find_by_kind(membership)

    if user.is_premium?
      period = user.period
      case period
        when 3  :   price += prices.shipping
        when 6  :   price += prices.shipping
        when 12 :   price += prices.shipping - 1.0
      end
    else
      price += prices.shipping.to_f + prices.handling.to_f
    end
    price.to_s.gsub(".","")
  end

  def get_mwst
    brut_price = get_price
    (brut_price - (brut_price.to_f / 1.19)).round(2)
  end

  def get_net_price
    (get_price.to_f / 1.19).round(2)
  end
  
end
