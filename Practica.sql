CREATE DATABASE EmpresaSQL

USE EmpresaSQL

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
	
	,nSalario DECIMAL 
		NOT NULL
	,cNIF NVARCHAR(15)
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
		NOT NULL
	
	,dCreatedAt DATETIME
		DEFAULT(GETDATE())
	,dUpdatedAt 
		NULL
	,dDeletedAt
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
	,dUpdatedAt 
		NULL
	,dDeletedAt
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
(
	cEmail NVARCHAR(50)
	,cTelefono NVARCHAR(50)
	
	,ck_email CHECK(cEmail like '%@%.%')
);
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
(
	cDireccion NVARCHAR(50)
	,nEdad INT
	,bActivo BIT
		DEFAULT(1)
	
	,CONSTRAINT ck_edad
		CHECK(nEdad BETWEEN 18 AND 65)
	,CONSTRAINT uq_email
		UNIQUE(cEmail)
);
GO

ALTER TABLE STrabajo.TEmpleado
	DROP COLUMN cDireccion;
GO

ALTER TABLE STrabajo.TEmpleado
	ALTER COLUMN cTelefono VARCHAR(20);
GO

ALTER TABLE STrabajo.TEmpleado
ADD
(
	cGenero VARCHAR(10)
	
	,CONSTRAINT ck_cGenero
		CHECK(cGenero IN ('M', 'F'))
);

ALTER TABLE STrabajo.TEmpleado
ADD
(
	dFechaNacimiento DATE
		NOT NULL
);

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
,('005-050582-5005E','Pedro',	'Martinez',	5, 5,	700,,	'pedro@empresa.com'		'8888-5555', 24, 'M', '2001-05-05')
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
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, dFechaNacimiento)
VALUES
('011', 'Mario', 'Torres', 1, 2, 1000, 29, 'M', '1996-01-01');

INSERT INTO STrabajo.TEmpleado
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID,.nSalario, nEdad, cGenero, dFechaNacimiento)
VALUES
('012', 'Laura', 'Castillo', 2, 3, 1200, 26, 'F', '1999-05-05');

-- Salario negativo
INSERT INTO STrabajo.TEmpleado
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, dFechaNacimiento)
VALUES
('013', 'Error', 'Prueba', 1, 1, -500, 25, 'M', '2000-01-01'
);

-- Update

UPDATE STrabajo.TEmpleado
SET nSalario = nSalario * 1.10;

UPDATE STrabajo.TEmpleado
SET nSalario = nSalario * 1.20
WHERE nDepartamentoID = 1;

UPDATE STrabajo.TEmpleado
SET cEmail='nuevo@empresa.com'
WHERE nEmpleadoID=1;

UPDATE STrabajo.TEmpleado
SET nCargoID=3
WHERE nEmpleadoID=2;

UPDATE STrabajo.TEmpleado
SET nDepartamentoID=4
WHERE nEmpleadoID IN (3,4);

UPDATE STrabajo.TEmpleado
SET bActivo=0
WHERE nSalario < 500;

UPDATE STrabajo.TProyecto
SET dFechaFinalizacion='2026-12-31'
WHERE nProyectoID=1;

INSERT INTO STrabajo.TEmpleadoProyecto
VALUES(1,3);
