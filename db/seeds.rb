# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Sector.delete_all
f = File.open("lib/assets/category_export.csv")

  lines = f.map do |line|
    line.split("\n")
  end
  lines.map! do |company|
    company.first.split(",")
  end
  lines.each do |company|
    Sector.create(
      company: company[0].split("/").last,
      sector: company[1]
      )
  end


f.close
puts "THE MATRIX HAS YOU"
