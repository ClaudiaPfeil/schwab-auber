class CreateTableBankDetails < ActiveRecord::Migration
  def self.up
    create_table  :bank_details do |b|
      b.integer :user_id
      b.string  :name
      b.integer :bank_code
      b.integer :account_number
      b.integer :balance
      b.boolean :prepayment_confirmed
      b.boolean :kind

      b.timestamps
    end
  end

  def self.down
    drop_table  :bank_details
  end
end
