class Category < ActiveRecord::Base
  has_many :contents

  accepts_nested_attributes_for :contents

  def destroyable?
    false
  end

  def get_attr
    attributes = ""
    categories = Category.where(:description => 'package')
    categories.each do |cat|
      content = Content.find_by_category_id(cat.id)
      unless content.title == 'Menge' || content.title == 'Alter' || content.title == 'Kleidergröße' || content.title == 'Jahreszeit' || content.title == 'Colors'
        content.article.split(" ").each do |cont|
          attributes << ":" + (I18n.t(cont.to_sym).to_s).gsub(" ", "").gsub("-", "_").gsub("&", "").downcase + ", "
        end
      end
    end
    attributes
  end
  
end
