# To change this template, choose Tools | Templates
# and open the template in the editor.

module Cms
    def get_content(title)
      category = Category.find_by_name(title)
      category.contents unless category.contents.nil? || category.nil?
    end
end
