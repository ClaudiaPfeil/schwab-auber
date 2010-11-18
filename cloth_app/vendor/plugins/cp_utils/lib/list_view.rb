# To change this template, choose Tools | Templates
# and open the template in the editor.

class ListView

  def get_table_columns(object, collection)
    tmp = collection
    table_cols = object.class.column_names.to_a
    tmp - table_cols
  end

  def get_entries(object, collection)
    entries = []
    table_columns = get_table_columns(object, collection)

    object.each do |entry|
      table_columns.each do |name|
        entries.push(entry.attributes[name.to_s])
      end
    end

    entries
    
  end

end
