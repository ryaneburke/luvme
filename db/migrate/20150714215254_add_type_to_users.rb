class AddTypeToUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.string :type
  		t.string :profile_album_id, null: false
  		t.string :email
  		t.string :location
  		t.string :hero_pic_url
  		t.remove :profile_album_url
  	end
  end
end
