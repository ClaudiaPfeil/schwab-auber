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

  def make_link(content)
    result = []
    
    content.to_a.each do |c|
      result << [link_to(c, search_remote_packages_path(c)), c]
    end

    result
  end

  def owner?(user_id)
    user_id.to_i == current_user.id.to_i ? true : false
  end


end
