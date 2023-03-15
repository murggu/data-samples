-- querying delta
-- learn more at https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/query-delta-lake-format

-- query Delta folder
SELECT TOP 10 *
FROM OPENROWSET(
    BULK 'https://sqlondemandstorage.blob.core.windows.net/delta-lake/covid/',
    FORMAT = 'delta') as rows;


-- query using external data source
SELECT TOP 10 *
FROM OPENROWSET(
        BULK 'delta-lake/covid',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT = 'delta'
    ) as rows;

-- explicitly specify schema
SELECT TOP 10 *
FROM OPENROWSET(
        BULK 'delta-lake/covid',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT = 'delta'
    )
    WITH ( date_rep date,
           cases int,
           geo_id varchar(6)
           ) as rows;

-- query partitioned data
SELECT
        YEAR(pickup_datetime) AS year,
        passenger_count,
        COUNT(*) AS cnt
FROM  
    OPENROWSET(
        BULK 'delta-lake/yellow',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT='DELTA'
    ) nyc
WHERE
    nyc.year = 2017
    AND nyc.month IN (1, 2, 3)
    AND pickup_datetime BETWEEN CAST('1/1/2017' AS datetime) AND CAST('3/31/2017' AS datetime)
GROUP BY
    passenger_count,
    YEAR(pickup_datetime)
ORDER BY
    YEAR(pickup_datetime),
    passenger_count;