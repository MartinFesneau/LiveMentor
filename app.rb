require_relative "converter"

puts "Welcome to the LiveMentor JSON to CSV app"
puts "#########################################"
puts "Please enter the JSON URL:"
print "> "
url = gets.chomp

convert(url)
