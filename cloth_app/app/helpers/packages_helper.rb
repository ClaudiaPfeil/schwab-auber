module PackagesHelper

  def localized_collection_options_for_select(collection, scope)
    collection.map do |item|
      [ I18n.t(item, :scope => [ 'packages', scope ]), item ]
    end
  end

  # Premium Mitglieder dürfen neu eingestellte Pakete sofort einsehen & bestellen
  # Basis Mitglieder müssen 24 h warten
  def check_24h(package)
    if (current_user.is? :premium) || (current_user.is? :admin)
      true
    else
      created = package.created_at
      tag = created + 24*60*60
      created < tag  ? true : false
    end
  end

end
