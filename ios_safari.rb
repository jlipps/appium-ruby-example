require "rubygems"
require "appium_lib"
require "sauce_whisk"
require "minitest/autorun"

describe "Basic iOS Test" do
    def caps
        {
            caps: {
                appiumVersion: "1.3.7",
                platformName: "iOS",
                platformVersion: "8.2",
                deviceName: "iPhone Simulator",
                browserName: "Safari",
                name: "Basic iOS Web Test",
            }
        }
    end

    before do
        @driver = Appium::Driver.new(caps)
        @driver.start_driver
    end

    after do
        session_id = @driver.session_id
        @driver.driver_quit
        unless passed?
            puts "Failed test link: https://saucelabs.com/tests/#{session_id}"
        end
        SauceWhisk::Jobs.change_status session_id, passed?
    end

    describe "when I go to Google" do
        it "should be able to search for Sauce Labs" do
            @webdriver = @driver.driver
            @webdriver.navigate.to "http://www.google.com"

            search = @webdriver.find_element :name, "q"
            search.send_keys "sauce labs"
            search.send_keys :enter

            # allow the page to load
            wait { assert_equal "sauce labs", @webdriver.title[0..9] }
        end
    end
end
