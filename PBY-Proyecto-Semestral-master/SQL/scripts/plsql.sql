
--Package

CREATE OR REPLACE PACKAGE pkg_postulante IS
  --LUEGO VEMOS QUE SON
  v_cantidad_ahorro NUMERIC(12);
  v_cantidad_viv_elegida NUMERIC(2);
  
  v_id_folio_d NUMERIC(8);
  v_id_folio_a NUMERIC(10);
  
  v_edad NUMERIC (3);
  v_puntaje_edad NUMERIC(4);
  
  v_cant_cargas_fam NUMERIC (3);
  v_puntaje_cargas_fam NUMERIC (4);
  
  v_nombre_estado_civil VARCHAR2(35);
  v_puntaje_estado_civil NUMERIC (4);
  
  v_nombre_pueblo_orig VARCHAR2(40);
  v_pueblo_orig NUMERIC(1);
  v_puntaje_pueblo_orig NUMERIC(4);
  
  v_monto_ahorro NUMERIC(12);
  v_puntaje_monto_ahorro NUMERIC(4);
  
  v_posee_titulo NUMERIC(1);
  v_nombre_titulo VARCHAR2(50);
  v_puntaje_titulo NUMERIC (4);
  
  
  FUNCTION fn_total_cargas_familiares(p_run_pos NUMERIC) RETURN NUMERIC;
  FUNCTION fn_descripcion_estado_civil(p_run_pos NUMERIC) RETURN VARCHAR2;
  
END pkg_postulante;

--Package Body
/
CREATE OR REPLACE PACKAGE BODY pkg_postulante IS
  
  FUNCTION fn_total_cargas_familiares(p_run_pos NUMERIC) RETURN NUMERIC IS
    v_nro_folio_A NUMERIC(10);
    v_cant_cargas NUMERIC(3);
  BEGIN
    SELECT nro_folio_A INTO v_nro_folio_A FROM postulante WHERE run_postulante = p_run_pos;
    SELECT COUNT(run_carga) INTO v_cant_cargas FROM carga_familiar WHERE nro_folio_A = v_nro_folio_A;
    RETURN v_cant_cargas;
    EXCEPTION
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('error cant cargas familiares');
      INSERT INTO ERRORES_PROC_ASIG_PUNTAJE VALUES(SEQ_ERRORES_PROC_ASIG_PUNTAJE.NEXTVAL, 'PKG_POSTULANTE.FN_TOTAL_CARGAS_FAMILIARES', 'Error inesperado');
      RETURN 0;
  END fn_total_cargas_familiares;
  
  
  
  FUNCTION fn_descripcion_estado_civil(p_run_pos NUMERIC) RETURN VARCHAR2 IS
    v_desc_estado_civil VARCHAR2(25);
  BEGIN
    SELECT estado_civil INTO v_desc_estado_civil 
    FROM postulante pos JOIN estado_civil ec ON (pos.id_estado_civil = ec.id_estado_civil)
    WHERE pos.run_postulante = p_run_pos;
    RETURN v_desc_estado_civil;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('error des est civil');
      INSERT INTO ERRORES_PROC_ASIG_PUNTAJE VALUES(SEQ_ERRORES_PROC_ASIG_PUNTAJE.NEXTVAL, 'PKG_POSTULANTE.FN_DESCRIPCION_ESTADO_CIVIL', 'Error inesperado');
      RETURN '<NO ENCONTRADO>';
  END fn_descripcion_estado_civil;
  
END pkg_postulante;
/



--Funciones

CREATE OR REPLACE FUNCTION  fn_obtener_puntaje_cargas_fam (p_run_pos NUMERIC) RETURN NUMERIC IS
  v_cant NUMERIC(4) := 0;
BEGIN
  v_cant := pkg_postulante.fn_total_cargas_familiares(p_run_pos);
  IF v_cant > 4 THEN
    RETURN 200;
  ELSIF v_cant >= 2 THEN
    RETURN 100;
  ELSE
    RETURN 50;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('error objtener puntaje cargas familiares');
    INSERT INTO ERRORES_PROC_ASIG_PUNTAJE VALUES(SEQ_ERRORES_PROC_ASIG_PUNTAJE.NEXTVAL, 'FN_OBTENER_PUNTAJE_CARGAS_FAM', 'Error inesperado');
    RETURN 0;
END fn_obtener_puntaje_cargas_fam;

/

CREATE OR REPLACE FUNCTION fn_obtener_puntaje_ahorro (p_run_pos NUMERIC) RETURN NUMERIC IS
  v_monto_ahorro NUMERIC (12) := 0;
BEGIN
  SELECT monto_ahorrado INTO v_monto_ahorro 
  FROM postulante pos JOIN ahorro ah ON (pos.nro_folio_A = ah.nro_folio_A)
  WHERE pos.run_postulante = p_run_pos;
  
  IF v_monto_ahorro > 10000000 THEN
    RETURN 500;
  ELSIF v_monto_ahorro >= 9000000 THEN
    RETURN 400;
  ELSIF v_monto_ahorro >= 8000000 THEN
    RETURN 200;
  ELSE
    RETURN 0;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('error objtener puntaje monto ahorrado');
    INSERT INTO ERRORES_PROC_ASIG_PUNTAJE VALUES(SEQ_ERRORES_PROC_ASIG_PUNTAJE.NEXTVAL, 'FN_OBTENER_PUNTAJE_AHORRO', 'Error inesperado');
    RETURN 0;
END fn_obtener_puntaje_ahorro;


/


CREATE OR REPLACE FUNCTION fn_obtener_id_region (p_run_pos NUMERIC) RETURN NUMERIC IS 
  v_id_region NUMERIC(4);
BEGIN
  SELECT id_region INTO v_id_region
  FROM Postulante pos
    INNER JOIN vivienda_elegida ve
    ON (pos.nro_folio_A = ve.nro_folio_A)
    INNER JOIN caracteristica_vivienda cv
    ON (ve.nro_folio_D = cv.nro_folio_D)
    INNER JOIN comuna com
    ON (com.id_comuna = cv.id_comuna)
  WHERE pos.run_postulante = p_run_pos;
  
  RETURN v_id_region;
END fn_obtener_id_region;

/

CREATE OR REPLACE FUNCTION fn_obtener_region_porcentaje (p_run_pos NUMERIC) RETURN NUMERIC IS 
  v_porcentaje NUMERIC(6,2);
  v_id_region NUMERIC(4);
BEGIN
  v_id_region := fn_obtener_id_region(p_run_pos);
  
  SELECT NVL(porcentaje_puntaje,0) INTO v_porcentaje
  FROM region
  WHERE id_region = v_id_region;
  
  RETURN v_porcentaje;
END fn_obtener_region_porcentaje;

/

CREATE OR REPLACE FUNCTION fn_obtener_region_nombre (p_run_pos NUMERIC) RETURN NUMERIC IS 
  v_nombre VARCHAR2(150);
  v_id_region NUMERIC(4);
BEGIN
  v_id_region := fn_obtener_id_region(p_run_pos);
  
  SELECT region INTO v_nombre
  FROM region
  WHERE id_region = v_id_region;
  
  RETURN v_nombre;
END fn_obtener_region_nombre;

/

CREATE OR REPLACE FUNCTION fn_calcular_edad (p_nacimiento DATE) RETURN NUMERIC IS
  v_edad NUMERIC(3);
BEGIN
  v_edad := FLOOR(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'), '9999') - TO_NUMBER(TO_CHAR(p_nacimiento, 'YYYY'), '9999')) - 1;
  IF TO_NUMBER(TO_CHAR(SYSDATE, 'MMDD'), '9999') >= TO_NUMBER(TO_CHAR(p_nacimiento, 'MMDD'), '9999') THEN
    v_edad := v_edad + 1;
  END IF;  
  RETURN v_edad;
END fn_calcular_edad;

/

CREATE OR REPLACE FUNCTION fn_puntaje_edad(p_edad NUMERIC) RETURN NUMERIC IS
  v_puntaje NUMERIC(10);
BEGIN
  IF p_edad < 30 THEN
    v_puntaje := 200;
  ELSIF p_edad <= 40 THEN
    v_puntaje := 150;
  ELSE
    v_puntaje := 100;
  END IF;
  RETURN v_puntaje;

END fn_puntaje_edad;

/






--trigger
CREATE OR REPLACE TRIGGER trg_resultado_asig
BEFORE INSERT ON POSTULANTE_PUNTAJE
FOR EACH ROW
BEGIN
    :NEW.PUNTAJE_TOTAL:=
      :NEW.PUNTAJE_EDAD+
      :NEW.PUNTAJE_CARGAS_FAMILIARES+
      :NEW.PUNTAJE_ESTADO_CIVIL+
      :NEW.PUNTAJE_PUEBLO_IND_ORIG+
      :NEW.PUNTAJE_MONTO_AHORRO+
      :NEW.PUNTAJE_TITULO;
      
    :NEW.PUNTAJE_TOTAL := :NEW.PUNTAJE_TOTAL * (1+fn_obtener_region_porcentaje(:NEW.RUN_POSTULANTE));
END;

/

--procedimiento principal 
CREATE OR REPLACE PROCEDURE SP_ASIGNAR_PUNTAJES
IS
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE SUBSIDIO.POSTULANTE_PUNTAJE';
  FOR REG_POSTULANTE IN (SELECT * FROM POSTULANTE) LOOP
    -------------------------------------------------------------------------------Minimos
    --revisando monto minimo ahorrado (8.000.000)
    SELECT MONTO_AHORRADO INTO pkg_postulante.v_cantidad_ahorro FROM AHORRO
    WHERE NRO_FOLIO_A = REG_POSTULANTE.NRO_FOLIO_A;
      IF pkg_postulante.v_cantidad_ahorro < 8000000 THEN CONTINUE;
    END IF;
    --asignacion casa
    SELECT COUNT(NRO_FOLIO_D) INTO pkg_postulante.v_cantidad_viv_elegida FROM VIVIENDA_ELEGIDA
    WHERE NRO_FOLIO_A = REG_POSTULANTE.NRO_FOLIO_A;
      IF pkg_postulante.v_cantidad_viv_elegida < 1 THEN CONTINUE;
    END IF;
    -------------------------------------------------------------------------------Preparativos
    --conseguir folios
    SELECT NRO_FOLIO_D INTO pkg_postulante.v_id_folio_d FROM VIVIENDA_ELEGIDA
    WHERE NRO_FOLIO_A = REG_POSTULANTE.NRO_FOLIO_A;
    pkg_postulante.v_id_folio_a:=REG_POSTULANTE.NRO_FOLIO_A;
    
    -------------------------------------------------------------------------------Puntajes
    --calcular edad
    SELECT fn_calcular_edad(FECHA_NACIMIENTO) INTO pkg_postulante.v_edad FROM POSTULANTE
    WHERE NRO_FOLIO_A = REG_POSTULANTE.NRO_FOLIO_A;
    pkg_postulante.v_puntaje_edad := fn_puntaje_edad(pkg_postulante.v_edad);
    
    --cargas familiares
    pkg_postulante.v_cant_cargas_fam := pkg_postulante.fn_total_cargas_familiares(reg_postulante.run_postulante);
    pkg_postulante.v_puntaje_cargas_fam := fn_obtener_puntaje_cargas_fam(reg_postulante.run_postulante);
    
    --estado civil
    SELECT puntaje
    INTO pkg_postulante.v_puntaje_estado_civil
    FROM ESTADO_CIVIL
    WHERE ID_ESTADO_CIVIL = REG_POSTULANTE.ID_ESTADO_CIVIL;
    pkg_postulante.v_nombre_estado_civil := pkg_postulante.fn_descripcion_estado_civil(REG_POSTULANTE.RUN_POSTULANTE);
    
    --pueblo originario
    SELECT NVL(ACREDITA_PUEBLO_IND_ORIG,0) INTO pkg_postulante.v_pueblo_orig FROM ACREDITACIONES
    WHERE NRO_FOLIO_A = REG_POSTULANTE.NRO_FOLIO_A;
    IF pkg_postulante.v_pueblo_orig != 1 THEN 
      pkg_postulante.v_puntaje_pueblo_orig := 500;
      pkg_postulante.v_nombre_pueblo_orig := 'SI';
    ELSE
      pkg_postulante.v_puntaje_pueblo_orig := 0;
      pkg_postulante.v_nombre_pueblo_orig := 'NO';
    END IF;
    
    --monto ahorro
    SELECT monto_ahorrado INTO pkg_postulante.v_monto_ahorro
    FROM AHORRO WHERE NRO_FOLIO_A = pkg_postulante.v_id_folio_a;
    pkg_postulante.v_puntaje_monto_ahorro := fn_obtener_puntaje_ahorro(REG_POSTULANTE.RUN_POSTULANTE);
    
    --puntaje titulo
    SELECT TITULO_POSEE
    INTO pkg_postulante.v_posee_titulo 
    FROM ACREDITACIONES
    WHERE NRO_FOLIO_A = REG_POSTULANTE.NRO_FOLIO_A;
    
    IF pkg_postulante.v_posee_titulo = 1 THEN
      SELECT A.TITULO, B.PUNTAJE
      INTO pkg_postulante.v_nombre_titulo,  pkg_postulante.v_puntaje_titulo
      FROM TITULO A JOIN TIPO_TITULO B ON (A.ID_TIPO_TITULO = B.ID_TIPO_TITULO)
      WHERE NRO_FOLIO_A = REG_POSTULANTE.NRO_FOLIO_A AND ROWNUM = 1;
    ELSE
      pkg_postulante.v_nombre_titulo := 'NO POSEE';  
      pkg_postulante.v_puntaje_titulo:= 0; 
    END IF;
    
    -------------------------------------------------------------------------------Asignar
    INSERT INTO POSTULANTE_PUNTAJE VALUES(
      REG_POSTULANTE.RUN_POSTULANTE,
      pkg_postulante.v_edad,
      pkg_postulante.v_puntaje_edad,
      pkg_postulante.v_cant_cargas_fam,
      pkg_postulante.v_puntaje_cargas_fam,
      pkg_postulante.v_nombre_estado_civil,
      pkg_postulante.v_puntaje_estado_civil,
      pkg_postulante.v_nombre_pueblo_orig,
      pkg_postulante.v_puntaje_pueblo_orig,
      pkg_postulante.v_monto_ahorro,
      pkg_postulante.v_puntaje_monto_ahorro,
      pkg_postulante.v_nombre_titulo,
      pkg_postulante.v_puntaje_titulo,
      0
    );
    
  END LOOP;

  EXCEPTION
    WHEN TOO_MANY_ROWS THEN 
    INSERT INTO ERRORES_PROC_ASIG_PUNTAJE VALUES (SEQ_ERRORES_PROC_ASIG_PUNTAJE.NEXTVAL,'Procedimiento principal','Existen muchos valores');
    WHEN NO_DATA_FOUND THEN
    INSERT INTO ERRORES_PROC_ASIG_PUNTAJE VALUES (SEQ_ERRORES_PROC_ASIG_PUNTAJE.NEXTVAL,'Procedimiento principal','No se encontraron datos');
    WHEN OTHERS THEN
    INSERT INTO ERRORES_PROC_ASIG_PUNTAJE VALUES (SEQ_ERRORES_PROC_ASIG_PUNTAJE.NEXTVAL,'Procedimiento principal','Error desconocido');
END SP_ASIGNAR_PUNTAJES;

/

COMMIT;