require "http"
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_key = ENV.fetch("GMAPS_KEY")

#First Question
puts "Where are you located?"

user_location0 = gets.chomp
#user_location0 = "Calumet City"
user_location = user_location0.gsub(" ","%20")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

resp = HTTP.get(gmaps_url)

raw_resp = resp.to_s

require "json"

parsed_resp = JSON.parse(raw_resp)

results = parsed_resp.fetch("results")
first_results = results.at(0)

address_components = first_results.fetch("address_components")
formatted_address = first_results.fetch("formatted_address")

geometry = first_results.fetch("geometry")
location = geometry.fetch("location")
lat = location.fetch("lat")
lng = location.fetch("lng")

#pp lat
#pp lng
pp "Checking the weather for #{formatted_address}"

# Weather
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"


weather_resp = HTTP.get(pirate_weather_url)

raw_weather_resp = weather_resp.to_s
parsed_weather_resp = JSON.parse(raw_weather_resp)

# Current Weather
currently = parsed_weather_resp.fetch("currently")
current_temp = currently.fetch("temperature")
current_summary = currently.fetch("summary")

pp "It is currently #{current_temp} degrees outside"
pp current_summary

# Hourly Weather
hourly = parsed_weather_resp.fetch("hourly")
hours_of_rain = Array.new
hour_data = hourly.fetch("data")
12.times do |the_index|
   precip = hour_data.at(the_index).fetch("precipProbability") 
   precip = precip.to_f * 100
   precip = precip.to_i


   if precip > 0.1
    pp "#{the_index} hours from now, there will be a #{precip}% chance of rain"
    hours_of_rain.push(precip)
   end
  
end

if hours_of_rain.length > 0
  pp "You might want to carry an umbrella!"
else
  pp "You probably won’t need an umbrella today."
end
# pp hour_data.at(2).fetch("temperature")
