
library(rvest);

url = "https://www.hkex.com.hk/eng/market/sec_tradinfo/stockcode/eisdeqty.htm";
html = read_html(url);
hkexSecurityListTable = html_nodes(html, "table")[2];
stockCodes = c();
count = 0;
index = 0;
for (row in html_nodes(hkexSecurityListTable, "tr") ){
	if (count > 5){
		stockCode = html_text(html_nodes(row, "td")[1]);
		stockCodes[index] = stockCode;
		index = index + 1;
	}
	count = count + 1;
}
writeLines(stockCodes, "stockCodes.txt")