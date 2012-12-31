class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name
      t.string :code
      t.string :host
      t.integer :speed
      t.date :start_date
      t.date :end_date
      t.string :version
      t.string :world_id
      t.timestamps
    end
    add_index :servers, :host, :unique => true
  end
end
