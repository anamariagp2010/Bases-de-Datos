CREATE TABLE CIUDAD (
    IDCIUDAD NUMBER PRIMARY KEY,
    NOMBRECIUDAD VARCHAR(50) NOT NULL
);
--CRUD PARA LA TABLA CIUDADES--
CREATE OR REPLACE FUNCTION VALIDAR_CIUDAD(V_ID IN CIUDAD.IDCIUDAD%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM CIUDAD
    WHERE IDCIUDAD = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;
CREATE OR REPLACE PROCEDURE REGISTRAR_CIUDADES(C_ID        NUMBER,
                                   C_NOMBRE   VARCHAR2)
IS
BEGIN
  IF VALIDAR_CIUDAD(C_ID) = FALSE THEN
      INSERT INTO CIUDAD (IDCIUDAD,NOMBRECIUDAD)
      VALUES (C_ID,C_NOMBRE);
      DBMS_OUTPUT.PUT_LINE('Ciudad agregada: '|| C_ID || ' ' || C_NOMBRE);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE CIUDAD SET
    NOMBRECIUDAD = C_NOMBRE
    WHERE
    IDCIUDAD = C_ID;
    DBMS_OUTPUT.PUT_LINE('Ciudad: '|| C_ID || ' actualizada');
    COMMIT;
  END IF;
  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando cliente ');
        rollback;
END REGISTRAR_CIUDADES;

CREATE OR REPLACE PROCEDURE LEER_CIUDAD(C_ID NUMBER)
IS
rciudad CIUDAD%ROWTYPE;
BEGIN
    IF VALIDAR_CIUDAD(C_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE(' la ciudad no existe ');
    ELSE
        SELECT * into rciudad  FROM CIUDAD WHERE IDCIUDAD = C_ID;
        DBMS_OUTPUT.PUT_LINE(' id Ciudad: '|| rciudad.IDCIUDAD || ' nombre ciudad: ' || rciudad.NOMBRECIUDAD );
    END IF;
END LEER_CIUDAD;

CREATE OR REPLACE PROCEDURE DELETE_CIUDAD(C_ID NUMBER)
IS
BEGIN
    IF VALIDAR_CIUDAD(C_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE(' Ciudad: '|| C_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM CIUDAD
        WHERE IDCIUDAD = C_ID;
        DBMS_OUTPUT.PUT_LINE('Ciudad borrada');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(' Se presento un error borrando la ciudad ');
    rollback;  
END DELETE_CIUDAD;

set serveroutput on
-----------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE PLANES (
    IDPLAN NUMBER PRIMARY KEY,
    NOMBRE_PLAN varchar2(255) NOT NULL,
    TIPO_DE_PLAN NUMBER NOT NULL,
    PRECIO_PLAN NUMBER  NULL,            
    VAL_MIN_ADICIONAL NUMBER  NULL,
    DESC_PLAN VARCHAR2 (255) NOT NULL,
    PRECIO_MINUTO  NUMBER  null,    
    MINUTOS_VOZ NUMBER NOT NULL,
    G_DISPONIBLES NUMBER NOT NULL,
    MSG_INCLUIDOS NUMBER NOT NULL 
);
CREATE OR REPLACE FUNCTION VALIDAR_PLAN(V_ID IN PLANES.IDPLAN%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM PLANES
    WHERE IDPLAN = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_PLAN(P_ID     NUMBER,
                                   P_NOMBRE   VARCHAR2,
                                   P_TIPO VARCHAR2,
                                   P_PRECIO NUMBER,
                                   P_VAL_MINADICIONAL NUMBER,
                                   P_DESC VARCHAR2,
                                   P_PRECIO_MINUTO NUMBER,
                                   P_MINUTOS_VOZ NUMBER,
                                   P_G_DISPONIBLES NUMBER,
                                   P_MSJ_INCLUIDOS NUMBER
                                   )
IS
err_num NUMBER;
err_msg VARCHAR2(255);

BEGIN
  IF VALIDAR_PLAN(P_ID) = FALSE THEN
      INSERT INTO PLANES (IDPLAN,NOMBRE_PLAN,TIPO_DE_PLAN,PRECIO_PLAN,VAL_MIN_ADICIONAL,DESC_PLAN,PRECIO_MINUTO,MINUTOS_VOZ,G_DISPONIBLES,MSG_INCLUIDOS)
      VALUES (P_ID,P_NOMBRE,P_TIPO,P_PRECIO,P_VAL_MINADICIONAL,P_DESC,P_PRECIO_MINUTO,P_MINUTOS_VOZ,P_G_DISPONIBLES,P_MSJ_INCLUIDOS);
      DBMS_OUTPUT.PUT_LINE('Plan agregado: '|| P_ID || ' ' || P_NOMBRE);
      COMMIT;
  ELSE
  --HACE UPDATE--
    UPDATE PLANES SET
    NOMBRE_PLAN = P_NOMBRE,
    PRECIO_PLAN = P_PRECIO,
    VAL_MIN_ADICIONAL = P_VAL_MINADICIONAL,
    DESC_PLAN = P_DESC,
    PRECIO_MINUTO=P_PRECIO_MINUTO,
    MINUTOS_VOZ = P_MINUTOS_VOZ,
    G_DISPONIBLES = P_G_DISPONIBLES,
    MSG_INCLUIDOS = P_MSJ_INCLUIDOS   
    WHERE
    IDPLAN = P_ID;
    DBMS_OUTPUT.PUT_LINE('Plan : '|| P_ID || ' actualizado');
    COMMIT;
  END IF;  
        EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(err_msg);
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando cliente ');
        ROLLBACK;
END REGISTRAR_PLAN;

CREATE OR REPLACE PROCEDURE LEER_PLAN(P_ID IN PLANES.IDPLAN%TYPE)
IS
rplan PLANES%ROWTYPE;
BEGIN
    IF VALIDAR_PLAN(P_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El plan no existe :c');
    ELSE
        SELECT * into rplan  FROM PLANES WHERE IDPLAN = P_ID;
        DBMS_OUTPUT.PUT_LINE(' ID Plan: '|| rplan.IDPLAN || ' nombre Plan: ' || rplan.NOMBRE_PLAN );
    END IF;
END LEER_PLAN;

CREATE OR REPLACE PROCEDURE DEL_PLAN(P_ID NUMBER)
IS
BEGIN
    IF validar_plan(P_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Plan: '|| P_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM PLANES
        WHERE IDPLAN = P_ID;
        DBMS_OUTPUT.PUT_LINE('Plan borrado exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el plan ');
    rollback;  
END DEL_PLAN;
---------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE PLAN_CATALOGO (
    IDCATALOGO NUMBER REFERENCES CATALOGO(IDCATALOGO),
    IDPLAN NUMBER REFERENCES PLANES(IDPLAN)
);
--Crud de la tabla "PLAN_CATALOGO"
CREATE OR REPLACE FUNCTION VALIDAR_PCATALOGO(V_ID PLAN_CATALOGO.IDCATALOGO%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM PLAN_CATALOGO
    WHERE IDCATALOGO = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_PCATALOGO(C_ID        NUMBER,
                                   P_ID   number)
IS
BEGIN
  IF VALIDAR_PCATALOGO(C_ID) = FALSE THEN
      INSERT INTO PLAN_CATALOGO(idcatalogo,idplan)
      VALUES (C_ID,P_ID);
      DBMS_OUTPUT.PUT_LINE('Plan catalogo agregado: '|| C_ID);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE PLAN_CATALOGO SET
    IDPLAN = P_ID
    WHERE
    idcatalogo = C_ID;
    DBMS_OUTPUT.PUT_LINE('Plan catalogo: '|| C_ID || ' actualizado');
    COMMIT;
  END IF;
  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el plan catalogo ');
        rollback;
END REGISTRAR_PCATALOGO;

CREATE OR REPLACE PROCEDURE LEER_PCATALOGO(C_ID IN PLAN_CATALOGO.IDCATALOGO%TYPE)
IS
R PLAN_CATALOGO%ROWTYPE;
BEGIN
    IF VALIDAR_PCATALOGO(C_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El plan catalogo no existe :c');
    ELSE
        SELECT * into R  FROM PLAN_CATALOGO WHERE idcatalogo = C_ID;
        DBMS_OUTPUT.PUT_LINE(' ID Catalogo: '|| R.IDCATALOGO || ' ID PLAN : ' || R.IDPLAN );
    END IF;
END LEER_PCATALOGO;

CREATE OR REPLACE PROCEDURE DEL_PCATALOGO(C_ID NUMBER)
IS
BEGIN
    IF validar_pcatalogo(C_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Plan catalogo: '|| C_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM PLAN_CATALOGO
        WHERE idcatalogo = C_ID;
        DBMS_OUTPUT.PUT_LINE('Plan catalogo borrado exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el plan catalogo ');
    rollback;  
END DEL_PCATALOGO;
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE CATALOGO(
    IDCATALOGO NUMBER PRIMARY KEY,
    FECHA_INICIO DATE NOT NULL,
    FECHA_FIN DATE NOT NULL
);
--Crud de la  tabla "CATALOGO"--
CREATE OR REPLACE FUNCTION VALIDAR_CATALOGO(V_ID IN CATALOGO.IDCATALOGO%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM CATALOGO
    WHERE IDCATALOGO = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_CATALOGO(C_ID        NUMBER,
                                   F_INI   date,
                                   F_FIN date)
IS
BEGIN
  IF VALIDAR_CATALOGO(C_ID) = FALSE THEN
      INSERT INTO CATALOGO(idcatalogo,fecha_inicio,fecha_fin)
      VALUES (C_ID,F_INI,F_FIN);
      DBMS_OUTPUT.PUT_LINE('Catalogo agregado: '|| C_ID);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE CATALOGO SET
    fecha_inicio = F_INI,
    fecha_fin = F_FIN
    WHERE
    idcatalogo = C_ID;
    DBMS_OUTPUT.PUT_LINE('Catalogo: '|| C_ID || ' actualizado');
    COMMIT;
  END IF;
  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el catalogo ');
        rollback;
END REGISTRAR_CATALOGO;

CREATE OR REPLACE PROCEDURE LEER_CATALOGO(C_ID IN CATALOGO.IDCATALOGO%TYPE)
IS
R CATALOGO%ROWTYPE;
BEGIN
    IF VALIDAR_CATALOGO(C_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El catalogo no existe :c');
    ELSE
        SELECT * into R  FROM CATALOGO WHERE idcatalogo = C_ID;
        DBMS_OUTPUT.PUT_LINE(' ID Catalogo: '|| R.IDCATALOGO || ' Fecha inicio: ' || R.FECHA_INICIO || ' Fecha fin: ' ||R.FECHA_FIN);
    END IF;
END LEER_CATALOGO;

CREATE OR REPLACE PROCEDURE DEL_CATALOGO(C_ID NUMBER)
IS
BEGIN
    IF validar_catalogo(C_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Catalogo: '|| C_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM CATALOGO
        WHERE idcatalogo = C_ID;
        DBMS_OUTPUT.PUT_LINE('Catalogo borrado exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el catalogo ');
    rollback;  
END DEL_CATALOGO;
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE RANGOSSALARIOS(
    IDRANGOSALARIAL NUMBER PRIMARY KEY,
    RANGOINI NUMBER NOT NULL,
    RANGOFINI NUMBER NOT NULL
);
--Crud tabla rangos salarios--
CREATE OR REPLACE FUNCTION VALIDAR_RANGO(V_ID IN RANGOSSALARIOS.IDRANGOSALARIAL%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM RANGOSSALARIOS
    WHERE IDRANGOSALARIAL = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_RANGO(R_ID        NUMBER,
                                   R_INI   NUMBER,
                                   R_FINI NUMBER)
IS
BEGIN
  IF VALIDAR_RANGO(R_ID) = FALSE THEN
      INSERT INTO RANGOSSALARIOS(idrangosalarial,rangoini,rangofini)
      VALUES (R_ID,R_INI,R_FINI);
      DBMS_OUTPUT.PUT_LINE('Rango agregado: '|| R_ID);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE RANGOSSALARIOS SET
    rangoini = R_INI,
    rangofini = R_FINI
    WHERE
    idrangosalarial = R_ID;
    DBMS_OUTPUT.PUT_LINE('Rango: '|| R_ID || ' actualizado');
    COMMIT;
  END IF;
  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el rango ');
        rollback;
END REGISTRAR_RANGO;

CREATE OR REPLACE PROCEDURE LEER_RANGO(R_ID IN RANGOSSALARIOS.IDRANGOSALARIAL%TYPE)
IS
R RANGOSSALARIOS%ROWTYPE;
BEGIN
    IF VALIDAR_RANGO(R_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El rango no existe :c');
    ELSE
        SELECT * into R  FROM RANGOSSALARIOS WHERE IDRANGOSALARIAL = R_ID;
        DBMS_OUTPUT.PUT_LINE(' ID Rango: '|| R.IDRANGOSALARIAL || ' Rango inicial: ' || R.RANGOINI || ' Rango final: ' ||R.RANGOFINI);
    END IF;
END LEER_RANGO;

CREATE OR REPLACE PROCEDURE DEL_RANGO(R_ID NUMBER)
IS
BEGIN
    IF validar_rango(R_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Rango: '|| R_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM rangossalarios
        WHERE idrangosalarial = R_ID;
        DBMS_OUTPUT.PUT_LINE('Rango borrado exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el rango ');
    rollback;  
END DEL_RANGO;
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE CLIENTES (
    IDCLIENTE NUMBER PRIMARY KEY,
    TIPO_DOC VARCHAR(50) NOT NULL, --CC o TI
    NOMBRES VARCHAR(50)NOT NULL,
    APELLIDOS VARCHAR(50)NOT NULL, 
    DIRECCION_CASA VARCHAR(50) NOT NULL, 
    FECHA_NACIMIENTO DATE NOT NULL,
    SEXO NUMBER NOT NULL,-- 0 HOMBRE 1 MUJER
    TELEFONO NUMBER NOT NULL,
    OCUPACION VARCHAR(50)NOT NULL,
    CORREO VARCHAR(100)NOT NULL,
    IDRANGOSALARIAL NUMBER REFERENCES RANGOSSALARIOS(IDRANGOSALARIAL),
    IDCIUDAD NUMBER REFERENCES CIUDAD(IDCIUDAD)
    -- Falta tipoPlan? NOOOO!!
);
--Crud de la tabla "CLIENTES"--
CREATE OR REPLACE FUNCTION VALIDAR_CLIENTE(V_ID CLIENTES.IDCLIENTE%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM CLIENTES
    WHERE IDCLIENTE = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_CLIENTE(C_ID clientes.idcliente%type ,
                                T_DOC clientes.tipo_doc%type,
                                NOMBRES clientes.nombres%type,
                                APELLIDOS clientes.apellidos%type,
                                DIRECCION clientes.direccion_casa%type,
                                FECHA_NAC clientes.fecha_nacimiento%type,
                                SEXO clientes.sexo%type,
                                TEL clientes.telefono%type,
                                OCUPACION clientes.ocupacion%type,
                                CORREO clientes.correo%type,
                                IDRANGO clientes.idrangosal%type,
                                CIUDAD_CLI clientes.ciudad_cliente%type)
IS
BEGIN
  IF validar_cliente(C_ID) = FALSE THEN
      INSERT INTO clientes(idcliente,tipo_doc,nombres,apellidos,direccion_casa,fecha_nacimiento,sexo,telefono,ocupacion,correo,idrangosal,ciudad_cliente)
      VALUES (C_ID,T_DOC,NOMBRES,APELLIDOS,DIRECCION,FECHA_NAC,SEXO,TEL,OCUPACION,CORREO,IDRANGO,CIUDAD_CLI);
      DBMS_OUTPUT.PUT_LINE('Cliente agregado: '|| C_ID);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE CLIENTES SET
    tipo_doc = T_DOC,
    nombres = NOMBRES,
    apellidos = APELLIDOS,
    direccion_casa = DIRECCION,
    fecha_nacimiento = FECHA_NAC,
    sexo = SEXO,
    telefono = TEL,
    ocupacion = OCUPACION,
    correo = CORREO,
    idrangosal = IDRANGO,
    ciudad_cliente = CIUDAD_CLI
    WHERE
    idcliente = C_ID;
    DBMS_OUTPUT.PUT_LINE('Cliente : '|| C_ID || ' actualizado');
    COMMIT;
  END IF;
  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el cliente ');
        rollback;
END REGISTRAR_CLIENTE;

CREATE OR REPLACE PROCEDURE LEER_CLIENTE(C_ID IN CLIENTES.IDCLIENTE%TYPE)
IS
R CLIENTES%ROWTYPE;
BEGIN
    IF VALIDAR_CLIENTE(C_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no existe :c');
    ELSE
        SELECT * into R  FROM CLIENTES WHERE idcliente = C_ID;
        DBMS_OUTPUT.PUT_LINE(' ID CLIENTE: '|| R.IDCLIENTE || ' Nombres : ' || R.NOMBRES || ' Apellidos ' || R.APELLIDOS );
    END IF;
END LEER_CLIENTE;

CREATE OR REPLACE PROCEDURE DEL_CLIENTE(C_ID CLIENTES.IDCLIENTE%TYPE)
IS
BEGIN
    IF validar_cliente(C_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El cliente : '|| C_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM CLIENTES
        WHERE idcliente = C_ID;
        DBMS_OUTPUT.PUT_LINE('Cliente borrado exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el cliente ');
    rollback;  
END DEL_CLIENTE;
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE CONTRATO (
    IDCONTRATO NUMBER PRIMARY KEY,
    IDPLAN NUMBER REFERENCES PLANES(IDPLAN),
    NUM_CEL NUMBER NOT NULL,
    IDSUCURSAL NUMBER REFERENCES SUCURSALES(IDSUCURSAL), 
    IDCLIENTE  NUMBER REFERENCES CLIENTES(IDCLIENTE), 
    FECHA_INICIO_CONTRATO DATE NOT NULL,
    FECHA_FINAL_CONTRATO DATE NOT NULL,
    FECHA_CORTE_FACTURA NUMBER NULL 
    --(para postpago, genera factura y reinicia los minutos En cierta fecha cada mes)
);
--Crud de la tabla "Contrato"--
CREATE OR REPLACE FUNCTION VALIDAR_CONTRATO(V_ID IN CONTRATO.IDCONTRATO%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM CONTRATO
    WHERE IDCONTRATO = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_CONTRATO(C_ID  CONTRATO.IDCONTRATO%TYPE,
                                   P_ID   CONTRATO.IDPLAN%TYPE,
                                   N_CEL CONTRATO.NUM_CEL%TYPE,
                                   S_ID CONTRATO.IDSUCURSAL%TYPE,
                                   CC CONTRATO.CC_CLIENTE%TYPE,
                                   F_INI CONTRATO.FECHA_INICIO_CONTRATO%TYPE,
                                   F_FIN CONTRATO.FECHA_FINAL_CONTRATO%TYPE,
                                   DIA CONTRATO.DIA_CORTE%TYPE
                                   )
IS
BEGIN
  IF VALIDAR_CONTRATO(C_ID) = FALSE THEN
      INSERT INTO CONTRATO(IDCONTRATO,IDPLAN,NUM_CEL,IDSUCURSAL,CC_CLIENTE,FECHA_INICIO_CONTRATO,FECHA_FINAL_CONTRATO,DIA_CORTE)
      VALUES(C_ID,P_ID,N_CEL,S_ID,CC,F_INI,F_FIN,DIA);
      DBMS_OUTPUT.PUT_LINE('Contrato creado: '|| C_ID || ' con el id plan ' || P_ID);
      COMMIT;
  ELSE
  --HACE UPDATE--
    UPDATE CONTRATO SET
    IDPLAN = P_ID,
    NUM_CEL = N_CEL,
    IDSUCURSAL = S_ID,
    CC_CLIENTE = CC,
    FECHA_INICIO_CONTRATO = F_INI,
    FECHA_FINAL_CONTRATO = F_FIN,
    DIA_CORTE = DIA
    WHERE
    IDCONTRATO = C_ID;
    DBMS_OUTPUT.PUT_LINE('Contrato : '|| C_ID || ' actualizado');
    COMMIT;
  END IF;  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error creando el contrato ');
        ROLLBACK;
END REGISTRAR_CONTRATO;

CREATE OR REPLACE PROCEDURE LEER_CONTRATO(C_ID IN CONTRATO.IDCONTRATO%TYPE)
IS
rcontrato CONTRATO%ROWTYPE;
BEGIN
    IF VALIDAR_CONTRATO(C_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El contrato no existe');
    ELSE
        SELECT * into rcontrato  FROM CONTRATO WHERE IDCONTRATO = C_ID;
        DBMS_OUTPUT.PUT_LINE(' ID contrato: '|| rcontrato.IDCONTRATO || ' ID sucursal: ' || rcontrato.IDSUCURSAL || ' CC cliente: ' || rcontrato.CC_CLIENTE);
    END IF;
END LEER_CONTRATO;

CREATE OR REPLACE PROCEDURE DEL_CONTRATO(C_ID IN CONTRATO.IDCONTRATO%TYPE)
IS
BEGIN
    IF VALIDAR_CONTRATO(C_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('Contrato: '|| C_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM CONTRATO
        WHERE IDCONTRATO = C_ID;
        DBMS_OUTPUT.PUT_LINE('Contrato borrado exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el contrato ');
    rollback;  
END DEL_CONTRATO;
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE SUCURSALES (
    IDSUCURSAL NUMBER PRIMARY KEY,
    NOMBRE_SUCURSAL VARCHAR(50) NOT NULL,
    IDCIUDAD NUMBER REFERENCES CIUDAD(IDCIUDAD)
);
--Crud de la tabla "SUCURSAL"--
CREATE OR REPLACE FUNCTION VALIDAR_SUCURSAL(V_ID IN SUCURSALES.IDSUCURSAL%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM SUCURSALES
    WHERE IDSUCURSAL = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_SUCURSAL(S_ID  SUCURSALES.IDSUCURSAL%TYPE,
                                   S_NOMBRE   SUCURSALES.NOMBRE_SUCURSAL%TYPE,
                                   C_ID SUCURSALES.IDCIUDAD%TYPE
                                   )
IS
BEGIN
  IF VALIDAR_SUCURSAL(S_ID) = FALSE THEN
      INSERT INTO SUCURSALES(IDSUCURSAL,NOMBRE_SUCURSAL,IDCIUDAD)
      VALUES(S_ID,S_NOMBRE,C_ID);
      DBMS_OUTPUT.PUT_LINE('Sucursal agregada: '|| S_ID || ' ' || S_NOMBRE);
      COMMIT;
  ELSE
  --HACE UPDATE--
    UPDATE SUCURSALES SET
    NOMBRE_SUCURSAL = S_NOMBRE,
    IDCIUDAD = C_ID   
    WHERE
    IDSUCURSAL = S_ID;
    DBMS_OUTPUT.PUT_LINE('Sucursal : '|| S_ID || ' actualizado');
    COMMIT;
  END IF;  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando sucursal ');
        ROLLBACK;
END REGISTRAR_SUCURSAL;

CREATE OR REPLACE PROCEDURE LEER_SUCURSAL(S_ID IN SUCURSALES.IDSUCURSAL%TYPE)
IS
rsucursal SUCURSALES%ROWTYPE;
BEGIN
    IF VALIDAR_SUCURSAL(S_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('La sucursal no existe');
    ELSE
        SELECT * into rsucursal  FROM SUCURSALES WHERE IDSUCURSAL = S_ID;
        DBMS_OUTPUT.PUT_LINE(' ID sucursal: '|| rsucursal.IDSUCURSAL || ' nombre sucursal: ' || rsucursal.NOMBRE_SUCURSAL || ' nombre ciudad: ' || rsucursal.IDCIUDAD);
    END IF;
END LEER_SUCURSAL;

CREATE OR REPLACE PROCEDURE DEL_SUCURSAL(S_ID IN SUCURSALES.IDSUCURSAL%TYPE)
IS
BEGIN
    IF VALIDAR_SUCURSAL(S_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('SUCURSAL: '|| S_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM SUCURSALES
        WHERE IDSUCURSAL = S_ID;
        DBMS_OUTPUT.PUT_LINE('Sucursal borrada exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrandola sucursal ');
    rollback;  
END DEL_SUCURSAL;
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE RECARGAS (
    IDRECARGA NUMBER PRIMARY KEY,
    IDCONTRATO NUMBER REFERENCES CONTRATO(IDCONTRATO), --(por el numCel)
    VALOR_RECARGADO NUMBER NOT NULL,
    FECHA DATE NOT NULL
);
CREATE OR REPLACE FUNCTION VALIDAR_RECARGA(V_ID IN RECARGAS.IDRECARGA%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM RECARGAS
    WHERE IDRECARGA = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_RECARGA(R_ID  RECARGAS.IDRECARGA%TYPE,
                                   C_ID   RECARGAS.IDCONTRATO%TYPE,
                                   VR RECARGAS.VALOR_RECARGADO%TYPE,
                                   FE RECARGAS.FECHA%TYPE
                                   )
IS
BEGIN
  IF VALIDAR_RECARGA(R_ID) = FALSE THEN
      INSERT INTO RECARGAS(IDRECARGA,IDCONTRATO,VALOR_RECARGADO,FECHA)
      VALUES(R_ID,C_ID,VR,FE);
      DBMS_OUTPUT.PUT_LINE('Recarga agregada! ID: '|| R_ID || ' valor recarga ' || VR);
      COMMIT;
  ELSE
  --HACE UPDATE--
    UPDATE RECARGAS SET
    IDCONTRATO = C_ID,
    VALOR_RECARGADO = VR,  
    FECHA = FE
    WHERE
    IDRECARGA = R_ID;
    DBMS_OUTPUT.PUT_LINE('Recarga : ID '|| R_ID || ' actualizada');
    COMMIT;
  END IF;  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando recarga ');
        ROLLBACK;
END REGISTRAR_RECARGA;

CREATE OR REPLACE PROCEDURE LEER_RECARGA(R_ID IN RECARGAS.IDRECARGA%TYPE)
IS
recarga RECARGAS%ROWTYPE;
BEGIN
    IF VALIDAR_RECARGA(R_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('La recarga no existe');
    ELSE
        SELECT * into recarga  FROM RECARGAS WHERE IDRECARGA = R_ID;
        DBMS_OUTPUT.PUT_LINE(' ID recarga: '|| recarga.IDRECARGA || ' valor recarga: ' || recarga.VALOR_RECARGADO);
    END IF;
END LEER_RECARGA;

CREATE OR REPLACE PROCEDURE DEL_RECARGA(R_ID IN RECARGAS.IDRECARGA%TYPE)
IS
BEGIN
    IF VALIDAR_RECARGA(R_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('RECARGA: '|| R_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM RECARGAS
        WHERE IDRECARGA = R_ID;
        DBMS_OUTPUT.PUT_LINE('recarga borrada exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando la recarga ');
    rollback;  
END DEL_RECARGA;

--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE SALDO_PREPAGO (
    IDSALDOPREPAGO NUMBER PRIMARY KEY,
    IDCONTRATO NUMBER REFERENCES CONTRATO(IDCONTRATO),
    SALDO_ACTUAL_DINERO NUMBER NOT NULL
);
CREATE OR REPLACE FUNCTION VALIDAR_SALDO_PRE(V_ID IN SALDO_PREPAGO.IDSALDOPREPAGO%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM SALDO_PREPAGO
    WHERE IDSALDOPREPAGO = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_SALDO_PRE(S_ID SALDO_PREPAGO.IDSALDOPREPAGO%TYPE,
                                   C_ID   SALDO_PREPAGO.IDCONTRATO%TYPE,
                                   SA SALDO_PREPAGO.SALDO_ACTUAL_DINERO%TYPE)
IS
BEGIN
  IF VALIDAR_SALDO_PRE(S_ID) = FALSE THEN
      INSERT INTO SALDO_PREPAGO(IDSALDOPREPAGO,IDCONTRATO,SALDO_ACTUAL_DINERO)
      VALUES (S_ID,C_ID,SA);
      DBMS_OUTPUT.PUT_LINE('Saldo agregado: '|| S_ID);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE SALDO_PREPAGO SET
    IDCONTRATO = C_ID,--Is this necessary??
    SALDO_ACTUAL_DINERO = SA
    WHERE
    IDSALDOPREPAGO = S_ID;
    DBMS_OUTPUT.PUT_LINE('saldo: '|| S_ID || ' actualizado');
    COMMIT;
  END IF;
  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el saldo ');
        rollback;
END REGISTRAR_SALDO_PRE;

CREATE OR REPLACE PROCEDURE LEER_SALDO_PREPAGO(S_ID IN SALDO_PREPAGO.IDSALDOPREPAGO%TYPE)
IS
rsaldo SALDO_PREPAGO%ROWTYPE;
BEGIN
    IF VALIDAR_SALDO_PRE(S_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El saldo no existe');
    ELSE
        SELECT * into rsaldo  FROM SALDO_PREPAGO WHERE IDSALDOPREPAGO = S_ID;
        DBMS_OUTPUT.PUT_LINE(' ID saldo: '|| rsaldo.IDSALDOPREPAGO || ' valor saldo: ' || rsaldo.SALDO_ACTUAL_DINERO);
    END IF;
END LEER_SALDO_PREPAGO;

CREATE OR REPLACE PROCEDURE DEL_SALDO_PRE(S_ID IN SALDO_PREPAGO.IDSALDOPREPAGO%TYPE)
IS
BEGIN
    IF VALIDAR_SALDO_PRE(S_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('saldo: '|| S_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM SALDO_PREPAGO
        WHERE IDSALDOPREPAGO = S_ID;
        DBMS_OUTPUT.PUT_LINE('saldo borrado exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el saldo ');
    rollback;  
END DEL_SALDO_PRE;
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE SALDO_POSTPAGO (
    IDSALDO NUMBER PRIMARY KEY,
    IDCONTRATO NUMBER REFERENCES CONTRATO(IDCONTRATO),
    TIPO_POSTPAGO NUMBER NOT NULL, --"0" SIN CONTROL..."1" CON CONTROL
    SALDO_ACTUAL_MIN NUMBER NOT NULL, -- ESTE ES PARA AMBOS CON Y SIN CONTROL
    MINUTOS_ADICIONALES NUMBER NOT NULL -- SOLO  SIN CONTROL, CON CONTROL SE DEJA EN CERO SIEMPRE
);
CREATE OR REPLACE FUNCTION VALIDAR_SALDO_POST(V_ID IN SALDO_POSTPAGO.IDSALDO%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM SALDO_POSTPAGO
    WHERE IDSALDO = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_SALDO_POST(S_ID SALDO_POSTPAGO.IDSALDO%TYPE,
                                   C_ID   SALDO_POSTPAGO.IDCONTRATO%TYPE,
                                   T SALDO_POSTPAGO.TIPO_POSTPAGO%TYPE,
                                   SA SALDO_POSTPAGO.SALDO_ACTUAL_MIN%TYPE,
                                   MA SALDO_POSTPAGO.MINUTOS_ADICIONALES%TYPE )
IS
BEGIN
  IF VALIDAR_SALDO_POST(S_ID) = FALSE THEN
      INSERT INTO SALDO_POSTPAGO(IDSALDO,IDCONTRATO,TIPO_POSTPAGO,SALDO_ACTUAL_MIN,MINUTOS_ADICIONALES)
      VALUES (S_ID,C_ID,T,SA,MA);
      DBMS_OUTPUT.PUT_LINE('Saldo agregado: '|| S_ID);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE SALDO_POSTPAGO SET
    IDCONTRATO = C_ID,
    TIPO_POSTPAGO = T,
    SALDO_ACTUAL_MIN = SA,
    MINUTOS_ADICIONALES = MA
    WHERE
    IDSALDO = S_ID;
    DBMS_OUTPUT.PUT_LINE('saldo: '|| S_ID || ' actualizado');
    COMMIT;
  END IF;
  
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el saldo ');
        rollback;
END REGISTRAR_SALDO_POST;

CREATE OR REPLACE PROCEDURE LEER_SALDO_POSTPAGO(S_ID IN SALDO_POSTPAGO.IDSALDO%TYPE)
IS
rsaldo SALDO_POSTPAGO%ROWTYPE;
BEGIN
    IF VALIDAR_SALDO_POST(S_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('El saldo no existe');
    ELSE
        SELECT * into rsaldo  FROM SALDO_POSTPAGO WHERE IDSALDO = S_ID;
        DBMS_OUTPUT.PUT_LINE(' ID saldo: '|| rsaldo.IDSALDO || ' valor saldo minutos: ' || rsaldo.SALDO_ACTUAL_MIN);
    END IF;
END LEER_SALDO_POSTPAGO;

CREATE OR REPLACE PROCEDURE DEL_SALDO_POST(S_ID IN SALDO_POSTPAGO.IDSALDO%TYPE)
IS
BEGIN
    IF VALIDAR_SALDO_POST(S_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('saldo: '|| S_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM SALDO_POSTPAGO
        WHERE IDSALDO = S_ID;
        DBMS_OUTPUT.PUT_LINE('saldo borrado exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el saldo ');
    rollback;  
END DEL_SALDO_POST;

--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE LLAMADAS (
    IDLLAMADA NUMBER PRIMARY KEY,
    IDCONTRATO NUMBER REFERENCES CONTRATO(IDCONTRATO),
    NUM_TEL_REMITENTE NUMBER NOT NULL,
    NUM_TEL_DESTINO NUMBER NOT NULL,
    MIN_CONSUMIDOS NUMBER NOT NULL,        
    MIN_ADICIONALES_CONSUM NUMBER NOT NULL,
    FECHA DATE NOT NULL,
    CIUDAD_REMITENTE  NUMBER REFERENCES CIUDAD(IDCIUDAD),    
    CIUDAD_DESTINO NUMBER REFERENCES CIUDAD(IDCIUDAD),
    HORA NUMBER NOT NULL, --REVISAR SI HORA ES TIME
    OPERADOR_LLAMADA NUMBER NOT NULL --(INT 1/0)
 	  --(True si está en la base de datos, False si no) //se debe validar si 
		--el número destino no se encuentra en la base de datos de contratos de la empresa entonces 
		--es de otro operador, si existe en la bd entonces es una llamada del mismo operador
);
CREATE OR REPLACE FUNCTION VALIDAR_LLAMADA(V_ID IN LLAMADAS.IDLLAMADA%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM LLAMADAS
    WHERE IDLLAMADA = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_LLAMADA(L_ID LLAMADAS.IDLLAMADA%TYPE,
                                   C_ID   LLAMADAS.IDCONTRATO%TYPE,
                                   NR LLAMADAS.NUM_TEL_REMITENTE%TYPE,
                                   ND LLAMADAS.NUM_TEL_DESTINO%TYPE,
                                   MC LLAMADAS.MIN_CONSUMIDOS%TYPE,
                                   MAC LLAMADAS.MIN_ADICIONALES_CONSUM%TYPE,--Why do we now?
                                   F LLAMADAS.FECHA%TYPE,
                                   CR LLAMADAS.CIUDAD_REMITENTE%TYPE,
                                   CD LLAMADAS.CIUDAD_DESTINO%TYPE,
                                   H LLAMADAS.HORA%TYPE,
                                   OP LLAMADAS.OPERADOR_LLAMADA%TYPE)
IS
BEGIN
  IF VALIDAR_LLAMADA(L_ID) = FALSE THEN
      INSERT INTO LLAMADAS(IDLLAMADA,IDCONTRATO,NUM_TEL_REMITENTE,NUM_TEL_DESTINO,MIN_CONSUMIDOS,MIN_ADICIONALES_CONSUM,
                           FECHA,CIUDAD_REMITENTE,CIUDAD_DESTINO,HORA,OPERADOR_LLAMADA )
      VALUES (L_ID,C_ID,NR,ND,MC,MAC,F,CR,CD,H,OP);
      DBMS_OUTPUT.PUT_LINE('Llamada agregada: '|| L_ID);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE LLAMADAS SET
    IDCONTRATO = C_ID,
    NUM_TEL_REMITENTE = NR,
    NUM_TEL_DESTINO = ND,
    MIN_CONSUMIDOS = MC,
    MIN_ADICIONALES_CONSUM = MAC,
    FECHA = F,
    CIUDAD_REMITENTE = CR,
    CIUDAD_DESTINO = CD,
    HORA = H,
    OPERADOR_LLAMADA = OP
    WHERE
    IDLLAMADA = L_ID;
    DBMS_OUTPUT.PUT_LINE('Llamada: '|| L_ID || ' actualizada');
    COMMIT;
  END IF;
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando la llamada ');
        rollback;
END REGISTRAR_LLAMADA;

CREATE OR REPLACE PROCEDURE LEER_LLAMADA(L_ID IN LLAMADAS.IDLLAMADA%TYPE)
IS
rllamada LLAMADAS%ROWTYPE;
BEGIN
    IF VALIDAR_LLAMADA(L_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('La llamada no existe');
    ELSE
        SELECT * into rllamada  FROM LLAMADAS WHERE IDLLAMADA = L_ID;
        DBMS_OUTPUT.PUT_LINE(' ID Llamada: '|| rllamada.IDLLAMADA || ' minutos consumidos: ' || rllamada.MIN_CONSUMIDOS);
    END IF;
END LEER_LLAMADA;

CREATE OR REPLACE PROCEDURE DEL_LLAMADA(L_ID IN LLAMADAS.IDLLAMADA%TYPE)
IS
BEGIN
    IF VALIDAR_LLAMADA(L_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('la llamada: '|| L_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM LLAMADAS
        WHERE IDLLAMADA = L_ID;
        DBMS_OUTPUT.PUT_LINE('llamada borrada exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando la llamada ');
    rollback;  
END DEL_LLAMADA;

--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE FACTURACION_CABECERA (
    IDCABECERA NUMBER PRIMARY KEY,
    FECHA_FACT_INICIAL DATE NOT NULL,
    FECHA_FACT_FINAL DATE NOT NULL,
    NUM_TEL_REMITENTE NUMBER NOT NULL,
    SALDO_A_PAGAR NUMBER NOT NULL
);
CREATE OR REPLACE FUNCTION VALIDAR_CABECERA(V_ID IN FACTURACION_CABECERA.IDCABECERA%TYPE) RETURN BOOLEAN
IS
    v_temporal VARCHAR(1);
BEGIN
    SELECT 'x'
    INTO v_temporal
    FROM FACTURACION_CABECERA
    WHERE IDCABECERA = V_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

CREATE OR REPLACE PROCEDURE REGISTRAR_CABECERA(CAB_ID FACTURACION_CABECERA.IDCABECERA%TYPE,
                                   FI   FACTURACION_CABECERA.FECHA_FACT_INICIAL%TYPE,
                                   FF FACTURACION_CABECERA.FECHA_FACT_FINAL%TYPE,
                                   NR FACTURACION_CABECERA.NUM_TEL_REMITENTE%TYPE,
                                   SP FACTURACION_CABECERA.SALDO_A_PAGAR%TYPE)
IS
BEGIN
  IF VALIDAR_CABECERA(CAB_ID) = FALSE THEN
      INSERT INTO FACTURACION_CABECERA(IDCABECERA,FECHA_FACT_INICIAL,FECHA_FACT_FINAL,NUM_TEL_REMITENTE,SALDO_A_PAGAR )
      VALUES (CAB_ID,FI,FF,NR,SP);
      DBMS_OUTPUT.PUT_LINE('Cabecera de factura agregada: '|| CAB_ID);
      COMMIT;
  ELSE
  --HACE UPDATE
    UPDATE FACTURACION_CABECERA SET
    FECHA_FACT_INICIAL = FI,
    FECHA_FACT_FINAL = FF,
    NUM_TEL_REMITENTE = NR,
    SALDO_A_PAGAR = SP
    WHERE
    IDCABECERA = CAB_ID;
    DBMS_OUTPUT.PUT_LINE('cabecera: '|| CAB_ID || ' actualizada');
    COMMIT;
  END IF;
        EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando la cabecera de factura ');
        rollback;
END REGISTRAR_CABECERA;

CREATE OR REPLACE PROCEDURE LEER_CABECERA(CAB_ID IN FACTURACION_CABECERA.IDCABECERA%TYPE)
IS
rcabecera FACTURACION_CABECERA%ROWTYPE;
BEGIN
    IF VALIDAR_CABECERA(CAB_ID) = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('La cabecera de factura no existe');
    ELSE
        SELECT * into rcabecera  FROM FACTURACION_CABECERA WHERE IDCABECERA = CAB_ID;
        DBMS_OUTPUT.PUT_LINE(' ID cabecera: '|| rcabecera.IDCABECERA || ' numero al que corresponde la factura: ' || rcabecera.NUM_TEL_REMITENTE ||' valor a pagar: ' || rcabecera.SALDO_A_PAGAR);
    END IF;
END LEER_CABECERA;

CREATE OR REPLACE PROCEDURE DEL_CABECERA(CAB_ID IN FACTURACION_CABECERA.IDCABECERA%TYPE)
IS
BEGIN
    IF VALIDAR_CABECERA(CAB_ID)= FALSE THEN
        DBMS_OUTPUT.PUT_LINE('la cabecera: '|| CAB_ID || ' no existe');
        ROLLBACK;
    ELSE
        DELETE FROM FACTURACION_CABECERA
        WHERE IDCABECERA = CAB_ID;
        DBMS_OUTPUT.PUT_LINE('Cabecera de factura borrada exitosamente');
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando la cabecera de factura ');
    rollback;  
END DEL_CABECERA;

--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE FACTURACION_DETALLE (
    IDCABECERA NUMBER REFERENCES FACTURACION_CABECERA(IDCABECERA),
    IDLLAMADA NUMBER REFERENCES LLAMADAS(IDLLAMADA),
    NUM_TEL_DESTINO NUMBER NOT NULL,
    MIN_CONSUMIDOS NUMBER NOT NULL,        
    FECHA DATE NOT NULL,
    CIUDAD_REMITENTE  NUMBER REFERENCES CIUDAD(IDCIUDAD),    
    CIUDAD_DESTINO NUMBER REFERENCES CIUDAD(IDCIUDAD),
    HORA TIME NOT NULL,
    OPERADOR_LLAMADA BOOLEAN NOT NULL
);