class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.references :travian_account
      t.string :key
      t.integer :valid_for

      t.timestamps
    end
  end
end
