require 'csv'
require 'json'
require 'open-uri'

puts "Welcome to the LiveMentor JSON to CSV app"
puts "#########################################"
puts "Please enter the JSON URL:"
print "> "
url = gets.chomp

# verify if the given URL is JSON.
if url[-4..-1] != "json"
  puts "This is not a JSON Url, please enter a valid url"
  return
end
# get json data into ruby hash
data_serialized = open(url).read
json = JSON.parse(data_serialized)

def get_absolute_path(hash, nested_key=nil)
  hash.each_with_object([]) do |(k,v),keys|
    # if there is no nested key, return k
    k = "#{nested_key}.#{k}" unless nested_key.nil?
    # recursively use the method again if value is an hash
    if v.class == Hash
      # push every value of the returned array instead of pushing the array thanks to splat operator
      keys.push(*get_absolute_path(v, k))
    else
      keys << k
    end
  end
end

headers = []
json.each do |hash|
  headers.push(*get_absolute_path(hash))
end

headers = headers.uniq
puts headers
CSV.open('output.csv', 'wb') do |csv|
  csv << headers
  json.each do |hash|
    row = headers.map do |h|
      # dig the nested values => https://ruby-doc.org/core-2.3.0_preview1/Hash.html#method-i-dig
      # use split on "." then the splat operator to use the dig method with each key of the header h
      v = hash.dig(*h.split('.'))
      v.class == Array ? v.join(', ') : v  # Fix up arrays
    end
    csv << row
  end
end

puts "CSV file created, type '$ open output.csv' to open it"
