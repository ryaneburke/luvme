class DropViewerTables < ActiveRecord::Migration
  def change
  	drop_table :viewers
  end
end
