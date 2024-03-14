select inh.InvoiceType,
YEAR(inh.InvoiceDate) as Year,
SUM(inh.Total) as Total,
SUM(inh.TotalVat) as TotalVat,
SUM(ind.Quantity) as Quantity,
AVG(inh.Total) as TotalAvg
from Sales.InvoicesHeader inh
inner join Sales.InvoicesDetail ind on inh.InvoiceId = ind.InvoiceId
group by inh.InvoiceType, YEAR(inh.InvoiceDate)
order by inh.InvoiceType, YEAR(inh.InvoiceDate)



