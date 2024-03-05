-- Crear procedimiento almacenado para generar facturas de forma aleatoria
-- Se declaran variables y se itera para las 10000 facturas
-- En cada iteración se generan los valores aleatorios, y se inserta en la tabla Invoices
-- Después se generan las lineas de detalle de forma aleatoria(Minimo 50, Máximo 150)-
-- Se generan los valores aleatorios del detalle y verificamos si hay dos tipos de iva distintos (If-Else)
-- Si no hay 2 tipos diferentes de iva, se genera uno diferente
-- Insertar detalle
-- Crear procedimiento almacenado para generar facturas de forma aleatoria


CREATE PROCEDURE Sales.GenerarFacturas
AS
BEGIN
    DECLARE @FacturaId UNIQUEIDENTIFIER
    DECLARE @DetalleId INT
    DECLARE @Fecha DATETIME
    DECLARE @CustomerId UNIQUEIDENTIFIER
    DECLARE @AddressId UNIQUEIDENTIFIER
    DECLARE @Cantidad INT
    DECLARE @ProductId UNIQUEIDENTIFIER
    DECLARE @PrecioUnitario DECIMAL(18, 2)
    DECLARE @IVA DECIMAL(5, 2)
    DECLARE @i INT = 1;

	-- Generamos 5 tipos de Iva aleatorios, ya que debe haber mas de 2 distintos para cada detalle.
	WHILE @i <= 5
	BEGIN
		DECLARE @RandomTipoIVA UNIQUEIDENTIFIER = NEWID();

		INSERT INTO Sales.VatTypes (VatTypeId, VatRate) 
		VALUES (@RandomTipoIVA, RAND() * 10); 

		SET @i = @i + 1;
	END;

	--Insertamos 5 productos

	INSERT INTO Sales.Products (ProductId, ProductName, Description, UnitPrice, VatTypeId)
	VALUES 
    (NEWID(), 'Producto 1', 'Descripción del Producto 1', 10, (SELECT TOP 1 VatTypeId FROM Sales.VatTypes ORDER BY NEWID())),
    (NEWID(), 'Producto 2', 'Descripción 2', 15.99, (SELECT TOP 1 VatTypeId FROM Sales.VatTypes ORDER BY NEWID())),
    (NEWID(), 'Producto 3', 'Descripción 3', 20, (SELECT TOP 1 VatTypeId FROM Sales.VatTypes ORDER BY NEWID())),
    (NEWID(), 'Producto 4', 'Descripción 4', 105, (SELECT TOP 1 VatTypeId FROM Sales.VatTypes ORDER BY NEWID())),
    (NEWID(), 'Producto 5', 'Descripción 5', 25.50, (SELECT TOP 1 VatTypeId FROM Sales.VatTypes ORDER BY NEWID()));

    DECLARE @Contador INT
    SET @Contador = 1

    WHILE @Contador <= 10000
    BEGIN
        SET @FacturaId = NEWID()
        SET @Fecha = DATEADD(DAY, -CAST(RAND() * 365 AS INT), GETDATE()) 
        SET @CustomerId = (SELECT TOP 1 CustomerId FROM Sales.Customers ORDER BY NEWID())
        SET @AddressId = (SELECT TOP 1 AddressId FROM Address ORDER BY NEWID())

        INSERT INTO Sales.Invoices (InvoiceId, InvoiceDate, CustomerId, AddressId, TaxBase, TotalVat)
        VALUES (@FacturaId, @Fecha, @CustomerId, @AddressId, 0, 0)

        -- Generar líneas de detalle aleatorias para la factura
        DECLARE @Detalles INT
        SET @Detalles = CEILING(RAND() * 26) + 49; -- Entre 50 y 75(Aleatorio entre 0-1, redondeo al alza, multiplicado por 26 y sumado 50)

        DECLARE @Linea INT
        SET @Linea = 1

        DECLARE @IvasUtilizados TABLE (IvaId UNIQUEIDENTIFIER)

        WHILE @Linea <= @Detalles
        BEGIN
     
            SET @DetalleId = (SELECT ISNULL(MAX(RowNumber), 0) FROM Sales.InvoicesDetail WHERE InvoiceId = @FacturaId) + 1
            SET @ProductId = (SELECT TOP 1 ProductId FROM Sales.Products ORDER BY NEWID())
            SET @Cantidad = CEILING(RAND() * 10) 

            INSERT INTO Sales.InvoicesDetail (RowNumber, InvoiceId, ProductId, Quantity, UnitPrice, VatTypeId)
			VALUES (@DetalleId, @FacturaId, @ProductId, @Cantidad, @PrecioUnitario, @RandomTipoIVA)


            SET @Linea = @Linea + 1
        END

        SET @Contador = @Contador + 1
    END
END



-- Ejecutar procedimiento almacenado
EXEC Sales.GenerarFacturas;
-- Borrarlo
DROP PROCEDURE Sales.GenerarFacturas