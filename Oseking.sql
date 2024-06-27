 

--- Question 1  Write a code to check NULL values 

SELECT   * 
  FROM [Nina].[dbo].[Corona Virus Dataset]
  WHERE Province IS  NULL
    AND   Country_Region IS NULL
    AND  Latitude IS NULL 
    AND   Longitude IS NULL
    AND Date IS NULL
    AND Confirmed IS NULL
    AND Deaths IS NULL
    AND Recovered IS NULL


--- Question 2 If NULL values are present, update them with zeros for all colums

 NO NULL VALUES PRESENT 




--- Question 3 Check total number of rolls 

SELECT COUNT (*)
 FROM [Nina].[dbo].[Corona Virus Dataset]

--- Question 4 - Check what is the start_date and end_date 

SELECT MAX (Date) AS Start_Date , MIN(Date) AS End_date
FROM [Nina].[dbo].[Corona Virus Dataset]

--Question 5 - Total number of months
SELECT
    COUNT(DISTINCT FORMAT(Date, 'yyyy-MM')) AS TotalMonths
FROM
     [Nina].[dbo].[Corona Virus Dataset];



--Question 6 - monthly average for confirmed. deaths, recovered
SELECT
    FORMAT(Date, 'yyyy-MM') AS YearMonth,
    AVG(Confirmed) AS AvgConfirmed,
    AVG(Deaths) AS AvgDeaths,
    AVG(Recovered) AS AvgRecovered
  FROM [Nina].[dbo].[Corona Virus Dataset]
GROUP BY
     FORMAT(Date, 'yyyy-MM') 
ORDER BY
	 FORMAT(Date, 'yyyy-MM') ; 

--Question 7- Find the most frequent value for confirmed, deaths, recovered each month
WITH MonthlyData AS (
    SELECT
        FORMAT(Date, 'yyyy-MM') AS YearMonth,
        Confirmed,
        Deaths,
        Recovered
      FROM [Nina].[dbo].[Corona Virus Dataset]
),
ConfirmedFreq AS (
    SELECT
        YearMonth,
        Confirmed,
        COUNT(*) AS Freq,
        ROW_NUMBER() OVER (PARTITION BY YearMonth ORDER BY COUNT(*) DESC) AS rn
    FROM
        MonthlyData
    GROUP BY
        YearMonth, Confirmed
),
DeathsFreq AS (
    SELECT
        YearMonth,
        Deaths,
        COUNT(*) AS Freq,
        ROW_NUMBER() OVER (PARTITION BY YearMonth ORDER BY COUNT(*) DESC) AS rn
    FROM
        MonthlyData
    GROUP BY
        YearMonth, Deaths
),
RecoveredFreq AS (
    SELECT
        YearMonth,
        Recovered,
        COUNT(*) AS Freq,
        ROW_NUMBER() OVER (PARTITION BY YearMonth ORDER BY COUNT(*) DESC) AS rn
    FROM
        MonthlyData
    GROUP BY
        YearMonth, Recovered
)
SELECT
    c.YearMonth,
    c.Confirmed AS MostFrequentConfirmed,
    d.Deaths AS MostFrequentDeaths,
    r.Recovered AS MostFrequentRecovered
FROM
    ConfirmedFreq c 
    JOIN DeathsFreq d ON c.YearMonth = d.YearMonth AND c.rn = 1 AND d.rn = 1
    JOIN RecoveredFreq r ON c.YearMonth = r.YearMonth AND c.rn = 1 AND r.rn = 1
WHERE
    c.rn = 1
ORDER BY
    c.YearMonth;


--Q8 Minimum values of confirmed, deaths, recovered per year
SELECT
    YEAR(Date) AS Year,
    MIN(Confirmed) AS MinConfirmed,
    MIN(Deaths) AS MinDeaths,
    MIN(Recovered) AS MinRecovered
  FROM [Nina].[dbo].[Corona Virus Dataset]
GROUP BY
    YEAR(Date)
ORDER BY
	YEAR(Date);


--Q9 Find the maximum values of confirmed, deaths, recovered per year
SELECT
    YEAR(Date) AS Year,
    MAX(Confirmed) AS MaxConfirmed,
    MAX(Deaths) AS MaxDeaths,
    MAX(Recovered) AS MaxRecovered
  FROM [Nina].[dbo].[Corona Virus Dataset]
GROUP BY
    YEAR(Date)
ORDER BY
    Year;

--Q10 The total number of case of confirmed, deaths, recovered each month
SELECT
    FORMAT(Date, 'yyyy-MM') AS YearMonth,
    SUM(Confirmed) AS TotalConfirmed,
    SUM(Deaths) AS TotalDeaths,
    SUM(Recovered) AS TotalRecovered
  FROM [Nina].[dbo].[Corona Virus Dataset]
GROUP BY
    FORMAT(Date, 'yyyy-MM')
ORDER BY
	FORMAT(Date, 'yyyy-MM');

--Q11 - Check how corona virus spread out with respect to confirmed case (e.g. total confirmed cases, their average and STDEV
SELECT
SUM(Confirmed) as TotalConfirmed,
AVG(Confirmed) as AVGConfirmed,
STDEV(Confirmed) as STDConfirmed
  FROM [Nina].[dbo].[Corona Virus Dataset];

--Q12 Check how corona virus spread out with respect to death case (e.g. total confirmed cases, their average and STDEV
SELECT
SUM(Deaths) as TotalDeaths,
AVG(Deaths) as AVGDeaths,
STDEV(Deaths) as STDDeaths
  FROM [Nina].[dbo].[Corona Virus Dataset];

-- Q13 Check how corona virus spread out with respect to recovered case (e.g. total confirmed cases, their average and STDEV
SELECT
SUM(Recovered) as TotalRecovered,
AVG(Recovered) as AVGRecovered,
STDEV(Recovered) as STDRecovered
  FROM [Nina].[dbo].[Corona Virus Dataset];

  --- Question 14 Find Country having highest number of Confirmed case

  SELECT TOP 1  Country_Region , SUM(Confirmed )as highestConfirmedcase 
  FROM [Nina].[dbo].[Corona Virus Dataset]
  GROUP BY Country_Region 
  ORDER BY highestConfirmedcase  DESC

  --- Question  15 Find country having lowest number of the death  case 

  SELECT TOP 1 Country_Region, SUM(Deaths) as lowestDeathcase 
  FROM [Nina].[dbo].[Corona Virus Dataset]
  GROUP BY  Country_Region 
  ORDER BY lowestDeathcase  ASC


  --- Question 16 Find top 5 countires having higehst recovered case 

  SELECT TOP 5 Country_Region, SUM(Recovered) AS HighestRecoveredCase 
  FROM [Nina].[dbo].[Corona Virus Dataset]
  GROUP BY Country_Region
  ORDER BY  HighestRecoveredCase  DESC 
