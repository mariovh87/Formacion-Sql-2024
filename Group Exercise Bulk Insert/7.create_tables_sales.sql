IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Sales')
BEGIN
    EXEC('CREATE SCHEMA Sales');
END

-- Crear la tabla Countries
CREATE TABLE Countries (
    CountryId INT PRIMARY KEY IDENTITY,
    CountryName NVARCHAR(100) NOT NULL
)

-- Crear la tabla Address
CREATE TABLE Address (
    AddressId INT PRIMARY KEY IDENTITY,
    Street NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    StateProvince NVARCHAR(100),
    PostalCode NVARCHAR(20),
    CountryId INT,
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId)
)

-- Crear tabla Customers
CREATE TABLE Customers (
    CustomerId INT IDENTITY PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255),
    AddressId INT,
    FOREIGN KEY (AddressId) REFERENCES Address(AddressId)
)

-- Crear tabla Products
CREATE TABLE Products (
    ProductId INT IDENTITY PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
)

-- Crear tabla VatTypes
CREATE TABLE VatTypes (
    VatTypeId INT PRIMARY KEY,
    Description VARCHAR(255) NOT NULL,
    VatRate DECIMAL(5,2) NOT NULL 
)

-- Crear la tabla Sales.InvoicesHeader
CREATE TABLE Sales.InvoicesHeader (
    InvoiceId INT PRIMARY KEY IDENTITY,
    InvoiceDate DATETIME NOT NULL,
    CustomerId INT NOT NULL, 
    AddressId INT,
    TaxBase DECIMAL(10, 2) NOT NULL,
    TotalVat DECIMAL(10, 2) NOT NULL,
    Total DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (AddressId) REFERENCES Address(AddressId)
)

-- Crear la tabla Sales.InvoicesDetail
CREATE TABLE Sales.InvoicesDetail (
    InvoiceId   INT             NOT NULL,
    RowNumber   INT             IDENTITY (1, 1) NOT NULL,
    ProductId   INT             NOT NULL,
    Description VARCHAR (255)   NOT NULL,
    Quantity    DECIMAL (18, 4) NOT NULL,
    UnitPrice   DECIMAL (18, 2) NOT NULL,
    Discount    DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    VatTypeId   INT             NULL,
    TotalLine   DECIMAL(18,2)   NOT NULL,

    PRIMARY KEY CLUSTERED (InvoiceId ASC, RowNumber ASC),
    FOREIGN KEY (InvoiceId) REFERENCES Sales.InvoicesHeader (InvoiceId),
    FOREIGN KEY (VatTypeId) REFERENCES dbo.VatTypes (VatTypeId),
    FOREIGN KEY (ProductId) REFERENCES dbo.Products (ProductId)
)

ALTER TABLE Sales.InvoicesHeader
ADD InvoiceType CHAR(10) default 'Invoice'

update Sales.InvoicesHeader
set InvoiceType = 'Invoice'

update Sales.InvoicesHeader
set InvoiceType = 'Payment'
WHERE Sales.InvoicesHeader.InvoiceId < 100;