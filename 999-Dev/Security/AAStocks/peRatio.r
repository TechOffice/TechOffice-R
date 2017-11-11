library(stringi)
library(RSelenium)
library(rvest)
library(XML)

peRatioDataList = data.frame(
	code=character(),
	peRatio=character()
);

pJs = phantom();
page = remoteDriver(browserName = 'phantomjs')
page$open();

page$navigate("http://www.aastocks.com/en/default.aspx");
searchBtnImg = page$findElement(using="css", "#mainForm > div:nth-child(2) > div:nth-child(8) > div.grid_11.font-c > div.tbar > div.float_l > table > tbody > tr > td:nth-child(4) > img");
searchBtnImg$clickElement();

urlPrefix = "http://www.aastocks.com/en/ltp/rtquote.aspx?symbol=";

stockCodes = readLines("stockCodes.txt");
for (i in 1:length(stockCodes)){
	stockCode = stockCodes[i];
	print(stockCode);
	url = paste(urlPrefix, stockCode, sep="");	
	tryCatch({
		page$navigate(url);
		html = read_html(page$getPageSource()[[1]])
		infoTable = html_nodes(html, "#aspnetForm .div-container table.tb-c")[1];
		peRatioCol = html_nodes(html_nodes(infoTable, "tr")[6], "td div")[3];
		peRatio = trimws(gsub("\n", "", html_text(peRatioCol)));
		peRatioData = data.frame(
			code=c(stockCode),
			peRatio=c(peRatio)
		);
		peRatioDataList = rbind(peRatioDataList,peRatioData)
		print(paste(stockCode, peRatio, sep=" "));
	}, 
	error = function(c){
		print(paste("Fail to retrieve security data code = ", stockCode, sep=""));
	});

}

page$close()
pJs$stop();