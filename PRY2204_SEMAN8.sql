
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE DETALLE_VENTA CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE VENTA CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE VENDEDOR CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ADMINISTRATIVO CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- 5?? PRODUCTO
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE PRODUCTO CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE PROVEEDOR CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- 7?? COMUNA
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE COMUNA CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADO CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE REGION CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE MARCA CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CATEGORIA CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE AFP CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SALUD CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE MEDIO_PAGO CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE REGION (
    id_region NUMBER(4) CONSTRAINT PK_REGION PRIMARY KEY,
    nom_region VARCHAR2(25) NOT NULL
);

-- MARCA
CREATE TABLE MARCA (
    id_marca NUMBER(3) CONSTRAINT PK_MARCA PRIMARY KEY,
    nombre_marca VARCHAR2(25)  NOT NULL
);

-- CATEGORIA
CREATE TABLE CATEGORIA (
    id_categoria     NUMBER(3) CONSTRAINT PK_CATEGORIA PRIMARY KEY,
    nombre_categoria VARCHAR2(25) NOT NULL
);

-- AFP
CREATE TABLE AFP (
    id_afp NUMBER(3) GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 6) CONSTRAINT PK_AFP PRIMARY KEY,
    nom_afp VARCHAR2(100) NOT NULL
);

-- SALUD
CREATE TABLE SALUD (
    id_salud   NUMBER(5) CONSTRAINT PK_SALUD PRIMARY KEY,
    nom_salud  VARCHAR2(100) NOT NULL
);

-- MEDIO DE PAGO
CREATE TABLE MEDIO_PAGO (
    id_medio_pago NUMBER(3) CONSTRAINT PK_MEDIO_PAGO PRIMARY KEY,
    nom_medio VARCHAR2(50)  NOT NULL
);

-- COMUNA 
CREATE TABLE COMUNA (
    id_comuna  NUMBER(4) NOT NULL,
    nom_comuna VARCHAR2(100) NOT NULL,
    cod_region NUMBER(4)     NOT NULL,
    CONSTRAINT PK_COMUNA PRIMARY KEY(id_comuna),
    CONSTRAINT FK_COMUNA_REGION FOREIGN KEY (cod_region)
        REFERENCES REGION(id_region)
);

-- PROVEEDOR 
CREATE TABLE PROVEEDOR (
    id_proveedor     NUMBER(5) PRIMARY KEY,
    nombre_proveedor VARCHAR2(150) NOT NULL,
    rut_proveedor    VARCHAR2(20)  NOT NULL CONSTRAINT UN_PROVEEDOR_RUT UNIQUE,
    telefono VARCHAR2(20),
    email VARCHAR2(100),
    direccion VARCHAR2(200),
    activo CHAR(1) CONSTRAINT CK_PROV_ACTIVO CHECK (activo IN ('S','N')),
    cod_comuna       NUMBER(4)     NOT NULL,
    CONSTRAINT FK_PROVEEDOR_COMUNA FOREIGN KEY (cod_comuna)
        REFERENCES COMUNA(id_comuna)
);


CREATE TABLE PRODUCTO (
    id_producto     NUMBER(4)      CONSTRAINT PK_PRODUCTO PRIMARY KEY,
    nombre_producto VARCHAR2(100)  NOT NULL,
    precio_unitario NUMBER(10,2)   NOT NULL,
    origen_nacional CHAR(1) CONSTRAINT CK_ORIGEN CHECK (origen_nacional IN ('S','N')),
    stock_minimo NUMBER NOT NULL,
    activo CHAR(1) CONSTRAINT CK_PROD_ACTIVO CHECK (activo IN ('S','N')),
    cod_marca NUMBER(3),
    cod_categoria NUMBER(3),
    cod_proveedor NUMBER(5),
    CONSTRAINT FK_PRODUCTO_MARCA FOREIGN KEY (cod_marca)
        REFERENCES MARCA(id_marca),
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (cod_categoria)
        REFERENCES CATEGORIA(id_categoria),
    CONSTRAINT FK_PRODUCTO_PROVEEDOR FOREIGN KEY (cod_proveedor)
        REFERENCES PROVEEDOR(id_proveedor)
);

-- EMPLEADO 
CREATE TABLE EMPLEADO (
    id_empleado       NUMBER(4) PRIMARY KEY,
    rut_empleado      VARCHAR2(10) CONSTRAINT EMPLEADO_RUT_NN NOT NULL,
    nombre_empleado   VARCHAR2(25) NOT NULL,
    apellido_paterno  VARCHAR2(25) NOT NULL,
    apellido_materno  VARCHAR2(25) CONSTRAINT EMPLEADO_APEMAT_NN NOT NULL,
    fecha_contratacion DATE CONSTRAINT EMPLEADO_FECHA_NN NOT NULL,
    sueldo_base NUMBER(10) NOT NULL,
    bono_jefatura NUMBER,
    activo CHAR(1) NOT NULL CONSTRAINT CK_EMPLEADO_ACTIVO CHECK (activo IN ('S','N')),
    tipo_empleado VARCHAR2(25) NOT NULL, 
    cod_empleado NUMBER,
    cod_salud NUMBER(4) NOT NULL,
    cod_afp NUMBER(5) NOT NULL,
    CONSTRAINT FK_EMPLEADO_ENCARGADO FOREIGN KEY(cod_empleado) REFERENCES EMPLEADO(id_empleado),
    CONSTRAINT FK_EMPLEADO_SALUD FOREIGN KEY(cod_salud) REFERENCES SALUD(id_salud),
    CONSTRAINT FK_EMPLEADO_AFP FOREIGN KEY(cod_afp) REFERENCES AFP(id_afp)
);

-- ADMINISTRATIVO
CREATE TABLE ADMINISTRATIVO (
    id_empleado  NUMBER(5) CONSTRAINT PK_ADMINISTRATIVO PRIMARY KEY,
    area         VARCHAR2(100),
    CONSTRAINT FK_ADMINISTRATIVO_EMPLEADO FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADO(id_empleado)
);

-- VENDEDOR
CREATE TABLE VENDEDOR (
    id_empleado NUMBER(5) CONSTRAINT PK_VENDEDOR PRIMARY KEY,
    comision NUMBER(5,2),
    CONSTRAINT FK_VENDEDOR_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);


CREATE TABLE VENTA (
    id_venta     NUMBER(6) GENERATED ALWAYS AS IDENTITY(START WITH 5050 INCREMENT BY 3)
    CONSTRAINT PK_VENTA PRIMARY KEY,
    fecha_venta  DATE NOT NULL,
    total        NUMBER(12,2),
    cod_empleado NUMBER(5) NOT NULL,
    cod_medio    NUMBER(3) NOT NULL,
    CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (cod_empleado)
        REFERENCES EMPLEADO(id_empleado),
    CONSTRAINT FK_VENTA_MEDIO FOREIGN KEY (cod_medio)
        REFERENCES MEDIO_PAGO(id_medio_pago)
);

-- DETALLE_VENTA 
CREATE TABLE DETALLE_VENTA (
    id_detalle   NUMBER(6) CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY,
    cantidad     NUMBER(6) NOT NULL,
    subtotal     NUMBER(12,2) NOT NULL,
    cod_venta    NUMBER(6) NOT NULL,
    cod_producto NUMBER(4) NOT NULL,
    CONSTRAINT FK_DET_VENTA FOREIGN KEY (cod_venta)
        REFERENCES VENTA(id_venta),
    CONSTRAINT FK_DET_PRODUCTO FOREIGN KEY (cod_producto)
        REFERENCES PRODUCTO(id_producto)
);
--Modificación de tablas--
ALTER TABLE EMPLEADO ADD CONSTRAINT ck_sueldo_base CHECK(sueldo_base>=400000);
ALTER TABLE VENDEDOR ADD CONSTRAINT ck_comision_venta CHECK(comision>=0 and comision<=0.25);
ALTER TABLE PRODUCTO ADD CONSTRAINT ck_stock_min CHECK(stock_minimo>=3);
ALTER TABLE PROVEEDOR ADD CONSTRAINT unq_correo UNIQUE (email);
ALTER TABLE MARCA ADD CONSTRAINT unq_nombre_marca UNIQUE (nombre_marca);
ALTER TABLE DETALLE_VENTA ADD CONSTRAINT ck_cantidad_min CHECK(cantidad>=1);

--Objetos secuencia--
CREATE SEQUENCE seq_salud START WITH 2050 INCREMENT BY 10 NOCACHE;
CREATE SEQUENCE seq_empleado START WITH 750 INCREMENT BY 3 NOCACHE;

--Poblamiento tabla REGION--
INSERT INTO REGION (id_region, nom_region)VALUES(1, 'REGION METROPOLITANA');
INSERT INTO REGION (id_region, nom_region)VALUES(2, 'VALPARAISO');
INSERT INTO REGION (id_region, nom_region)VALUES(3, 'BIO BIO');
INSERT INTO REGION (id_region, nom_region)VALUES(4, 'LOS LAGOS');

--Poblamiento tabla AFP--
INSERT INTO AFP (nom_afp) VALUES('AFP HABITAT');
INSERT INTO AFP (nom_afp) VALUES('AFP CUPRUM');
INSERT INTO AFP (nom_afp) VALUES('AFP PROVIDA');
INSERT INTO AFP (nom_afp) VALUES('AFP PLAN VITAL');

--Poblamiento tabla SALUD--
INSERT INTO SALUD (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'FONASA');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'ISAPRE COLMENA');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'ISAPRE BANMEDICA');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'ISAPRE CRUZ BLANCA');

--Poblamiento MEDIO_PAGO--
INSERT INTO MEDIO_PAGO(id_medio_pago, nom_medio) VALUES (11, 'EFECTIVO');
INSERT INTO MEDIO_PAGO(id_medio_pago, nom_medio) VALUES (12, 'TARJETA DEBITO');
INSERT INTO MEDIO_PAGO(id_medio_pago, nom_medio) VALUES (13, 'TARJETA CREDITO');
INSERT INTO MEDIO_PAGO(id_medio_pago, nom_medio) VALUES (14, 'CHEQUE');

--Poblamiento tabla EMPLEADO--

INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '11111111-1','Marcela','González','Perez',DATE '2022-03-15',950000,
80000,'S', 'Administratvio', null, 2050, 210) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '22222222-2','Jose','Muñoz','Ramirez',DATE '2021-07-10',900000,
75000,'S', 'Administratvio', null, 2060, 216) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '33333333-3','Veronica','Soto','Alarcon',DATE '2020-01-05',880000,
70000,'S', 'Vendedor', 750, 2060, 228) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '44444444-4','Luis','Reyes','Fuentes',DATE '2023-04-01',560000,
null,'S', 'Vendedor', 750, 2070, 228) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '55555555-5','Claudia','Fernandez','Lagos',DATE '2023-04-15',600000,
null,'S', 'Vendedor', 753, 2070, 216) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '66666666-6','Carlos','Navarro','Vega',DATE '2023-05-01',610000,
null,'S', 'Administratvio', 753, 2060, 210) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '77777777-7','Javiera','Pino','Rojas',DATE '2023-05-10',650000,
null,'S', 'Administratvio', 750, 2050, 210) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '88888888-8','Diego','Mella','Contreras',DATE '2023-05-12',620000,
null,'S', 'Vendedor', 750, 2060, 216) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '99999999-9','Fernanda','Salas','Herrera',DATE '2023-05-18',570000,
null,'S', 'Vendedor', 753, 2070, 228) ;
INSERT INTO EMPLEADO(id_empleado, rut_empleado,nombre_empleado,apellido_paterno,
apellido_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,
tipo_empleado,cod_empleado,cod_salud,cod_afp) VALUES (seq_empleado.NEXTVAL, '10101010-0','Tomas','Vidal','Espinoza',DATE '2023-06-01',530000,
null,'S', 'Vendedor', null, 2050, 222) ;


SELECT id_empleado AS "Identificador",
       nombre_empleado ||' '||apellido_paterno||' '||apellido_materno AS "Nombre completo",
       sueldo_base AS Salario,
       bono_jefatura AS Bonificacion,
       sueldo_base + bono_jefatura AS "Salario simulado"
FROM EMPLEADO WHERE activo='S' AND bono_jefatura>=0;

SELECT nombre_empleado ||' '||apellido_paterno||' '||apellido_materno AS "Empleado",
       sueldo_base AS Sueldo,
       sueldo_base*0.08 AS "Posible Aumento",
       sueldo_base + (sueldo_base*0.08) AS "Salario simulado"
FROM EMPLEADO WHERE sueldo_base BETWEEN 550000 AND 800000 ORDER BY sueldo_base ASC