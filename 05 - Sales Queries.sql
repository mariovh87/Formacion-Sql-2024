-- 5 Clientes con más facturado

SELECT TOP 5 CustomerId, SUM(Total) AS CustomerTotal
FROM Sales.Invoices
GROUP BY CustomerId
ORDER BY CustomerTotal DESC;

--Ordernar por paises que mas facturan

SELECT c.CountryId, co.CountryName, SUM(i.Total) AS CountryTotal
FROM Sales.Customers c
JOIN Countries co ON c.CountryId = co.CountryId
JOIN Sales.Invoices i ON c.CustomerId = i.CustomerId
GROUP BY c.CountryId, co.CountryName
ORDER BY CountryTotal DESC;

-- Total de facturación de los ultimos tres meses a partir del dia actual
SELECT SUM(Total) AS TotalSum
FROM Sales.Invoices
WHERE InvoiceDate >= DATEADD(MONTH, -3, GETDATE());

-- Elimina la integridad referencial entre ambas tablas.
ALTER TABLE Sales.InvoicesDetail
DROP CONSTRAINT FK_InvoicesDetail_Invoices;