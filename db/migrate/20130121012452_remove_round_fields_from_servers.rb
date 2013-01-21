class RemoveRoundFieldsFromServers < ActiveRecord::Migration
  def change
    remove_index :servers, :end_date
    remove_column :servers, :start_date
    remove_column :servers, :end_date
    remove_column :servers, :version
  end
end
