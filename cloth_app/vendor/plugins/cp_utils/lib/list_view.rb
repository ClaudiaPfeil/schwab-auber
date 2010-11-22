# To change this template, choose Tools | Templates
# and open the template in the editor.

class ListView

  def self.get_table_columns(object, collection)
    tmp = collection
    table_cols = object.column_names.to_a
    tmp - table_cols
  end

  def self.get_entries(model, object, collection)
    entries = []
    table_columns = get_table_columns(model, collection)

    object.each do |entry|
      table_columns.each do |name|
        entry.attributes[name.to_s].nil? ? entries.push(" ") : entries.push(entry.attributes[name.to_s])
      end
    end
    
    entries
    
  end

end
