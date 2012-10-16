require 'bundler/setup'
require 'sinatra/base'
require 'nokogiri'
require 'builder'

class ReplayWS < Sinatra::Base
  configure do
    #SOAP expects a mime_type of text/xml
    mime_type :xml, "text/xml"
  end

  post '/replay_service' do
    
      soap_message = Nokogiri::XML(request.body.read)
      builder(:store_response)
  end

  post '/store' do
      soap_message = Nokogiri::XML(request.body.read)
    @@responses ||= []
    @@responses << soap_message.to_s
      200
  end

  post '/respond' do
    @@responses.shift
  end

end
