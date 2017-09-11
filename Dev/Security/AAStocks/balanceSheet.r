library(stringi)
library(RSelenium)
library(rvest)
library(XML)

balanceSheetDataList = data.frame(
	closingDate=character(),
	nonCurrentAssets=character()
	fixedAssets
);


pJs = phantom();
page = remoteDriver(browserName = 'phantomjs')
page$open();

url = "http://www.aastocks.com/en/stocks/analysis/company-fundamental/balance-sheet?symbol=00001";

page$navigate(url);

html = read_html(page$getPageSource()[[1]]);
balanceSheetTable = html_nodes(html, "table.type2");
rows = html_nodes(balanceSheetTable, "tr");
for (i in 1:length(rows)){
	row = rows[i];
	cols = html_nodes(row, "td");
	if (length(cols) == 7){
		rowLabel = trimws(gsub("\n", "", html_text(cols[1])));
	}
}

page$close();
pJs$stop();