USE master;
GO

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'EmpresaSQL')
BEGIN
    ALTER DATABASE EmpresaSQL
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EmpresaSQL;
END
GO

CREATE DATABASE EmpresaSQL
GO

USE EmpresaSQL
GO

CREATE SCHEMA SLocacion;
GO
CREATE SCHEMA STrabajo;
GO

CREATE TABLE SLocacion.TDepartamento
(
	nDepartamentoID INT
		IDENTITY(1,1)
	,cNombreDepartamento NVARCHAR(50)
		NOT NULL
		
	,dCreatedAt DATETIME
		DEFAULT(GETDATE())
	,dUpdatedAt DATETIME
		NULL
	,dDeletedAt DATETIME
		NULL
	
	,CONSTRAINT pk_departamento
		PRIMARY KEY(nDepartamentoID)
	,CONSTRAINT uq_nomdepart
		UNIQUE(cNombreDepartamento)
);
GO

CREATE TABLE STrabajo.TCargo
(
	nCargoID INT
		IDENTITY(1,1)
	,cNombreCargo NVARCHAR(50)
		NOT NULL
	
	,dCreatedAt DATETIME
		DEFAULT(GETDATE())
	,dUpdatedAt DATETIME
		NULL
	,dDeletedAt DATETIME
		NULL
	
	,CONSTRAINT pk_cargoid
		PRIMARY KEY(nCargoID)
	,CONSTRAINT uq_nombrecargo
		UNIQUE(cNombreCargo)
);
GO

CREATE TABLE STrabajo.TEmpleado
(
	nEmpleadoID INT
		IDENTITY(1,1)
	,nDepartamentoID INT
	,nCargoID INT
	
	,nSalario DECIMAL(10,2)
		NOT NULL
	,cNIF NVARCHAR(20)
		NOT NULL 
	,cNombre NVARCHAR(50)
		NOT NULL
	,cApellido NVARCHAR(50) 
		NOT NULL
	,dFechaContratacion DATE
		DEFAULT(GETDATE())
		
	,dCreatedAt DATETIME
		DEFAULT(GETDATE())
	,dUpdatedAt DATETIME
		NULL
	,dDeletedAt DATETIME
		NULL
	
	,CONSTRAINT pk_empleadoid
		PRIMARY KEY(nEmpleadoID)
	,CONSTRAINT fk_departamentoid
		FOREIGN KEY(nDepartamentoID)
		REFERENCES SLocacion.TDepartamento(nDepartamentoID)
	,CONSTRAINT fk_cargoid
		FOREIGN KEY(nCargoID)
		REFERENCES STrabajo.TCargo(nCargoID)
	,CONSTRAINT uq_nif
		UNIQUE(cNIF)
		
	,CONSTRAINT ck_salario
		CHECK(nSalario >= 300)
);
GO

CREATE TABLE STrabajo.TProyecto
(
	nProyectoID INT
		IDENTITY(1,1)
	,cNombreProyecto NVARCHAR(50)
	,dFechaInicio DATE
		NOT NULL
	,dFechaFinalizacion DATE
		NULL
	
	,dCreatedAt DATETIME
		DEFAULT(GETDATE())
	,dUpdatedAt DATETIME
		NULL
	,dDeletedAt DATETIME
		NULL
		
	,CONSTRAINT pk_proyectoid
		PRIMARY KEY(nProyectoID)
);
GO

CREATE TABLE STrabajo.TEmpleadoProyecto
(
	nEmpleadoID INT
	,nProyectoID INT
	
	,dCreatedAt DATETIME
		DEFAULT(GETDATE())
	,dUpdatedAt DATETIME
		NULL
	,dDeletedAt DATETIME
		NULL
	
	,CONSTRAINT pk_empleadoproyecto
		PRIMARY KEY(nEmpleadoID, nProyectoID)
	,CONSTRAINT fk_empleadoid
		FOREIGN KEY(nEmpleadoID)
		REFERENCES STrabajo.TEmpleado(nEmpleadoID)
	,CONSTRAINT fk_proyectoid
		FOREIGN KEY(nProyectoID)
		REFERENCES STrabajo.TProyecto(nProyectoID)
);
GO

-- Alter tables

ALTER TABLE STrabajo.TEmpleado
ADD	
	cEmail NVARCHAR(50)
		NOT NULL
	,cTelefono NVARCHAR(50)
		NULL
	,CONSTRAINT ck_email CHECK(cEmail like '%@%.%');
GO

ALTER TABLE STrabajo.TEmpleado
	ALTER COLUMN cNombre
	NVARCHAR(100);
GO

ALTER TABLE STrabajo.TEmpleado
	ALTER COLUMN cApellido
	NVARCHAR(100);
GO
	
ALTER TABLE STrabajo.TEmpleado ADD
	cDireccion NVARCHAR(50)
	,nEdad INT
	,bActivo BIT
		DEFAULT(1)
	
	,CONSTRAINT ck_edad
		CHECK(nEdad BETWEEN 18 AND 65)
	,CONSTRAINT uq_email
		UNIQUE(cEmail);
GO

ALTER TABLE STrabajo.TEmpleado
	DROP COLUMN cDireccion;
GO

ALTER TABLE STrabajo.TEmpleado
	ALTER COLUMN cTelefono VARCHAR(20);
GO

ALTER TABLE STrabajo.TEmpleado
ADD
	cGenero VARCHAR(10)
	
	,CONSTRAINT ck_cGenero
		CHECK(cGenero IN ('M', 'F'));
GO

ALTER TABLE STrabajo.TEmpleado
ADD
	dFechaNacimiento DATE
		NOT NULL;
GO

-- Tabla sucursal

CREATE TABLE SLocacion.TSucursal
(
	nSucursalID INT
		IDENTITY(1,1)
	,cDireccion NVARCHAR(50)
	,cCiudad NVARCHAR(50)
	
	,CONSTRAINT pk_sucursal
		PRIMARY KEY(nSucursalID)
);
GO

-- Inserciones

INSERT INTO SLocacion.TDepartamento
(cNombreDepartamento)
VALUES
('Recursos Humanos')
,('Finanzas')
,('Tecnología')
,('Ventas')
,('Marketing');
GO

INSERT INTO STrabajo.TCargo
(cNombreCargo)
VALUES
('Gerente')
,('Analista')
,('Programador')
,('Vendedor')
,('Asistente');
GO

INSERT INTO STrabajo.TEmpleado
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero, dFechaNacimiento)
VALUES
 ('001-010190-1001A','Juan', 	'Pérez', 	1, 1,	1500,	'juan@empresa.com',		'8888-1111', 35, 'M', '1990-01-01')
,('002-020292-2002B','María',	'Gómez', 	3, 3,	1200,	'maria@empresa.com',	'8888-2222', 33, 'F', '1992-02-02')
,('003-030395-3003C','Carlos',	'López', 	4, 4,	900,	'carlos@empresa.com',	'8888-3333', 30, 'M', '1995-03-03')
,('004-040445-4004D','Ana',		'Lopez', 	4, 4,	1100,	'ana@empresa.com',		'8888-4444', 40, 'F', '1985-04-04')
,('005-050582-5005E','Pedro',	'Martinez',	5, 5,	700,	'pedro@empresa.com',	'8888-5555', 24, 'M', '2001-05-05')
,('006-060672-6006F','Sofia',	'Garcia', 	1, 3, 	1300,	'sofia@empresa.com',	'8888-6666', 32, 'F', '1993-06-06')
,('007-070789-7007G','Luis',	'Gonzalez',	2, 4,	950,	'luis@empresa.com',		'8888-7777', 27, 'M', '1998-07-07')
,('008-080890-8008H','Elena',	'Gutierrez',3, 2,	1400,	'elena@empresa.com',	'8888-8888', 38, 'F', '1987-08-08')
,('009-090919-9009I','Jose',	'Rivas',	4, 1,	2000,	'jose@empresa.com',		'8888-9999', 45, 'M', '1980-09-09')
,('010-101099-1010J','Marta',	'Gaitan',	5, 5,	600,	'marta@empresa.com',	'8888-1010', 22, 'F', '2003-10-10');
GO

INSERT INTO STrabajo.TProyecto
(cNombreProyecto, dFechaInicio, dFechaFinalizacion)
VALUES
 ('Sistema ERP',		'2025-01-01',	'2025-12-31')
,('Portal Web',			'2025-03-01',	'2025-09-30')
,('Aplicacion Movil',	'2025-05-01',	'2025-11-30');
GO

INSERT INTO STrabajo.TEmpleadoProyecto
(nEmpleadoID, nProyectoID)
VALUES
 (1,1)
,(2,1)
,(2,2)
,(3,2)
,(4,2)
,(5,2)
,(6,3)
,(7,3)
,(8,3);
GO

INSERT INTO SLocacion.TSucursal
(cDireccion, cCiudad)
VALUES
('Carretera a Masaya Km 8', 'Managua'),
('Centro Comercial', 'León');
GO

-- Inserciones parte 2
INSERT INTO STrabajo.TEmpleado
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, dFechaNacimiento, cEmail)
VALUES
('010-032312-0404F', 'Mario', 'Torres', 1, 2, 1000, 29, 'M', '1996-01-01', 'mariot@empresa.com');
GO

INSERT INTO STrabajo.TEmpleado
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, dFechaNacimiento, cEmail)
VALUES
('010-321434-0034F', 'Laura', 'Castillo', 2, 3, 1200, 26, 'F', '1999-05-05', 'laurac@empresa.com');
GO

-- Salario negativo: Debe generar error
INSERT INTO STrabajo.TEmpleado
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, dFechaNacimiento, cEmail)
VALUES
('666-666666-6666S', 'Error', 'Prueba', 1, 1, -500, 25, 'M', '2000-01-01', 'error@empresa.com');
GO
-- Update

UPDATE STrabajo.TEmpleado
SET nSalario = nSalario * 1.10;
GO

UPDATE STrabajo.TEmpleado
SET nSalario = nSalario * 1.20
WHERE nDepartamentoID = 1;
GO

UPDATE STrabajo.TEmpleado
SET cEmail='nuevo@empresa.com'
WHERE nEmpleadoID=1;
GO

UPDATE STrabajo.TEmpleado
SET nCargoID=3
WHERE nEmpleadoID=2;
GO

UPDATE STrabajo.TEmpleado
SET nDepartamentoID=4
WHERE nEmpleadoID IN (3,4);
GO

UPDATE STrabajo.TEmpleado
SET bActivo=0
WHERE nSalario < 500;
GO

UPDATE STrabajo.TProyecto
SET dFechaFinalizacion='2026-12-31'
WHERE nProyectoID=1;
GO

INSERT INTO STrabajo.TEmpleadoProyecto (nEmpleadoID, nProyectoID)
	VALUES(1,3);
GO
-- Delete

DELETE FROM STrabajo.TEmpleado
WHERE cNIF LIKE '001-010190-1001A';
GO

DELETE FROM STrabajo.TEmpleado
WHERE bActivo = 0;
GO

DELETE FROM STrabajo.TEmpleadoProyecto
WHERE nProyectoID = 3;
DELETE FROM STrabajo.TProyecto
WHERE nProyectoID = 3;
GO

DELETE FROM STrabajo.TEmpleadoProyecto
WHERE nEmpleadoID = 1;
GO

DELETE FROM SLocacion.TDepartamento
WHERE
	nDepartamentoID = 5
AND NOT EXISTS
	(SELECT 1 FROM STrabajo.TEmpleado E WHERE (E.nDepartamentoID = 5));
GO
-- Consultas

SELECT *
FROM STrabajo.TEmpleado
ORDER BY cApellido;
GO

SELECT *
FROM STrabajo.TEmpleado
WHERE nSalario > 1000;
GO

SELECT *
FROM STrabajo.TEmpleado
WHERE bActivo = 1;
GO

SELECT *
FROM STrabajo.TEmpleado
WHERE YEAR(dFechaContratacion) = YEAR(GETDATE());
GO

SELECT
	E.cNombre
	,E.cApellido
	,D.cNombreDepartamento
FROM 
	STrabajo.TEmpleado E
INNER JOIN 
	SLocacion.TDepartamento D
	ON E.nDepartamentoID=D.nDepartamentoID;
GO

SELECT
	E.cNombre
	,E.cApellido
	,C.cNombreCargo
FROM 
	STrabajo.TEmpleado E
INNER JOIN 
	STrabajo.TCargo C
	ON E.nCargoID = C.nCargoID;
GO

SELECT
	E.cNombre
	,P.cNombreProyecto
FROM 
	STrabajo.TEmpleado E
INNER JOIN 
	STrabajo.TEmpleadoProyecto EP
	ON E.nEmpleadoID=EP.nEmpleadoID
INNER JOIN 
	STrabajo.TProyecto P
	ON EP.nProyectoID=P.nProyectoID;
GO

SELECT
	D.cNombreDepartamento,
	COUNT(*) Cantidad
FROM
	STrabajo.TEmpleado E
INNER JOIN
	SLocacion.TDepartamento D
ON
	E.nDepartamentoID=D.nDepartamentoID
GROUP BY
	D.cNombreDepartamento;
GO

SELECT
	D.cNombreDepartamento,
	AVG(nSalario) Promedio
FROM
	STrabajo.TEmpleado E
INNER JOIN
	SLocacion.TDepartamento D
ON
	E.nDepartamentoID=D.nDepartamentoID
GROUP BY
	D.cNombreDepartamento;
GO

SELECT
	D.cNombreDepartamento,
	MAX(nSalario) SalarioMaximo,
	MIN(nSalario) SalarioMinimo
FROM
	STrabajo.TEmpleado E
INNER JOIN 
	SLocacion.TDepartamento D
ON 
	E.nDepartamentoID=D.nDepartamentoID
GROUP BY
	D.cNombreDepartamento;
GO

SELECT
	P.cNombreProyecto,
	COUNT(*) TotalEmpleados
FROM
	STrabajo.TEmpleadoProyecto EP
INNER JOIN
	STrabajo.TProyecto P
	ON EP.nProyectoID=P.nProyectoID
GROUP BY
	P.cNombreProyecto HAVING COUNT(*) > 2;
GO

SELECT *
FROM 
	STrabajo.TEmpleado
WHERE
	cApellido LIKE 'G%';
GO

SELECT *
FROM
	STrabajo.TEmpleado
ORDER BY
	nSalario DESC;
GO

SELECT 
	TOP 3 *
FROM 
	STrabajo.TEmpleado
ORDER BY
	nSalario DESC;
GO

SELECT *
FROM 
	STrabajo.TEmpleado
WHERE 
	nEdad BETWEEN 25 AND 40;
GO

SELECT
	COUNT(*) TotalActivos
FROM 
	STrabajo.TEmpleado
WHERE 
	bActivo=1;
GO

SELECT 
	COUNT(*) TotalProyectos
FROM STrabajo.TProyecto;
GO

-- Administracion de objetos

ALTER TABLE STrabajo.TEmpleado
DROP CONSTRAINT 
	ck_edad;
GO

ALTER TABLE STrabajo.TEmpleado
DROP CONSTRAINT 
	uq_email;
GO

ALTER TABLE STrabajo.TEmpleado
ADD CONSTRAINT 
	ck_edad
	CHECK(nEdad BETWEEN 18 AND 65);
GO

ALTER TABLE 
	STrabajo.TEmpleado
ADD CONSTRAINT 
	uq_email
	UNIQUE(cEmail);
GO

DROP TABLE STrabajo.TEmpleadoProyecto;
DROP TABLE STrabajo.TProyecto;
DROP TABLE STrabajo.TEmpleado;
DROP TABLE STrabajo.TCargo;
DROP TABLE SLocacion.TDepartamento;
DROP TABLE SLocacion.TSucursal;
GO

USE master;
GO

ALTER DATABASE EmpresaSQL
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE EmpresaSQL;
GO
