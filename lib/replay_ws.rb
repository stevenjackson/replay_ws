require 'bundler/setup'
require 'sinatra/base'
require 'nokogiri'
require 'builder'
require 'json'

class ReplayWS < Sinatra::Base
  
  configure do
    @@responses = {}
    #SOAP expects a mime_type of text/xml
    mime_type :xml, "text/xml"
    mime_type :json, "application/json"
  end

  post '/reset' do
    @@responses = {}
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

  def store(endpoint, body)
    endpoint = "/#{endpoint}" unless endpoint =~ /^\//
    @@responses ||= {}
    endpoint_responses(endpoint) << body.gsub(/\n\s*/, '')
  end

  def respond(endpoint='/')
    endpoint = "/#{endpoint}" unless endpoint =~ /^\//
    message = endpoint_responses(endpoint).shift
    content_type determine_content_type message
    puts "No message found for #{endpoint}" unless message
    message
  end

  def endpoint_responses(endpoint='')
    response_queue = @@responses[endpoint] || []
    @@responses[endpoint] = response_queue
    response_queue
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
