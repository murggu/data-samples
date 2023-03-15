-- querying json
-- learn more at https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/query-json-files

-- query json from public adls gen2, without data source definition
SELECT TOP 10 *
FROM OPENROWSET(
        BULK 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.jsonl',
        FORMAT = 'csv',
        FIELDTERMINATOR ='0x0b',
        FIELDQUOTE = '0x0b'
    ) WITH (doc nvarchar(max)) AS rows

-- query json files usin JSON_VALUE
SELECT
    JSON_VALUE(doc, '$.date_rep') AS date_reported,
    JSON_VALUE(doc, '$.countries_and_territories') AS country,
    CAST(JSON_VALUE(doc, '$.deaths') AS INT) as fatal,
    JSON_VALUE(doc, '$.cases') as cases,
    doc
FROM OPENROWSET(
        BULK 'latest/ecdc_cases.jsonl',
        DATA_SOURCE = 'Covid',
        FORMAT = 'csv',
        FIELDTERMINATOR ='0x0b',
        FIELDQUOTE = '0x0b'
    ) WITH (doc nvarchar(max)) as rows
ORDER BY JSON_VALUE(doc, '$.geo_id') desc

-- query json files using OPENJSON
SELECT
    *
FROM openrowset(
        BULK 'latest/ecdc_cases.jsonl',
        DATA_SOURCE = 'Covid',
        FORMAT = 'csv',
        FIELDTERMINATOR ='0x0b',
        FIELDQUOTE = '0x0b'
    ) WITH (doc nvarchar(max)) as rows
    CROSS APPLY openjson (doc)
        WITH (  date_rep datetime2,
                cases int,
                fatal int '$.deaths',
                country varchar(100) '$.countries_and_territories')
WHERE country = 'Serbia'
ORDER BY country, date_rep desc;