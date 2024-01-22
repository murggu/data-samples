SELECT Sales.StockItemKey, 
Sales.Description, 
SUM(CAST(Sales.Quantity AS int)) AS SoldQuantity, 
c.Customer
FROM [dbo].[wwi_fact_sale] AS Sales,
[dbo].[wwi_dimension_customer] AS c
WHERE Sales.CustomerKey = c.CustomerKey
GROUP BY Sales.StockItemKey, Sales.Description, c.Customer;


SELECT COUNT(*) FROM dbo.wwi_fact_sale;