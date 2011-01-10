# To change this template, choose Tools | Templates
# and open the template in the editor.

module ModelMethods

  def self.build_attribute_accessor(attributes)
    method_symbols = ""
    method_symbols << ":" << attributes.map { |value| '%s%s' % value}.join(',:') unless attributes.nil?
    #method_symbols
  end

  def self.attr_accessor(*method_symbols)
    method_symbols = method_symbols.to_s.gsub(":", "").gsub(" ", "").gsub("-", "_").split(/,/)

    method_symbols.each { | method |
      module_eval("def #{method.downcase}; return @#{method.downcase}; end")
    }

  end

  def translate(collection)
    collection.map { |word| I18n.t(word.to_sym)}
  end
    
end
