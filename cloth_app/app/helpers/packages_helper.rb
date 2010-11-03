module PackagesHelper

  def localized_collection_options_for_select(collection, scope)
      collection.map do |item|
        [ I18n.t(item, :scope => [ 'packages', scope ]), item ]
      end
  end

end
