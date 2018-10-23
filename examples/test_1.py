import os
import time

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

if __name__ == '__main__':
    addrpath = os.path.dirname(os.path.abspath(__file__)) + '/../last_hub_addr.txt'
    with open(addrpath) as fh:
        hub_address = fh.read().strip('\n')
    driver = webdriver.Remote(
        command_executor=hub_address,
        desired_capabilities={
            #'browserName':         'chrome',
            'browserName':         'safari',
            #'browserName':         'firefox',
            'javascriptEnabled':    True,
    })
    try:
        driver.implicitly_wait(30)
        driver.maximize_window()
        driver.get('http://www.python.org')
        driver.implicitly_wait(30)
        assert 'Python' in driver.title
        elem = driver.find_element_by_name('q')
        elem.send_keys('documentation')
        elem.send_keys(Keys.RETURN)
        driver.implicitly_wait(30)
        assert 'No results found.' not in driver.page_source
    finally:
        driver.quit()
