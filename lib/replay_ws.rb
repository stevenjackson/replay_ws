require 'bundler/setup'
require 'sinatra/base'
require 'nokogiri'
require 'builder'
require 'json'

require_relative 'response_queues'

class ReplayWS < Sinatra::Base
  
  configure do
    @@responses = ResponseQueues.new
    #SOAP expects a mime_type of text/xml
    mime_type :xml, "text/xml"
    mime_type :json, "application/json"
  end

  post '/reset' do
    @@responses.reset
    200
  end

  post '/replay_service' do
      soap_message = Nokogiri::XML(request.body.read)
      builder(:store_response)
  end

  post '/store/*' do
    store "/#{params[:splat].first}", request.body.read
    200
  end

  post '/store' do
    store request["endpoint"], request.body.read
    200
  end

  post '/respond' do
    respond nil
  end

  get '/*' do
    respond params[:splat].first
  end

  post '/*' do
    respond params[:splat].first
  end

  def store(endpoint='/', message)
    @@responses.store endpoint, message
  end

  def respond(endpoint='/')
    message = @@responses.retrieve endpoint
    content_type determine_content_type message
    puts "No message found for #{endpoint}" unless message
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
