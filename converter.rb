require 'csv'
require 'json'
require 'open-uri'

def convert(url)
  # verify if the given URL is JSON.
  if url[-4..-1] != "json"
    error = "This is not a JSON URL, please enter a valid url"
    puts error
    return error  
  end

  # get json data into ruby hash
  data_serialized = open(url).read
  data = JSON.parse(data_serialized)

  headers = []
  data.each do |hash|
    headers.push(get_absolute_path(hash))
  end

  # use uniq to have only one header of each, join and split to have one array of headers
  headers = headers.uniq.join(",").split(",")

  CSV.open('output.csv', 'wb') do |csv|
    csv << headers
    data.each do |hash|
      row = headers.map do |header|
        # dig the nested values => https://ruby-doc.org/core-2.3.0_preview1/Hash.html#method-i-dig
        # use split on "." then the splat operator to use the dig method with each key of the header
        value = hash.dig(*header.split("."))
        # if the element is an array, join it to have the format we want
        value.class == Array ? value.join(", ") : value  # Fix up arrays
      end
      csv << row
    end
  end
  puts "CSV file created, type '$ open output.csv' to open it"
end


private 

def get_absolute_path(hash, nested_key=nil)
  keys = []
  hash.each_with_object([]) do |(key,value),keys|
    # if there is no nested key, return the key
    key = "#{nested_key}.#{key}" unless nested_key.nil?
    # recursively use the method again if value is an hash
    if value.class == Hash
      keys.push(get_absolute_path(value, key))
    else
      keys << key
    end
  end
end