class Evaluation < ActiveRecord::Base
  has_one :package
  has_many :users
  
end
