CREATE OR REPLACE VIEW view_postulante_beneficiado AS
SELECT 
  pos.run_postulante AS RUN_POSTULANTE,
  pos.nombres
  || ' '
  || pos.primer_apellido
  || ' '
  || pos.segundo_apellido      AS NOMBRE_POSTULANTE,
  pp.edad                      AS EDAD,
  pp.puntaje_edad              AS PUNTAJE_EDAD,
  pp.cargas_familiares         AS CARGAS_FAMILIARES,
  pp.puntaje_cargas_familiares AS PUNTAJE_CARGAS_FAMILIARES,
  pp.estado_civil              AS ESTADO_CIVIL,
  pp.puntaje_estado_civil      AS PUNTAJE_ESTADO_CIVIL,
  pp.pueblo_ind_orig           AS PUEBLO_IND_ORIG,
  pp.puntaje_pueblo_ind_orig   AS PUNTAJE_PUEBLO_IND_ORIG,
  pp.monto_ahorro              AS MONTO_AHORRO,
  pp.puntaje_monto_ahorro      AS PUNTAJE_MONTO_AHORRO,
  pp.titulo                    AS TITULO,
  pp.puntaje_titulo            AS PUNTAJE_TITULO,
  CASE
    WHEN reg.porcentaje_puntaje IS NULL OR reg.porcentaje_puntaje = 0
    THEN 'No'
    ELSE reg.region
  END AS ZONA_EXTREMA,
  CASE
    WHEN reg.porcentaje_puntaje IS NULL OR reg.porcentaje_puntaje = 0
    THEN 0
    ELSE reg.porcentaje_puntaje * (pp.puntaje_edad + pp.puntaje_cargas_familiares + puntaje_estado_civil + puntaje_pueblo_ind_orig + puntaje_monto_ahorro + puntaje_titulo)
  END                              AS PUNTAJE_ZONA_EXTREMA,
  pp.puntaje_total                 AS PUNTAJE_TOTAL,
  tv.nombre_tipo_vivienda          AS TIPO_VIVIENDA_SUBSIDIADA,
  up.valor_vivienda                AS VALOR_VIVIENDA,
  up.valor_vivienda - monto_ahorro AS MONTO_SUBSIDIO
FROM Postulante pos
INNER JOIN postulante_puntaje pp
ON (pp.run_postulante = pos.run_postulante)
INNER JOIN vivienda_elegida ve
ON (pos.nro_folio_A = ve.nro_folio_A)
INNER JOIN caracteristica_vivienda cv
ON (ve.nro_folio_D = cv.nro_folio_D)
INNER JOIN comuna com
ON (com.id_comuna = cv.id_comuna)
INNER JOIN region reg
ON (com.id_region = reg.id_region)
INNER JOIN antecedentes_constr_viv acv
ON (acv.nro_folio_D = ve.nro_folio_D)
INNER JOIN tipo_vivienda tv
ON (tv.id_tipo_vivienda = acv.id_tipo_vivienda)
INNER JOIN ubicacion_preferencia up
ON (ve.nro_folio_A = up.nro_folio_A)
WHERE PUNTAJE_TOTAL > (
  SELECT
  AVG(PUNTAJE_TOTAL)
  FROM postulante_puntaje
  )
  
  
WITH READ ONLY;


/

COMMIT;




