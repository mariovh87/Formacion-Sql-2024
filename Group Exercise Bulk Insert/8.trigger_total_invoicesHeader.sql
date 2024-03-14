CREATE TRIGGER [Sales].[trg_UpdateInvoiceTotal]
ON [Sales].[InvoicesDetail]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE h
    SET h.Total = (SELECT SUM(TotalLine) FROM Sales.InvoicesDetail WHERE InvoiceId = h.InvoiceId)
    FROM Sales.InvoicesHeader h
END;

ALTER TABLE [Sales].[InvoicesDetail] ENABLE TRIGGER [trg_UpdateInvoiceTotal]

CREATE TRIGGER trg_UpdateTotalLineWithVAT
ON Sales.InvoicesDetail
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Sales.InvoicesDetail
    SET TotalLine = inserted.Quantity * inserted.UnitPrice * (1 - inserted.Discount / 100) * (1 + VatTypes.VatRate / 100)
    FROM inserted
    INNER JOIN Sales.InvoicesDetail ON Sales.InvoicesDetail.InvoiceId = inserted.InvoiceId AND Sales.InvoicesDetail.RowNumber = inserted.RowNumber
    INNER JOIN VatTypes ON Sales.InvoicesDetail.VatTypeId = VatTypes.VatTypeId;
END;

ALTER TABLE [Sales].[InvoicesDetail] ENABLE TRIGGER [trg_UpdateTotalLineWithVAT]