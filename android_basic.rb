require "rubygems"
require "appium_lib"
require "minitest/autorun"

describe "Basic Android Test" do
    def caps (local=false)
        basic_caps = {
            caps: {
                appiumVersion: "1.3.7",
                platformName: "Android",
                platformVersion: "5.0",
                deviceName: "Android Emulator",
                app: "http://appium.s3.amazonaws.com/ApiDemos-debug-2015-03-19.apk",
                name: "Basic Android Native Test",
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
        @driver = Appium::Driver.new(caps)
        @driver.start_driver
    end

    after do
        @driver.driver_quit
    end

    describe "when I open the app" do
        it "should be able to navigate to the Action Bar" do
            list_el = @driver.find_element :accessibility_id, "App"
            list_el.click
            texts = @driver.find_elements :class_name, "android.widget.TextView"
            texts[1].text.must_equal "Action Bar"
        end
    end
end
