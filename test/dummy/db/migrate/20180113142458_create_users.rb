class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.boolean :admin, default: false
      t.boolean :superadmin, default: false
      t.string :remember_digest
      t.string :portrait
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
