Significado de las terminaciones en Collation en SQL Server:
CI: Case insensitive.
AI: Accent insensitive.
CS: Case sensitive.
AS: Accent sensitive
Tipos de datos y su uso:
Tipo de Dato	Descripción	Cuándo Usarlo	Pros	Contras
BIT	Un solo bit que almacena valores 0 o 1.	Cuando se necesita almacenar valores lógicos.	Pequeño almacenamiento, eficiente en espacio.	Limitado a dos valores (0 y 1).
TINYINT	Entero de 1 byte sin signo que varía de 0 a 255.	Cuando se necesita almacenar números pequeños.	Uso eficiente de almacenamiento para valores pequeños.	Rango limitado de valores.
SMALLINT	Entero de 2 bytes que varía de -32,768 a 32,767.	Cuando se necesita almacenar números enteros pequeños.	Almacenamiento eficiente para enteros pequeños.	Rango limitado de valores.
INT	Entero de 4 bytes que varía de -2,147,483,648 a 2,147,483,647.	Para almacenar enteros medianos.	Amplio rango de valores enteros.	Puede ser excesivo para valores pequeños.
BIGINT	Entero de 8 bytes que varía de -9,223,372,036,854,775,808 a 9,223,372,036,854,775,807.	Cuando se necesita almacenar números grandes.	Rango masivo de valores enteros.	Utiliza más espacio de almacenamiento.
DECIMAL(p,s)	Número decimal fijo de precisión p y escala s.	Cuando se necesita precisión decimal exacta.	Precisión decimal exacta.	Mayor uso de almacenamiento.
...	...	...	...	...
Ejemplos de comparación entre tipos de datos:
char vs nchar: Char es una cadena de caracteres fija - Nchar es similar pero para datos Unicode. Si es Var, es de longitud variable.
datetime vs smalldatetime: La diferencia es la precisión. ...
int vs bigint: Tamaño y rango. ...
Uso de Default Values:
Muy útil para el bit (booleano) para marcar por defecto el 1 (true).
En tablas de auditoría para marcar la fecha de inserción de la fila.
Uso de Columnas con o sin Nulos:
Sin nulos: Garantiza el valor válido de la columna, simplifica queries.
Con nulos: Permite dejarlo nulo si el valor es desconocido en el momento de la inserción.
Uso de Campos Clave Compuestos:
Puede ser útil cuando la relación entre entidades no se puede representar con una clave primaria simple.
Reduce la duplicidad de datos y puede agilizar consultas.