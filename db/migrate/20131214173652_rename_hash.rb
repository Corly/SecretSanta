class RenameHash < ActiveRecord::Migration
  def change
		rename_column :events, :hash, :event_hash
  end
end
