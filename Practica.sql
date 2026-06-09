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
