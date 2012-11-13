require 'bundler/setup'
require 'sinatra/base'
require 'nokogiri'
require 'builder'
require 'json'

class ReplayWS < Sinatra::Base
  
  configure do
    @@responses = []
    #SOAP expects a mime_type of text/xml
    mime_type :xml, "text/xml"
    mime_type :json, "application/json"
  end

  post '/reset' do
    @@responses = []
    200
  end

  post '/replay_service' do
      soap_message = Nokogiri::XML(request.body.read)
      builder(:store_response)
  end

  post '/store' do
    @@responses ||= []
    @@responses << request.body.read.gsub(/\n\s*/, '')
    200
  end

  post '/respond' do
    message = @@responses.shift
    content_type determine_content_type message
    message
  end

  def determine_content_type(message)
    return "application/json" if valid_json? message
    "text/xml"
  end

  def valid_json?(json)
    begin
      JSON.parse json
      return true
    rescue
      return false
    end
  end
end
