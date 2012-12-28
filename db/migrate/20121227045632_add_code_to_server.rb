class AddCodeToServer < ActiveRecord::Migration
  def change
    add_column :servers, :code, :string
  end
end
