# encoding: UTF-8

#Address => 
#Geocode => 
#latlong => 
#CartoDB => 
#Id => 
#hash => 
#userlink to unsubscribe.

# encoding: UTF-8

# Connect to map DB, translate all  the track names, company names 
require 'json'
require 'net/http'
require 'open-uri'

desc "test geocode"
task :test_geocode => :environment do
  address = "Lee Cottage Park Street, Charlbury, OX73PS"

  res = open(URI(URI::encode "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}, UK&sensor=false&region=gb"))
  dat = JSON.parse(res.read)["results"][0]["geometry"]["location"]    
  lat = dat['lat']
  lng = dat['lng']

  puts "THE LAT LONG IS #{lat} #{lng}"
end 

desc "send egg to CartoDB"
task :post_egg => :environment do
  @sql = "INSERT INTO eggs (the_geom, address, telephone) VALUES (ST_GeomFromText('POINT(-71.2 42.5)', 4326),'lee cottage','+44blahblah') RETURNING cartodb_id"
  res = open(URI(URI::encode "http://eggsellence.cartodb.com/api/v2/sql?q=#{@sql}&api_key=a990bfe1d952be1de34e22a55b74d5e0e83b8d30"))
  puts res.read  
end 


