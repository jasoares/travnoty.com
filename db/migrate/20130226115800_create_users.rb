class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name
      t.string   :email, null: false

      # Authentication
      t.string   :username
      t.string   :password_hash, limit: 128, null: false
      t.string   :password_salt, limit: 128, null: false

      # Email confirmation
      t.datetime :confirmation_sent_at
      t.string   :confirmation_token
      t.datetime :confirmed_at

      # Password recover
      t.string   :reset_password_token
      t.datetime :reset_token_sent_at

      # User tracking
      t.integer  :sign_in_count, default: 0
      t.datetime :last_sign_in_at

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :password_hash
    add_index :users, :confirmation_token, unique: true
    add_index :users, :reset_password_token, unique: true

  end
end
