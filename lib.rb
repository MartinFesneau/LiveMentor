
require 'csv'
require 'json'
require 'open-uri'

puts "Welcome to the LiveMentor JSON to CSV app"
puts "#####################################"
puts "Please enter the JSON URL:"
print "> "
url = gets.chomp

# # get json data into ruby hash
data_serialized = open(url).read
json = JSON.parse(data_serialized)


def get_recursive_keys(hash, nested_key=nil)
  hash.each_with_object([]) do |(k,v),keys|
    k = "#{nested_key}.#{k}" unless nested_key.nil?
    if v.is_a? Hash
      keys.push(*get_recursive_keys(v, k))
    else
      keys << k
    end
  end
end


headers = []
json.each do |hash|
  headers.push(*get_recursive_keys(hash))
end

headers = headers.uniq

CSV.open('output.csv', 'wb') do |csv|
  csv << headers
  json.each do |hash|
    row = headers.map do |h|
      v = hash.dig(*h.split('.'))       # Dig out the (possibly) nested value
      v.is_a?(Array) ? v.join(', ') : v  # Fix up arrays
    end
    csv << row
  end
end

puts "CSV file created, type '$ open output.csv' to open it"