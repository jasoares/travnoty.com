class AddClientKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :client_key, :string
  end
end
