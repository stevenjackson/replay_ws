require 'nokogiri'

def load_xml_file(file)
  dir = "#{File.dirname(__FILE__)}/../../messages"
  Nokogiri::XML File.open "#{dir}/#{file}.xml"
end

def message(file, overrides={})
  xml = load_xml_file(file)
  overrides.each do |tag, text|
    xml.at_xpath("//#{tag}").content = text
  end
  xml.to_s
end

def message_no_whitespace(file, overrides={})
  message(file, overrides).gsub(/\n\s*/, '')
end
