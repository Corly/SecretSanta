class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :auth_token
      t.string :uid

      t.timestamps
    end
  end
end
