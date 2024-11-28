# Desarrollo Prueba para Ingeniero de Datos: FruityCert

## Sección 1: Modelamiento de Datos y Construcción Base de Datos Relacional 

### Ejercicio 1: Diseño del Modelo de Datos Relacional

A continuación se muestra el modelo de datos relacional (DER) resultante de la primera aproximación a los datos.

[Ver el documento en PDF](docs/DER_FruityCert.pdf)

### Ejercicio 2: Normalización de la Base de Datos

Al analizar la tabla `TablonInspecciones.csv` se osbserva que no se encuentra en tercera forma normal (3FN), puesto que contiene **redundancia** al haber datos como `NombreCliente` y `NombreEspecie` que estaban duplicados y tambien **dependencias transitivas** puesto que dependían de otras claves que no son clave primaria. Además, considerando que los atributos del pallet se encuentran como columnas, con el fin de poder trabajar de forma correcta esta tabla se ha decidido desnormalizar parcialmente, convirtiendo las columnas de atributos del pallet en una sola columna llamada `IdAtributo`.

Así mismo, la tabla `ParametrosInspeccion.csv` tampoco se encuentra en tercera forma normal, ya que `NombreParametroInspeccion` y `PrefijoParametroInspeccion` dependen unicamente de `CodigoParametroInspeccion`, por lo tanto serían catalogados como **dependencia parcial**, lo cual inculple con la segunda forma normal "Todos los atributos no clave dependen completamente de la clave primaria".

Por otro lado, la tabla `AtributosLotes.csv` posee **dependencias transitivas** y una estructura rígida que no va a permitir consultas eficientes. Para esto se pivotea o se desnormaliza la tabla con el fin de que los atributos, que actualmente se guardan en columnas separadas, se almecen en una columna llamada `IdAtributo`. 

Una vez analizadas estas tablas, se procese con la normalización de las mismas, llegando al modelo de datos relacional normalizado como se muestra a continuación:

[Ver el documento en PDF](docs/DER_FruityCert_Normalizado.pdf)

Las estructuras de las tablas normalizadas resultantes son las siguientes:

```sql


CREATE TABLE Clientes (
    IdCliente INT PRIMARY KEY,
    NombreCliente VARCHAR(100) NOT NULL
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

CREATE TABLE Lotes (
    IdCliente INT NOT NULL,
    IdTipoInspeccion INT NOT NULL,
    IdEspecie INT NOT NULL,
    IdAtributo INT NOT NULL,
    ValorAtributo VARCHAR(100),
    PRIMARY KEY (IdCliente, IdTipoInspeccion, IdEspecie, IdAtributo),
    FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
    FOREIGN KEY (IdTipoInspeccion) REFERENCES TipoInspecciones(IdTipoInspeccion),
    FOREIGN KEY (IdEspecie) REFERENCES Especies(IdEspecies),
    FOREIGN KEY (IdAtributo) REFERENCES PalletAtributos(IdAtributo)
);

CREATE TABLE TipoInspeccion (
    IdTipoInspeccion INT PRIMARY KEY,
    NombreTipoInspeccion VARCHAR(100) NOT NULL
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
    FOREIGN KEY (IdEspecie) REFERENCES Especies(IdEspecies)
);


```
