require "http"
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_key = ENV.fetch("GMAPS_KEY")

#First Question
puts "Where are you located?"

#user_location0 = gets.chomp
user_location0 = "Calumet City"
user_location = user_location0.gsub(" ","%20")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

resp = HTTP.get(gmaps_url)

raw_resp = resp.to_s

require "json"

parsed_resp = JSON.parse(raw_resp)

results = parsed_resp.fetch("results")
first_results = results.at(0)

address_components = first_results.fetch("address_components")

geometry = first_results.fetch("geometry")
location = geometry.fetch("location")
lat = location.fetch("lat")
lng = location.fetch("lng")

pp lat
pp lng

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"


weather_resp = HTTP.get(pirate_weather_url)

raw_weather_resp = weather_resp.to_s
parsed_weather_resp = JSON.parse(raw_weather_resp)

currently = parsed_weather_resp.fetch("currently")
current_temp = currently.fetch("temperature")

hourly = parsed_weather_resp.fetch("hourly")

pp current_temp
