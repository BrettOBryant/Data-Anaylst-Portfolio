SELECT * 
FROM PortfolioProject . . ['2018_Financial_Data$']
WHERE F1 like 'ACAD'

-- Adding a year to keep track after combining tables
ALTER TABLE PortfolioProject . . ['2014_Financial_Data$']
Add Year int;

UPDATE PortfolioProject . . ['2014_Financial_Data$']
SET Year = 2014;

ALTER TABLE PortfolioProject . . ['2015_Financial_Data$']
Add Year int;

UPDATE PortfolioProject . . ['2015_Financial_Data$']
SET Year = 2015;

ALTER TABLE PortfolioProject . . ['2016_Financial_Data$']
Add Year int;

UPDATE PortfolioProject . . ['2016_Financial_Data$']
SET Year = 2016;

ALTER TABLE PortfolioProject . . ['2017_Financial_Data$']
Add Year int;

UPDATE PortfolioProject . . ['2017_Financial_Data$']
SET Year = 2017;

ALTER TABLE PortfolioProject . . ['2018_Financial_Data$']
Add Year int;

UPDATE PortfolioProject . . ['2018_Financial_Data$']
SET Year = 2018;

-- Deleting duplicates in the 2014 table
 WITH ManyF1
 as (
 Select *,
 ROW_NUMBER() OVER (
 Partition BY F1
 ORDER BY F1
 ) row_num
 FROM PortfolioProject . . ['2014_Financial_Data$']
 ) 
SELECT *
 From ManyF1
 Where row_num > 1


-- Finding the stocks with the highest average revenue growth across all five years

WITH Top5 (F1, TotalGrowth)
as
(
Select four.F1, four.[Revenue Growth] + five.[Revenue Growth] + six.[Revenue Growth] + seven.[Revenue Growth] + eight.[Revenue Growth] as TotalGrowth
From PortfolioProject . . ['2014_Financial_Data$']four
Join PortfolioProject . .['2015_Financial_Data$']five
ON four.F1 = five.F1
Join PortfolioProject . .['2016_Financial_Data$']six
ON six.F1 = five.F1
Join PortfolioProject . .['2017_Financial_Data$']seven
ON six.F1 = seven.F1
Join PortfolioProject . .['2018_Financial_Data$']eight
ON eight.F1 = seven.F1
)
Select TOP 5 *, TotalGrowth/5 as AverageGrowth
From Top5
Order by AverageGrowth desc

-- Making table with all original information for our top five growers, separted by year, to export for data exploration

Select * 
From PortfolioProject . . ['2014_Financial_Data$']
Where F1 like 'FPAY' OR f1 like 'CYAD' OR f1 like 'VCEL' OR f1 like 'CNCE' OR f1 like 'CLVS'   
UNION ALL
Select * 
From PortfolioProject . . ['2015_Financial_Data$']
Where F1 like 'FPAY' OR f1 like 'CYAD' OR f1 like 'VCEL' OR f1 like 'CNCE' OR f1 like 'CLVS'  
UNION ALL
Select * 
From PortfolioProject . . ['2016_Financial_Data$']
Where F1 like 'FPAY' OR f1 like 'CYAD' OR f1 like 'VCEL' OR f1 like 'CNCE' OR f1 like 'CLVS'
UNION ALL
Select * 
From PortfolioProject . . ['2017_Financial_Data$']
Where F1 like 'FPAY' OR f1 like 'CYAD' OR f1 like 'VCEL' OR f1 like 'CNCE' OR f1 like 'CLVS'  
UNION ALL
Select * 
From PortfolioProject . . ['2018_Financial_Data$']
Where F1 like 'FPAY' OR f1 like 'CYAD' OR f1 like 'VCEL' OR f1 like 'CNCE' OR f1 like 'CLVS'
ORDER By Year, F1