require "rubygems"
require "appium_lib"
require "minitest/autorun"

describe "Basic iOS Test" do
    def caps (local=false)
        basic_caps = {
            caps: {
                appiumVersion: "1.3.7",
                platformName: "iOS",
                platformVersion: "8.2",
                deviceName: "iPhone Simulator",
                app: "http://appium.s3.amazonaws.com/TestApp7.1.app.zip",
                name: "Basic iOS Native Test",
            }
        }
        if local
            basic_caps[:appium_lib] = {
                sauce_username: "",
                sauce_access_key: ""
            }
        end
        basic_caps
    end

    before do
        @driver = Appium::Driver.new(caps).start_driver
    end

    after do
        @driver.quit rescue nil
    end

    describe "when I use the calculator" do
        it "should sum two numbers correctly" do
            # populate text fields with values
            field_one = @driver.find_element :accessibility_id, "TextField1"
            field_one.send_keys 12

            field_two = @driver.find_elements(:class_name, "UIATextField")[1]
            field_two.send_keys 8

            # they should be the same size, and the first should be above the second
            assert field_one.location.y < field_two.location.y
            assert_equal field_one.size, field_two.size

            # trigger computation by using the button
            @driver.find_element(:accessibility_id, "ComputeSumButton").click

            # is sum equal?
            sum = @driver.find_elements(:class_name, "UIAStaticText")[0].text
            assert_equal sum.to_i, 20
        end
    end
end
