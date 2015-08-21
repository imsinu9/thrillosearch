# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

json = ActiveSupport::JSON.decode(File.read('db/seeds.json'))

puts "Seeding Cities"
json["cities"].each do |city|
  City.create!(name: city['name'])
end
puts "#{json['cities'].length} Cities Added"

puts "Seeding Tags"
json["tags"].each do |tag|
  Tag.create!(name: tag['name'])
end
puts "#{json['tags'].length} Tags Added"

puts "Seeding Tours"
json["tours"].each do |tour|
  city = City.find_by_name(tour['city_name'].titleize)
  Tour.create!(name: tour['name'], city: city)
end
puts "#{json['tours'].length} Tours Added"
