module PackagesHelper

  def localized_collection_options_for_select(collection, scope)
    collection.map do |item|
      [ I18n.t(item, :scope => [ 'packages', scope ]), item ]
    end
  end

  # Premium Mitglieder dürfen neu eingestellte Pakete sofort einsehen & bestellen
  # Basis Mitglieder müssen 24 h warten
  def check_24h(package, user = nil)
    if user.nil?
      user = User.new(:role => 'guest')
    end

    if (user.is? :premium) || (user.is? :admin)
      true
    else
      created = package.created_at
      created < created + 24.hours ? true : false
    end
  end

  def show_24(user = nil)
    if user.nil? 
      user = User.new(:role => 'guest')
    end
    
    if (user.is? :premium) || (user.is? :admin)
      link_to I18n.t(:show_24), show_24_packages_path
    end
    
  end

  def make_link(content, title, translate)
    result = []
    
    content.to_a.each do |c|
      translate == false ? result << [link_to(c.to_s + " (#{Package.where("#{title.to_sym} LIKE '%#{c.to_s}%'").count})", search_remote_packages_path( title + "='#{c.to_s}'" ), :class => 'remote'), title + "='" + c.to_s + "'"] : result << [link_to(I18n.t(c.to_sym).to_s + " (#{Package.where("#{title.to_sym} LIKE '%#{c.to_s}%'").count})", search_remote_packages_path( title+ "='#{c.to_s}'" ), :class => 'remote'), title + "='" + c.to_s + "'"]
    end

    result
  end

  def make_link_strict(content, title, translate)
    result = []

    content.to_a.each do |c|
      translate == false ? result << [link_to(c.to_s + " (#{Package.where("#{title.to_sym} = '#{c.to_s}'").count})", search_remote_packages_path( title + "='#{c.to_s}'" ), :class => 'remote'), title + "='" + c.to_s + "'"] : result << [link_to(I18n.t(c.to_sym).to_s + " (#{Package.where("#{title.to_sym} = '#{c.to_s}'").count})", search_remote_packages_path( title + "='#{c.to_s}'" ), :class => 'remote'), title + "='" + c.to_s + "'"]
    end

    result
  end

  def make_link_special(content, title)
    result = []

    content.to_a.each do |c|
      result << [link_to(I18n.t(c.to_sym).to_s + " (#{Package.where("#{title.to_sym} LIKE '%#{I18n.t(c.to_sym).to_s}%'").count})", search_remote_packages_path( title  + "='#{I18n.t(c.to_sym)}'"  ), :class => 'remote'), title + "='" + c.to_s + "'"]
    end

    result
  end

  def owner?(user_id)
    user_id.to_i == current_user.id.to_i ? true : false
  end

  def get_amount(title, value)
    Package.where(title.to_sym => value.to_s).count
  end


end
