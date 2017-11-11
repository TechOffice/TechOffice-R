library(stringi)
library(RSelenium)
library(rvest)
library(XML)

balanceSheetDataList = data.frame();

pJs = phantom();
page = remoteDriver(browserName = 'phantomjs')
page$open();

urlPrefix = "http://www.aastocks.com/en/stocks/analysis/company-fundamental/financial-ratios?symbol=";
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
					if (rowLabel == "Closing Date"                    ){closingDate              = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Current Ratio (X)"               ){currentRatio             = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Quick Ratio (X)"                 ){quickRatio               = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Long Term Debt/Equity (%)"       ){longTermDebtEquity       = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Total Debt/Equity (%)"           ){totalDebtEquity          = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Total Debt/Capital Employed (%)" ){totalDebtCapitalEmployed = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Return on Equity (%)"            ){returnOnEquity           = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Return on Capital Employ (%)"    ){returnOnCapitalEmploy    = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Return on Total Assets (%)"      ){returnOnTotalAssets      = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Operating Profit Margin (%)"     ){operatingProfitMargin    = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Pre-tax Profit Margin (%)"       ){preTaxProfitMargin       = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Net Profit Margin (%)"           ){netProfitMargin          = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Inventory Turnover (X)"          ){inventoryTurnover        = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Dividend Payout (%)"             ){dividendPayout           = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Fiscal Year High"                ){fiscalYearHigh           = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Fiscal Year Low"                 ){fiscalYearLow            = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Fiscal Year PER Range High (X)"  ){fiscalYearPerRangeHigh   = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Fiscal Year PER Range Low (X)"   ){fiscalYearPerRangeLow    = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Fiscal Year Yield Range High (%)"){fiscalYearYieldRangeHigh = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
					if (rowLabel == "Fiscal Year Yield Range Low (%)" ){fiscalYearYieldRangeLow  = c(trimws(gsub("\n", "", html_text(cols[colIndex]))));}
				}
			}
			balanceSheetData = data.frame(
				stockCode 					=c(stockCode)				,
				closingDate                 =closingDate                ,
				currentRatio                =currentRatio               ,
				quickRatio                  =quickRatio                 ,
				longTermDebtEquity          =longTermDebtEquity         ,
				totalDebtEquity             =totalDebtEquity            ,
				totalDebtCapitalEmployed    =totalDebtCapitalEmployed   ,
				returnOnEquity              =returnOnEquity             ,
				returnOnCapitalEmploy       =returnOnCapitalEmploy      ,
				returnOnTotalAssets         =returnOnTotalAssets        ,
				operatingProfitMargin       =operatingProfitMargin      ,
				preTaxProfitMargin          =preTaxProfitMargin         ,
				netProfitMargin             =netProfitMargin            ,
				inventoryTurnover           =inventoryTurnover          ,
				dividendPayout              =dividendPayout             ,
				fiscalYearHigh              =fiscalYearHigh             ,
				fiscalYearLow               =fiscalYearLow              ,
				fiscalYearPerRangeHigh      =fiscalYearPerRangeHigh     ,
				fiscalYearPerRangeLow       =fiscalYearPerRangeLow      ,
				fiscalYearYieldRangeHigh    =fiscalYearYieldRangeHigh   ,
				fiscalYearYieldRangeLow     =fiscalYearYieldRangeLow   
			);
			balanceSheetDataList = rbind(balanceSheetDataList,balanceSheetData)
		}
	}
}


page$close();
pJs$stop();