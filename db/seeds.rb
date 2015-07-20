# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Photo.destroy_all

googleIMGs = ["https://lh3.googleusercontent.com/VjX6RfLuCcHQAlCULNHrN2AKAo2RxcDr_vJxfNwIP9E=w1680-h1114-no", "https://lh3.googleusercontent.com/B0oPUmgmYTpeSTmaP53GHQsP1ahnrGMLR1JJR8ODBY0=w1680-h1114-no", "https://lh3.googleusercontent.com/IHHQHQdA6JXVWVWyoxfmzFr3bFnzTbgU28bAq-n7p2E=w1680-h1114-no", "https://lh3.googleusercontent.com/ojRUktTFJoqyF_IfystLLGvsSwJuuC9-wUijzQ1iuxg=w1680-h1114-no", "https://lh3.googleusercontent.com/ioV6XPa8I8qGSJ-hHjtUTyKYn72mDwcTsNRvA8Tjarc=w1680-h1114-no", "https://lh3.googleusercontent.com/kWBRbv_hPkrlRjaf6_ux5MzkVN00omXbJTPb3lsSRQo=w1680-h1114-no"]

googleIMGs.each do |img|
	Photo.create({
		img_url: img,
		admin_id: 2
	})
end