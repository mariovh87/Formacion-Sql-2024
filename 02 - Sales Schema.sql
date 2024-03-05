/*
	La tabla Countries y Address, paises y direcciones no están en el esquema de ventas, Sales.
	Son tablas fuera de ese esquema y transversales a toda la base de datos.
	Se añaden valores NOT NULL para valores obligatorios.
	Se añade el código al Pais, el estandar de 3 digitos, no nulo y unico.
	En Invoices el total y total vat, se pueden calcular a través de las lineas.¿Persistirlos y actualizarlos o no? ¿Mediante trigger o hacerlo por dominio?
*/

USE smcdb1;

-- Crear el esquema "Sales" si no existe
IF NOT EXISTS (SELECT schema_id FROM sys.schemas WHERE name = 'Sales')
BEGIN
    EXEC('CREATE SCHEMA Sales');
END;

-- Crear tabla Sales.VatTypes
CREATE TABLE Sales.VatTypes (
    VatTypeId UNIQUEIDENTIFIER PRIMARY KEY,
    VatRate DECIMAL(5, 2) NOT NULL
);

-- Insertar algunos datos de ejemplo en la tabla Sales.VatTypes
INSERT INTO Sales.VatTypes (VatTypeId, VatRate) VALUES
(NEWID(), 21.00), -- 21% de IVA
(NEWID(), 10.00), -- 10% de IVA
(NEWID(), 4.00);  -- 4% de IVA

-- Crear tabla Sales.Products
CREATE TABLE Sales.Products (
    ProductId UNIQUEIDENTIFIER PRIMARY KEY,
    ProductName NVARCHAR(100),
    Description NVARCHAR(MAX),
    UnitPrice DECIMAL(18, 2) NOT NULL,
    VatTypeId UNIQUEIDENTIFIER,
    FOREIGN KEY (VatTypeId) REFERENCES Sales.VatTypes(VatTypeId)
);

-- Crear tabla Sales.Customers
CREATE TABLE Sales.Customers (
    CustomerId UNIQUEIDENTIFIER PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    AddressId UNIQUEIDENTIFIER,
    CountryId UNIQUEIDENTIFIER,
    CONSTRAINT FK_Customers_Address FOREIGN KEY (AddressId)
        REFERENCES Address(AddressId),
    CONSTRAINT FK_Customers_Countries FOREIGN KEY (CountryId)
        REFERENCES Countries(CountryId)
);

-- Crear tabla Countries
CREATE TABLE Countries (
    CountryId UNIQUEIDENTIFIER PRIMARY KEY,
    CountryCode CHAR(3) NOT NULL UNIQUE, -- Código de país único de 3 caracteres
    CountryName NVARCHAR(100) NOT NULL -- Nombre del país (no nulo)
);

-- Insertar algunos datos de ejemplo en la tabla Countries
INSERT INTO Countries (CountryId, CountryCode, CountryName) VALUES
(NEWID(), 'ESP', 'Spain'),
(NEWID(), 'FRA', 'France'),
(NEWID(), 'PRT', 'Portugal');

-- Crear tabla Address
CREATE TABLE Address (
    AddressId UNIQUEIDENTIFIER PRIMARY KEY,
    Street NVARCHAR(255),
    City NVARCHAR(100),
    CountryId UNIQUEIDENTIFIER,
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId)
);

-- Crear tabla Sales.Invoices
CREATE TABLE Sales.Invoices (
    InvoiceId UNIQUEIDENTIFIER PRIMARY KEY,
    InvoiceDate DATETIME,
    CustomerId UNIQUEIDENTIFIER,
    AddressId UNIQUEIDENTIFIER,
    TaxBase DECIMAL(18, 2),
    TotalVat DECIMAL(18, 2),
    Total DECIMAL(18, 2),
    CONSTRAINT FK_Invoices_Customers FOREIGN KEY (CustomerId) REFERENCES Sales.Customers(CustomerId),
    CONSTRAINT FK_Invoices_Address FOREIGN KEY (AddressId) REFERENCES Address(AddressId)
);


-- Crear tabla Sales.InvoicesDetail
CREATE TABLE Sales.InvoicesDetail (
    InvoiceId UNIQUEIDENTIFIER,
    RowNumber INT,
    ProductId UNIQUEIDENTIFIER,
    Description NVARCHAR(MAX),
    Quantity INT,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    Discount DECIMAL(5, 2),
    VatTypeId UNIQUEIDENTIFIER,
    TotalLine DECIMAL(18, 2),
    CONSTRAINT FK_InvoicesDetail_Invoices FOREIGN KEY (InvoiceId) REFERENCES Sales.Invoices(InvoiceId),
    CONSTRAINT FK_InvoicesDetail_Products FOREIGN KEY (ProductId) REFERENCES Sales.Products(ProductId),
    CONSTRAINT FK_InvoicesDetail_VatTypes FOREIGN KEY (VatTypeId) REFERENCES Sales.VatTypes(VatTypeId)
);


