class ChangeUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.remove :lname
  		t.remove :email
  		t.remove :password_digest
  		t.string :profile_album_url, null: false
  	end
  end
end
