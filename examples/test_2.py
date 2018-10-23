from selenium import webdriver
from selenium.webdriver.common.keys import Keys

import logging
import os
import time
import unittest

global REGISTER_ADDRESS

class TestExamples(unittest.TestCase):
    def setUp(self):
        addrpath = os.path.dirname(os.path.abspath(__file__)) + '/../last_hub_addr.txt'
        with open(addrpath) as fh:
            hub_address = fh.read().strip('\n')
        self.driver = webdriver.Remote(
            command_executor=hub_address,
            desired_capabilities={
                #'browserName':  'chrome',
                'browserName':  'safari',
                #'browserName':  'firefox',
                #'platform':     'VISTA',
                #'platformName': 'windows',
                'javascriptEnabled':    True,
        })
        self.driver.implicitly_wait(30)
        self.driver.maximize_window()

    def test_one(self):
        try:
            self.driver.get('http://www.python.org')
            self.assertIn('Python', self.driver.title)
            elem = self.driver.find_element_by_name('q')
            elem.send_keys('documentation')
            elem.send_keys(Keys.RETURN)
            assert 'No results found.' not in self.driver.page_source
        finally:
            logging.info('Test one okay: ' + self.driver.session_id)

    def test_two(self):
        try:
            self.driver.get('http://www.google.com')
            elem = self.driver.find_element_by_name('q')
            elem.send_keys('webdriver')
            elem.send_keys(Keys.RETURN)
        finally:
            logging.info('Test two okay: ' + self.driver.session_id)

    def tearDown(self):
        self.driver.quit()

if __name__ == '__main__':
    #logging.basicConfig(filename='log.txt', level=logging.INFO)
    unittest.main()
