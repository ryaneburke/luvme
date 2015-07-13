class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :fname, null: false
    	t.string :lname, null: false
    	t.string :email, null: false, unique: true
    	t.string :gender, null: false
    	t.string :target_gender
    	t.string :password_digest
    	t.timestamps
    end
  end
end
