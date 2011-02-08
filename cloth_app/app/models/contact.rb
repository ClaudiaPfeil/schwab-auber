# To change this template, choose Tools | Templates
# and open the template in the editor.

class Contact < ActiveRecord::Base

  attr_accessor :receiver, :street_and_number, :postcode, :town, :message, :email, :telephone, :mobile, :title, :land
  
  validates_presence_of :receiver, :street_and_number, :postcode, :town, :email, :telephone, :message

  def self.columns
    @columns ||= [];
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
      sql_type.to_s, null)
  end

  # Override the save method to prevent exceptions.
  def save(validate = true)
    validate ? valid? : true
  end
  
end
