class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |p|
      p.string    :name
      p.integer   :size
      p.integer   :next_size
      p.integer   :age
      p.string    :saison
      p.text      :kind
      p.integer   :amount_clothes
      p.string    :label
      p.integer   :amount_labels
      p.string    :colors
      p.text      :notice
      p.string    :sex

      p.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
