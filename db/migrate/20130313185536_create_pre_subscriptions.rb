class CreatePreSubscriptions < ActiveRecord::Migration
  def change
    create_table :pre_subscriptions do |t|
      t.string :email
      t.string :name
      t.references :hub

      t.timestamps
    end

    add_index :pre_subscriptions, :email, unique: true
    add_index :pre_subscriptions, :hub_id
  end
end
