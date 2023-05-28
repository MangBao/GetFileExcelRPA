from robot.api.deco import keyword, library
from SeleniumLibrary import BrowserManagementKeywords

import time

@library
class CustomBrowser(BrowserManagementKeywords):

    @keyword
    def open_my_browser(self):
        self.open_browser("http://demo.guru99.com/V4/", "chrome")
        self.driver.maximize_window()
        time.sleep(5)