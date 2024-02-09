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
    DoubleField FLOAT,
    MoneyField MONEY,
  
);

-- Añadimos Filas

INSERT INTO Test (Code, CharField, NCharField, GuidField, IntField, DoubleField, MoneyField)
VALUES
    ('TESTCODE', 'TESTTEXT', N'Unicode', NEWID(), 123, 45.67, 100.50)

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