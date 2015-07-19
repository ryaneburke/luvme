class RemoveUserIDfromPhotosTable < ActiveRecord::Migration
  def change
  	change_table :photos do |t|
  		t.integer :admin_id
  		t.remove :user_id
  	end
  end
end
