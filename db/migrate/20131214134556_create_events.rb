class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.integer :money_limit
      t.integer :host_id
      t.boolean :has_started

      t.timestamps
    end
  end
end
