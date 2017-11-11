library(RSelenium)
library(rvest)
library(XML)


pJs = phantom();

page = remoteDriver(browserName = 'phantomjs')
page$open();

#
page$navigate("http://www.google.com");
htmlParse(page$getPageSource()[[1]])


page$close()

pJs$stop();