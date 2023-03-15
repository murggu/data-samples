-- creating views
-- learn more at https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/create-use-views

DROP VIEW IF EXISTS populationView;
GO

CREATE VIEW populationView AS
SELECT * 
FROM OPENROWSET(
        BULK 'csv/population/population.csv',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT = 'CSV', 
        FIELDTERMINATOR =',', 
        ROWTERMINATOR = '\n'
    )
WITH (
    [country_code] VARCHAR (5) COLLATE Latin1_General_BIN2,
    [country_name] VARCHAR (100) COLLATE Latin1_General_BIN2,
    [year] smallint,
    [population] bigint
) AS [r];

-- delta lake views
create or alter view CovidDeltaLake
as
select *
from openrowset(
           bulk 'delta-lake/covid',
           data_source = 'SqlOnDemandDemo',
           format = 'delta'
    ) with (
           date_rep date,
           cases int,
           geo_id varchar(6)
           ) as rows

-- partitioned views
CREATE VIEW TaxiView
AS SELECT *, nyc.filepath(1) AS [year], nyc.filepath(2) AS [month]
FROM
    OPENROWSET(
        BULK 'parquet/taxi/year=*/month=*/*.parquet',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT='PARQUET'
    ) AS nyc

-- delta lake partitioned views
CREATE OR ALTER VIEW YellowTaxiView
AS SELECT *
FROM  
    OPENROWSET(
        BULK 'delta-lake/yellow',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT='DELTA'
    ) nyc

-- json views
CREATE OR ALTER VIEW CovidCases
AS 
select
    *
from openrowset(
        bulk 'latest/ecdc_cases.jsonl',
        data_source = 'Covid',
        format = 'csv',
        fieldterminator ='0x0b',
        fieldquote = '0x0b'
    ) with (doc nvarchar(max)) as rows
    cross apply openjson (doc)
        with (  date_rep datetime2,
                cases int,
                fatal int '$.deaths',
                country varchar(100) '$.countries_and_territories')