ENV['RACK_ENV'] = 'test'

require_relative '../lib/replay_ws'
require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'

class TestService < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    ReplayWS
  end

  def test_post_stored_success
    post "/replay_service", 
      %Q{<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:replay="http://www.leandog.com/replay">
   <env:Body>
      <replay:StoreRequest>
         <replay:Response>BARK!</replay:Response>
      </replay:StoreRequest>
   </env:Body>
</env:Envelope>}

  expected = %Q{<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:replay="http://www.leandog.com/replay">
  <env:Body>
    <replay:StoreResponse>Success</replay:StoreResponse>
  </env:Body>
</env:Envelope>}

    assert_equal expected, last_response.body.strip
    assert_equal 200, last_response.status
  end

  def test_retrieve
    message = %Q{<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:replay="http://www.leandog.com/replay">
        <env:Body>
          <replay:Response>BARK!</replay:Response>
        </env:Body>
    </env:Envelope>}
    
    post "/store", message 
    post "/respond", ''

    assert_equal message.gsub(/\n\s*/, ''), last_response.body.strip
    assert_equal 200, last_response.status
  end


  def test_result_should_be_xml
    
    message = %Q{<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:replay="http://www.leandog.com/replay">
        <env:Body>
          <replay:Response>BARK!</replay:Response>
        </env:Body>
    </env:Envelope>}
    
    post "/store", message
    post "/respond", ''

    assert_equal 'text/xml;charset=utf-8', last_response.content_type
  end

  def test_result_should_be_json
    message = %Q~{"menu": {
      "id": "file",
      "value": "File",
      "popup": {
        "menuitem": [
          {"value": "New", "onclick": "CreateNewDoc()"},
          {"value": "Open", "onclick": "OpenDoc()"},
          {"value": "Close", "onclick": "CloseDoc()"}
        ]
      }
    }}~
    post "/store", message
    post "/respond", ''

    assert_equal 'application/json;charset=utf-8', last_response.content_type
  end

  def test_reset
    post "/reset", ''
    assert_equal 200, last_response.status
    post "/respond", ''
    assert_equal 200, last_response.status
    assert_equal '', last_response.body
  end

end
