class CreateViewers < ActiveRecord::Migration
  def change
    create_table :viewers do |t|
    	t.string :fname, null: false
    	t.string :gender
    	t.string :profile_album_url, null: false
    	t.timestamps
    end
  end
end
