class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string     :address
      t.datetime   :confirmation_sent_at
      t.string     :confirmation_token
      t.datetime   :confirmed_at
      t.boolean    :main_address
      t.references :user

      t.timestamps
    end
    add_index :emails, :user_id
    add_index :emails, :address, unique: true
    add_index :emails, :confirmation_token, unique: true
    add_index :emails, [:user_id, :main_address], unique: true
    execute <<-SQL
      DROP INDEX index_emails_on_user_id_and_main_address;
      CREATE UNIQUE INDEX index_emails_on_user_id_and_main_address
        ON emails (user_id, main_address)
        WHERE main_address;
    SQL
  end
end
