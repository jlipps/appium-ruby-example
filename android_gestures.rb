require "rubygems"
require "appium_lib"
require "sauce_whisk"
require "minitest/autorun"

describe "Basic Android Test" do
    def caps
        {
            caps: {
                appiumVersion: "1.3.7",
                platformName: "Android",
                platformVersion: "5.0",
                deviceName: "Android Emulator",
                app: "http://appium.s3.amazonaws.com/ApiDemos-debug-2015-03-19.apk",
                appActivity: ".view.DragAndDropDemo",
                name: "Basic Android Native Test",
            }
        }
    end

    before do
        @driver = Appium::Driver.new(caps)
        @driver.start_driver
    end

    after do
        session_id = @driver.driver.send(:bridge).session_id
        @driver.driver_quit
        unless passed?
            puts "Failed test link: https://saucelabs.com/tests/#{session_id}"
        end
        SauceWhisk::Jobs.change_status session_id, passed?
    end

    describe "when I go to the drag and drop view" do
        it "should be able to drag one dot onto another" do
            start_el = @driver.find_element :id, "io.appium.android.apis:id/drag_dot_3"
            end_el = @driver.find_element :id, "io.appium.android.apis:id/drag_dot_2"

            dnd = Appium::TouchAction.new
            dnd.long_press({element: start_el}).move_to({element: end_el}).release()
            @driver.touch_actions dnd.actions

            sleep 0.5

            text = @driver.find_element(:id, "io.appium.android.apis:id/drag_result_text").text
            assert_equal text, "Dropped!"
        end
    end
end
