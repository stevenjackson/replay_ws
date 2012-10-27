require 'net/http'

def http
  @http ||= Net::HTTP.new '127.0.0.1', 9292
end

Given /^I setup my replay service$/ do
  http.post "/reset", ''
end

Given /^I want a car rental$/ do
 http.post "/store", message(:default_car_rental)
end

When /^I make a reservation$/ do
  @response = http.post '/respond', ''
end

Then /^I should see a car reservation$/ do
  @response.body.to_s.should == message(:default_car_rental)
end

Given /^I want a car rental with a "(.*?)" of "(.*?)"$/ do |tag, text|
  http.post "/store", message(:default_car_rental, { tag => text })
end

Then /^I should see a car reservation with a "(.*?)" of "(.*?)"$/ do |tag, text|
  @response.body.to_s.should == message(:default_car_rental, { tag => text })
end
