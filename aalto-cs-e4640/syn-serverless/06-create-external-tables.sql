-- creating external tables
-- learn more at https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/create-use-external-tables
-- https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/create-external-table-as-select

-- create external table
CREATE EXTERNAL FILE FORMAT QuotedCsvWithHeaderFormat
WITH (  
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS ( FIELD_TERMINATOR = ',', STRING_DELIMITER = '"', FIRST_ROW = 2   )
);

CREATE EXTERNAL TABLE populationExternalTable
(
    [country_code] VARCHAR (5) COLLATE Latin1_General_BIN2,
    [country_name] VARCHAR (100) COLLATE Latin1_General_BIN2,
    [year] smallint,
    [population] bigint
)
WITH (
    LOCATION = 'csv/population/population.csv',
    DATA_SOURCE = sqlondemanddemo,
    FILE_FORMAT = QuotedCSVWithHeaderFormat
);

-- using delta
CREATE EXTERNAL FILE FORMAT DeltaLakeFormat WITH (  FORMAT_TYPE = DELTA );
GO

CREATE EXTERNAL TABLE Covid (
     date_rep date,
     cases int,
     geo_id varchar(6)
) WITH (
        LOCATION = 'delta-lake/covid', --> the root folder containing the Delta Lake files
        data_source = Covid,
        FILE_FORMAT = DeltaLakeFormat
);

-- query external table
SELECT
    country_name, population
FROM populationExternalTable
WHERE
    [year] = 2019
ORDER BY
    [population] DESC;