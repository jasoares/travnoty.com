class CreateTravianAccounts < ActiveRecord::Migration
  def change
    create_table :travian_accounts do |t|
      t.references :round
      t.references :user
      t.integer :uid
      t.string :username

      t.timestamps
    end
    add_index :travian_accounts, :round_id
    add_index :travian_accounts, :user_id
    add_index :travian_accounts, [:username, :round_id], unique: true
  end
end
