\c fruitycert;

CREATE TABLE Clientes (
    IdCliente INT PRIMARY KEY,
    NombreCliente VARCHAR(100) NOT NULL
);

CREATE TABLE TipoInspecciones (
    IdTipoInspeccion INT PRIMARY KEY,
    NombreTipoInspeccion VARCHAR(100) NOT NULL
);

CREATE TABLE Especies (
    IdEspecie INT PRIMARY KEY,
    NombreEspecie VARCHAR(100) NOT NULL
);

CREATE TABLE PalletAtributos (
    IdAtributo INT PRIMARY KEY,
    NombreAtributo VARCHAR(100) NOT NULL
);

CREATE TABLE Parametros (
    CodigoParametroInspeccion VARCHAR(50) PRIMARY KEY,
    PrefijoParametroInspeccion VARCHAR(50),
    NombreParametroInspeccion VARCHAR(100) NOT NULL,
    EsDefecto CHAR(1) NOT NULL
);

CREATE TABLE Inspecciones (
    IdPlanilla INT PRIMARY KEY,
    IdCliente INT NOT NULL,
    IdTipoInspeccion INT NOT NULL,
    IdEspecie INT NOT NULL,
    LugarInspeccion VARCHAR(100),
    Fecha DATE NOT NULL,
    FechaPublicacion DATE NOT NULL,
    FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
    FOREIGN KEY (IdTipoInspeccion) REFERENCES TipoInspecciones(IdTipoInspeccion),
    FOREIGN KEY (IdEspecie) REFERENCES Especies(IdEspecie)
);

CREATE TABLE Pallets (
    IdUnidad INT PRIMARY KEY,
    IdPlanilla INT NOT NULL,
    IdAtributo INT NOT NULL,
    ValorAtributo VARCHAR(100) NOT NULL,
    CantidadSubunidades INT NOT NULL,
    FOREIGN KEY (IdPlanilla) REFERENCES Inspecciones(IdPlanilla),
    FOREIGN KEY (IdAtributo) REFERENCES PalletAtributos(IdAtributo)
);

CREATE TABLE Muestras (
    IdUnidad INT NOT NULL,
    NumeroMuestra INT NOT NULL,
    CodigoParametroInspeccion VARCHAR(50),
    ValorParametroInspeccion FLOAT,
    PRIMARY KEY (IdUnidad, NumeroMuestra), 
    FOREIGN KEY (IdUnidad) REFERENCES Pallets(IdUnidad) 
);


CREATE TABLE Lotes (
    IdCliente INT NOT NULL,
    IdTipoInspeccion INT NOT NULL,
    IdEspecie INT NOT NULL,
    IdAtributo INT NOT NULL,
    ValorAtributo VARCHAR(100),
    PRIMARY KEY (IdCliente, IdTipoInspeccion, IdEspecie, IdAtributo),
    FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
    FOREIGN KEY (IdTipoInspeccion) REFERENCES TipoInspecciones(IdTipoInspeccion),
    FOREIGN KEY (IdEspecie) REFERENCES Especies(IdEspecie),
    FOREIGN KEY (IdAtributo) REFERENCES PalletAtributos(IdAtributo)
);


CREATE TABLE RelacionParametros (
    IdCliente INT NOT NULL,
    IdTipoInspeccion INT NOT NULL,
    IdEspecie INT NOT NULL,
    CodigoParametroInspeccion VARCHAR(50) NOT NULL,
    PRIMARY KEY (IdCliente, IdTipoInspeccion, IdEspecie, CodigoParametroInspeccion),
    FOREIGN KEY (CodigoParametroInspeccion) REFERENCES Parametros(CodigoParametroInspeccion),
    FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
    FOREIGN KEY (IdTipoInspeccion) REFERENCES TipoInspecciones(IdTipoInspeccion),
    FOREIGN KEY (IdEspecie) REFERENCES Especies(IdEspecie)
);