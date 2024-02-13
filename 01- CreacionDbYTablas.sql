-- Creamos base de datos.
CREATE DATABASE smcdb1 COLLATE Modern_Spanish_CI_AI;

--Utilizamos la base de datos creada y creamos tabla Test 
USE smcdb1;
GO
CREATE TABLE Test (
    Code CHAR(20),
    CharField CHAR(10),
    NCharField NCHAR(10),
    GuidField UNIQUEIDENTIFIER,
    IntField INT,
	BigIntField BIGINT,
    DoubleField FLOAT,
    MoneyField MONEY,
	DatetimeField DATETIME,
	TimeField TIME,
	DateField DATE, 
	BooleanField BIT DEFAULT 1 -- valor por defecto a true
);

-- Añadimos Filas

INSERT INTO Test (Code, CharField, NCharField, GuidField, IntField, BigIntField, DoubleField, MoneyField, DatetimeField, TimeField, DateField, BooleanField)
VALUES
    ('TESTCODE', 'TESTTEXT', N'Unicode', NEWID(), 123, 12345678, 45.67, 100.50, GETDATE(), GETDATE(), GETDATE(), 1),
	('TESTCODE2', 'TESTTEXT2', N'Unicode2', NEWID(), 456, 98765432, 67.89, 200.75, GETDATE(), GETDATE(), GETDATE(), 0);

-- INSERTAMOS SIN BOOLEAN FIELD, para comprobar default value
INSERT INTO Test (Code, CharField, NCharField, GuidField, IntField, BigIntField, DoubleField, MoneyField, DatetimeField, TimeField, DateField)
VALUES
    ('TESTCODE3', 'TESTTEXT3', N'Unicode3', NEWID(), 789, 11223344, 89.12, 300.99, GETDATE(), GETDATE(), GETDATE());

-- Creamos la segunda tabla
CREATE DATABASE smcdb2 COLLATE Latin1_General_CS_AS;

--Copia de la tabla Test de una base de datos a otra.
USE smcdb1;
GO
SELECT * INTO smcdb2.dbo.Test FROM Test;

-- Consulta con diferentes 
SELECT * 
FROM smcdb1.dbo.Test AS t1
INNER JOIN smcdb2.dbo.Test AS t2 ON t1.Code = t2.Code;