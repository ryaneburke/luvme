class AddReferrerIdtoUsers < ActiveRecord::Migration
  def change
  	add_column :users, :referrer_id, :string
  end
end
