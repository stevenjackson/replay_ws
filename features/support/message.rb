require 'nokogiri'

def message_no_whitespace(file, overrides={})
  message(file, overrides).gsub(/\n\s*/, '')
end

def message(file, overrides={})
  filename = find_filename file
  if filename =~ /xml$/
    xml_message filename, overrides
  else
    json_message filename
  end
end

def find_filename(file)
  dir = "#{File.dirname(__FILE__)}/../../messages"
  Dir["#{dir}/#{file}.*"].first
end

def xml_message(file, overrides={})
  xml = load_xml_file(file)
  overrides.each do |tag, text|
    xml.at_xpath("//#{tag}").content = text
  end
  xml.to_s
end

def json_message(file)
  load_json_file file
end

def load_xml_file(filename)
  Nokogiri::XML File.open filename
end

def load_json_file(filename)
  IO.read(filename)
end
