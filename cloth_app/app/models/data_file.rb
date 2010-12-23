# To change this template, choose Tools | Templates
# and open the template in the editor.

class DataFile < ActiveRecord::Base

  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "doc"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    name
  end

  def self.cleanup(dirname, filename)
    File.delete("#{RAILS_ROOT.to_s}/#{dirname}/#{filename}")  if File.exist?("#{RAILS_ROOT.to_s}/#{dirname}/#{filename}")
  end

end
