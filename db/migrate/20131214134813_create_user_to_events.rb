class CreateUserToEvents < ActiveRecord::Migration
  def change
    create_table :user_to_events do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
  end
end
