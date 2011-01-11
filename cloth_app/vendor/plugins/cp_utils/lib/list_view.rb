# To change this template, choose Tools | Templates
# and open the template in the editor.

class ListView

  def self.get_table_columns(object, collection)
    tmp = collection
    table_cols = object.column_names.to_a
    tmp - table_cols
  end

  def self.get_entries(model, entry, collection, options = nil)
    entries = []
    table_columns = get_table_columns(model, collection)
    
    table_columns.each do |name|
      if options
        
        options.each do |key, value|
          if key.to_s == name.to_s
            relation = (value.to_s.camelize.constantize).find_by_id(entry.attributes[value.to_s + "_id"]) unless entry.nil?
            relation.attributes[name.to_s].nil? ? entries.push(" ") : entries.push(relation.attributes[name.to_s]) unless entry.nil?
          end
        end

        if name.to_s == "created_at" || name.to_s == "updated_at"
          entry.attributes[name.to_s].nil? ? entries.push(" ") : entries.push(self.formatted_date(entry.attributes[name.to_s])) unless entry.nil?
        elsif entry.attributes[name.to_s]
          entries.push(entry.attributes[name.to_s]) unless entry.nil?
        end
      else
        if name.to_s == "created_at" || name.to_s == "updated_at"
          entry.attributes[name.to_s].nil? ? entries.push(" ") : entries.push(self.formatted_date(entry.attributes[name.to_s])) unless entry.nil?
        else
          entry.attributes[name.to_s].nil? ? entries.push(" ") : entries.push(entry.attributes[name.to_s]) unless entry.nil?
        end
      end

    end
    
    entries
    
  end

  def self.formatted_date(date)
    date.strftime("%d.%m.%Y") unless date.nil?
  end

end
