# To change this template, choose Tools | Templates
# and open the template in the editor.

module Cms
    def get_content(title)
      category = Category.find_by_name(title)
      @contents = category.contents unless category.contents.nil?
    end
end