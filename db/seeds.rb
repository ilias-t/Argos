# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Organizations.delete_all
f = File.open("lib/assets/final.csv")

  lines = f.map do |line|
    line.split("\n")
  end
  lines.map! do |company|
    company.first.split(",")
  end
  lines.each do |company|
    Organizations.create(
      name: company[0].downcase,
      crunchbase_id: company[1].split("/").last,
      sector: company[2]
      )
  end


f.close
puts "THE MATRIX HAS YOU"
