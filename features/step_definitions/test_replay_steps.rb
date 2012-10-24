require 'nokogiri'
require 'net/http'

def load_xml(file)
  dir = "#{File.dirname(__FILE__)}/../../messages"
  xml = Nokogiri::XML File.open "#{dir}/#{file}.xml"
  xml.to_s
end


def http
  @http ||= Net::HTTP.new '127.0.0.1', 9292
end

Given /^I want a car rental$/ do
 http.post "/store", load_xml(:default_car_rental)
end

When /^I make a reservation$/ do
  @response = http.post '/respond', ''
end

Then /^I should see a car reservation$/ do
  @response.body.to_s.should == load_xml(:default_car_rental)
end

