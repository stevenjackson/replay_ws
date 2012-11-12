require 'watir-webdriver'

if ENV['HEADLESS']
  require 'headless'
  headless = Headless.new
  headless.start

  at_exit do
    headless.destroy
  end
end

Before do
  @browser = Watir::Browser.new :firefox
end


After do
  @browser.close
end
