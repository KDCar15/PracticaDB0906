CREATE DATABASE EmpresaSQL

USE EmpresaSQL

CREATE TABLE TDepartamento
(
	nDepartamentoID INT
		IDENTITY(1,1)
	,cNombreDepartamento NVARCHAR(50)
		NOT NULL
		
	,dCreatedAt DATETIME
		DEFAULT(GETDATE())
	,dUpdatedAt 
		NULL
	,dDeletedAt
		NULL
	
	,CONSTRAINT pk_departamento
		PRIMARY KEY(nDepartamentoID)
	,CONSTRAINT uq_nomdepart
		UNIQUE(cNombreDepartamento)
);
GO

CREATE TCargo
(
	nCargoID INT
		IDENTITY(1,1)
	,cNombreCargo NVARCHAR(50)
		NOT NULL
	
	,dCreatedAt DATETIME
		DEFAULT(GETDATE())
	,dUpdatedAt 
		NULL
	,dDeletedAt
		NULL
	
	,CONSTRAINT pk_cargoid
		PRIMARY KEY(nCargoID)
	,CONSTRAINT uq_nombrecargo
		UNIQUE(cNombreCargo)
);
GO

CREATE TABLE TEmpleado
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
	,dUpdatedAt
		NULL
	,dDeletedAt
		NULL
	
	,CONSTRAINT pk_empleadoid
		PRIMARY KEY(nEmpleadoID)
	,CONSTRAINT fk_departamentoid
		FOREIGN KEY(nDepartamentoID)
		REFERENCES TDepartamento(nDepartamentoID)
	,CONSTRAINT fk_cargoid
		FOREIGN KEY(nCargoID)
		REFERENCES TCargo(nCargoID)
		
	,CONSTRAINT ck_salario
		CHECK(nSalario >= 300)
);
GO
