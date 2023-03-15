-- querying csv 
-- learn more at https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/query-single-csv-file

-- query csv from public adls gen2, without data source definition
SELECT TOP 10 *
FROM openrowset(
    BULK 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.csv',
    FORMAT = 'csv',
    PARSER_VERSION = '2.0',
    FIRSTROW = 2 ) AS rows

-- create external data source
CREATE EXTERNAL DATA SOURCE Covid
WITH ( LOCATION = 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases' );

-- query using external data source
SELECT TOP 10 *
FROM openrowset(
    BULK 'latest/ecdc_cases.csv',
    DATA_SOURCE = 'Covid',
    FORMAT = 'csv',
    PARSER_VERSION = '2.0',
    FIRSTROW = 2 ) AS rows

-- explicitly specify schema
SELECT TOP 10 *
FROM openrowset(
    BULK 'latest/ecdc_cases.csv',
    DATA_SOURCE = 'Covid',
    FORMAT = 'csv',
    PARSER_VERSION = '2.0',
    FIRSTROW = 2 ) 
    WITH (
        date_rep date 1,
        cases int 5,
        geo_id varchar(6) 8
    ) AS rows

-- header row
SELECT *
FROM OPENROWSET(
    BULK 'csv/population-unix-hdr/population.csv',
    DATA_SOURCE = 'SqlOnDemandDemo',
    FORMAT = 'CSV', PARSER_VERSION = '2.0',
    FIELDTERMINATOR =',',
    HEADER_ROW = TRUE
    ) AS [r]