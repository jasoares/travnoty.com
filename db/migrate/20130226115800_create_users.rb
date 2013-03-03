class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name
      # Authentication
      t.string   :username
      t.string   :password_hash
      t.string   :password_salt
      # Password recover
      t.string   :reset_password_token
      t.datetime :reset_token_sent_at
      # User tracking
      t.integer  :sign_in_count, default: 0
      t.datetime :last_sign_in_at

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :password_hash
    add_index :users, :reset_password_token, unique: true

  end
end
