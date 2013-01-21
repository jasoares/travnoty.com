class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :version
      t.references :server
      t.timestamps
    end
    add_index :rounds, :server_id
  end
end
