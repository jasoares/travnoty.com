class AddIndexToServersOnHost < ActiveRecord::Migration
  def change
    add_index :servers, :host, :unique => true
  end
end
