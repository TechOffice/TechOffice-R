library(stringi)
library(RSelenium)
library(rvest)
library(XML)

balanceSheetDataList = data.frame();

pJs = phantom();
page = remoteDriver(browserName = 'phantomjs')
page$open();

urlPrefix = "http://www.aastocks.com/en/stocks/analysis/company-fundamental/balance-sheet?symbol=";
stockCodes = readLines("stockCodes.txt");
for (i in 1:length(stockCodes)){
	stockCode = stockCodes[i];
	print(stockCode);
	url = paste(urlPrefix, stockCode, sep="");
		page$navigate(url);

	html = read_html(page$getPageSource()[[1]]);
	balanceSheetTable = html_nodes(html, "table.type2");
	rows = html_nodes(balanceSheetTable, "tr");
	colNum = length(html_nodes(rows[1], "td"));
	if (colNum > 2){
		for (colIndex in 2: (colNum - 1)){
			for (rowNum in 1:length(rows)){
				row = rows[rowNum];
				cols = html_nodes(row, "td");
				if (length(cols) == colNum){
					rowLabel = trimws(gsub("\n", "", html_text(cols[1])));
					if (rowLabel == "Closing Date"                ){closingDate               = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Non Current Assets"          ){nonCurrentAssets          = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Fixed Assets"                ){fixedAssets               = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Investments"                 ){investments               = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Other Assets"                ){otherAssets               = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Current Assets"              ){currentAssets             = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Cash On Hand"                ){cashOnHand                = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Receivables"                 ){receivables               = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Inventory"                   ){inventory                 = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Other Current Assets"        ){otherCurrentAssets        = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Total Assets"                ){totalAssets               = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Non Current Liabilities"     ){nonCurrentLiabilities     = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Long Term Debt"              ){longTermDebt              = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Other Long Term Liabilities" ){otherLongTermLiabilities  = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Current Liabilities"         ){currentLiabilities        = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Payables"                    ){payables                  = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Taxation"                    ){taxation                  = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Short Term Debt"             ){shortTermDebt             = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Other Current Liabilities"   ){otherCurrentLiabilities   = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Total Liabilities"           ){totalLiabilities          = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Owner's Equity"              ){ownersEquity              = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Share Capital"               ){shareCapital              = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Reserves"                    ){reserves                  = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Perpetual Capital Securities"){perpetualCapitalSecurities= c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Minority interests"          ){minorityInterests         = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Total Equity"                ){totalEquity               = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Unit"                        ){unit                      = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Currency"                    ){currency                  = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
				}
			}
			balanceSheetData = data.frame(
				stockCode 					=c(stockCode)				,
				closingDate                 =closingDate                ,
				nonCurrentAssets            =nonCurrentAssets           ,
				fixedAssets                 =fixedAssets                ,
				investments                 =investments                ,
				otherAssets                 =otherAssets                ,
				currentAssets               =currentAssets              ,
				cashOnHand                  =cashOnHand                 ,
				receivables                 =receivables                ,
				inventory                   =inventory                  ,
				otherCurrentAssets          =otherCurrentAssets         ,
				totalAssets                 =totalAssets                ,
				nonCurrentLiabilities       =nonCurrentLiabilities      ,
				longTermDebt                =longTermDebt               ,
				otherLongTermLiabilities    =otherLongTermLiabilities   ,
				currentLiabilities          =currentLiabilities         ,
				payables                    =payables                   ,
				taxation                    =taxation                   ,
				shortTermDebt               =shortTermDebt              ,
				otherCurrentLiabilities     =otherCurrentLiabilities    ,
				totalLiabilities            =totalLiabilities           ,
				ownersEquity                =ownersEquity               ,
				shareCapital                =shareCapital               ,
				reserves                    =reserves                   ,
				perpetualCapitalSecurities  =perpetualCapitalSecurities ,
				minorityInterests           =minorityInterests          ,
				totalEquity                 =totalEquity                ,
				unit                        =unit                       
			);
			balanceSheetDataList = rbind(balanceSheetDataList,balanceSheetData)
		}
	}
}


page$close();
pJs$stop();