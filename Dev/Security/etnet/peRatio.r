
library(RSelenium)
library(rvest)
library(XML)

pJs = phantom();

page = remoteDriver(browserName = 'phantomjs')
page$open();

urlPrefix = "http://www.etnet.com.hk/www/tc/stocks/realtime/quote.php?code=";

stockCodes = readLines("stockCodes.txt");
for (i in 1:length(stockCodes)){
	stockCode = stockCodes[i];
	print(stockCode);
	url = paste(urlPrefix, stockCode, sep="");
	
	page$navigate(url);
	html = read_html(page$getPageSource()[[1]])

	peRatioItem = html_nodes(html, "#StkList > ul > li:nth-child(38)")[1];
	peRatioStr = html_text(peRatioItem);
	
	print(paste(stockCode, peRatioStr, sep=" "));
}

page$close()
pJs$stop();