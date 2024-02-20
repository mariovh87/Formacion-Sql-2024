-- Campo calculado TotalLine, es la cantidad multiplicado por el precio unitario, tenemos en cuenta el descuento también

ALTER TABLE Sales.InvoicesDetail
DROP COLUMN TotalLine;

ALTER TABLE Sales.InvoicesDetail
ADD TotalLine AS (Quantity * UnitPrice * (1 - Discount / 100)) PERSISTED;

GO


CREATE OR ALTER TRIGGER UpdateTotalVat
ON Sales.InvoicesDetail
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @InvoiceId UNIQUEIDENTIFIER;

    -- Obtener el Id de la factura afectada por la modificación en la linea de detalle
    SELECT @InvoiceId = InvoiceId FROM inserted;

    -- Actualizar el campo TotalVat de la factura a partir del sumatorio del total de sus lineas de detalle
    UPDATE Invoices
    SET TotalVat = (
        SELECT SUM(TotalLine)
        FROM Sales.InvoicesDetail
        WHERE InvoiceId = @InvoiceId
    )
    WHERE InvoiceId = @InvoiceId;
END;
GO

-- Total calculado a partir del taxbase mas el total vat que se calcula con el sumatorio de las lineas de detalle mediante trigger
ALTER TABLE Sales.Invoices
DROP COLUMN Total
ALTER TABLE Sales.Invoices
ADD Total AS (TaxBase + TotalVat) PERSISTED;
GO