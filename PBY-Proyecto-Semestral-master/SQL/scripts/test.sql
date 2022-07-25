select * from view_postulante_beneficiado;
select * from ERRORES_PROC_ASIG_PUNTAJE;
select * from postulante;
EXEC DBMS_OUTPUT.PUT_LINE(pkg_postulante.fn_total_cargas_familiares('20456987'));
EXEC DBMS_OUTPUT.PUT_LINE(pkg_postulante.fn_descripcion_estado_civil('20456987'));
EXEC DBMS_OUTPUT.PUT_LINE(obtener_puntaje_cargas_fam('20456987'));
EXEC DBMS_OUTPUT.PUT_LINE(fn_obtener_puntaje_ahorro('20456987'));

SELECT nro_folio_A FROM postulante WHERE run_postulante = '20456987';
    SELECT COUNT(run_carga) INTO v_cant_cargas FROM carga_familiar WHERE nro_folio_A = v_nro_folio_A;
    
    
select * from postulante_puntaje;
select * from view_postulante_beneficiado;
exec SP_ASIGNAR_PUNTAJES;
delete from postulante_puntaje;
drop trigger trg_resultado_asig;

commit;