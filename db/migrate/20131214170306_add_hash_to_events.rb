class AddHashToEvents < ActiveRecord::Migration
  def change
		add_column :events, :hash, :string 
  end
end
