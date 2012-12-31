class CreateHubsServers < ActiveRecord::Migration
  def change
    create_table :hubs_servers, :id => false do |t|
      t.references :hub
      t.references :server
    end
    add_index :hubs_servers, [:hub_id, :server_id], :unique => true
  end
end
