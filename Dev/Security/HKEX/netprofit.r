#
# Net Profits Crawler from HKEX 
# 
# https://www.hkex.com.hk/eng/market/sec_tradinfo/stockcode/eisdeqty.htm
# 
# This program would retrieve the net profit from the HKEX
#

library(stringi)
library(rvest);

# Read html
hkexSecurityListHtmlUrlPrefix = "https://www.hkex.com.hk/eng/market/sec_tradinfo/stockcode/";
hkexSecurityListHtmlUrl = paste(hkexSecurityListHtmlUrlPrefix, "eisdeqty.htm", sep="");
hkexSecurityListHtml = read_html(hkexSecurityListHtmlUrl);

# Read table
hkexSecurityListTable = html_nodes(hkexSecurityListHtml, "table")[2];

#
stockDataList = data.frame(

);

# For each row of the table
count = 0 ;
for (row in html_nodes(hkexSecurityListTable, "tr") ){
	if (count > 5){
		stockCode 		= html_text(html_nodes(row, "td")[1]);
		stockName 		= html_text(html_nodes(row, "td")[2]);
		stockDetailAhrf = html_nodes(row, "td>a");
		if (length(stockDetailAhrf) > 0){
			stockDetailUrl 	= html_attr(stockDetailAhrf,"href");
			stockDetailHtml = read_html(paste(hkexSecurityListHtmlUrlPrefix,stockDetailUrl, sep=""));
			stockDetailTable = html_nodes(stockDetailHtml, "table")[6];
			isProfit = TRUE;
			netProfit = trimws(stri_trans_general(gsub("\r\n", "", html_text(html_nodes(html_nodes(stockDetailTable, "tr")[20],"td")[2])), "latin-ascii"));
			if (endsWith(netProfit, ")") && startsWith(netProfit, "(")){
				isProfit = FALSE;
				netProfit = gsub("\\)", "", gsub("\\(", "", netProfit));
			}
			netProfitCcy = substr(netProfit, 1, 3);
			netProfitValueStr = substr(netProfit, 5, stri_length(netProfit));
			profitValue = gsub(",", "", profitValueStr);
			print(paste(stockCode, stockName, isProfit, netProfitCcy, netProfitValueStr, sep=" ") );
			stockData = data.frame(
				code=c(stockCode),
				name=c(stockName),
				isProfit=c(isProfit),
				ccy=c(netProfitCcy),
				profitValueStr=c(netProfitValueStr),
				profitValue=c(profitValue)
			);
			stockDataList <- rbind(stockDataList,stockData)
		}
	}
	count = count + 1;
}

# print the stock net profit sorted by decreasing order
profitStockDataList = stockDataList[stockDataList$isProfit == TRUE, ]
profitStockDataList[order(as.numeric(profitStockDataList$profitValue), decreasing = TRUE), ]
