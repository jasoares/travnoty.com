class CreateHubs < ActiveRecord::Migration
  def change
    create_table :hubs do |t|
      t.string :name
      t.string :host
      t.string :code
      t.string :language
      t.timestamps
    end
    add_index :hubs, :host, :unique => true
    add_index :hubs, :code, :unique => true
  end
end
