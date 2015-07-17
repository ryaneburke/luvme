class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
    	t.string :img_url, null: false
    	t.integer :user_id
    end
  end
end
