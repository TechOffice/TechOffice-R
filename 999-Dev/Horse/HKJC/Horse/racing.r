# This program is retrieve 
# 	today race data (horseNo, horseName, draw, weight, jockey, trainer, win, place)
# 	from http://bet.hkjc.com/racing/index.aspx

library(stringi)
library(RSelenium)
library(rvest)
library(XML)

domain = "http://bet.hkjc.com/";
index = "racing/index.aspx";

pJs = phantom();
page = remoteDriver(browserName = 'phantomjs')
page$open();
page$navigate(paste(domain, index, sep=""));
html = read_html(page$getPageSource()[[1]]);
raceButtonAnchors = html_nodes(html, "td.raceButton a");
print(paste("There are ", length(raceButtonAnchors), "races"));
for (raceButtonAnchor in c(raceButtonAnchors[1])){
	url = html_attr(raceButtonAnchor, "href");
	print(url);
	page$navigate(paste(domain, url, sep=""));
	html = read_html(page$getPageSource()[[1]]);
	horseTable = html_nodes(html, "#horseTable");
	horseTableRows = html_nodes(horseTable, "tr");
	if (length(horseTableRows) > 3){
		for (rowNum in 2: (length(horseTableRows) -2)){
			horseRow = horseTableRows[rowNum];
			horseCols = html_nodes(horseRow, "td");
			if (length(horseCols) == 12){
				horseNo = html_text(horseCols[2]);
				horseName = html_text(horseCols[4]);
				draw = html_text(horseCols[5]);
				weight = html_text(horseCols[6]);
				jockey = html_text(horseCols[7]);
				jockey = trimws(gsub(intToUtf8(160), "", gsub("\n", "", jockey)));
				trainer = html_text(horseCols[8]);
				bodyWeight = html_text(horseCols[9]);
				rtg = html_text(horseCols[10]);
				lastSixRuns = html_text(horseCols[12]);
				if (!is.null(jockey) && jockey != ''){
					print(lastSixRuns);
				}
			}
		}
	}
}
page$close();
pJs$stop();
