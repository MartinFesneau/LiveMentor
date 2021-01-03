require_relative 'converter'
require 'csv'
require 'colorize'

def test_json_url
  if convert("not a json url") == "This is not a JSON URL, please enter a valid url"
    puts "Test JSON verification passed".colorize(:green)
  else 
    puts "Test JSON verification failed".colorize(:red)
  end
end

test_json_url

def test_convert
  url = "https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json"
  convert(url)
  csv_options = { headers: :first_row, header_converters: :symbol }
  csv_file = File.join(__dir__, "output.csv")
  profiles = []
  if File.exist?(csv_file)
    CSV.foreach(csv_file, csv_options) do |row|
      profiles << row
    end
  else
    puts "Error, there is no existing file"
  end
  if profiles[0][:email] == "colleengriffith@quintity.com"
    puts "Test CSV passed".colorize(:green)
  else
    puts "Test CSV failed".colorize(:red)
  end
end

test_convert