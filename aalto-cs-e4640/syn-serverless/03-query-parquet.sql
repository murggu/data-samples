-- querying parquet
-- learn more at https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/query-parquet-files

-- query parquet from public adls gen2, without data source definition
SELECT TOP 10 *
FROM openrowset(
    BULK 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',
    FORMAT = 'parquet') AS rows

-- query using external data source
SELECT TOP 10 *
FROM openrowset(
    BULK 'latest/ecdc_cases.parquet',
    DATA_SOURCE = 'Covid',
    FORMAT = 'parquet') AS rows

-- query set of parquet files
SELECT
    COUNT(*) AS cnt
FROM  
    OPENROWSET(
        BULK 'parquet/taxi/year=2018/month=*/*.snappy.parquet',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT='PARQUET'
    ) AS rows