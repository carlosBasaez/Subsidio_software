using Oracle.DataAccess.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Biblioteca
{
    public class Anexo_e
    {
        public int rut_postulante;
        public string fecha_postulacion;
        public string receptor_postulacion;
        public string nombre_completo;
        public string fecha_nacimiento;
        public string nacionalidad;
        public string estado_civil;
        public int total_cargas_familiares;
        public int pueblo_ind_orig;
        public string titulo;
        public int run_conyuge;
        public string nombre_completo_conyuge;
        public string calle;
        public int numero;
        public int block;
        public string departamento;
        public string manzana;
        public string sitio;
        public string region;
        public string comuna;
        public int telefono_trabajo;
        public int telefono_domicilio;
        public int celular;
        public int codigo_postal;
        public string email;
        public string titulo_postula;
        public string region_subsidio;
        public string comuna_subsidio;
        public string tipo_vivienda;
        public string valor_propiedad;
        public string monto_ahorrado;
        public int puntaje_minimo;
        public int puntaje_obtenido;

        public static Anexo_e Buscar(int rut)
        {
            Anexo_e ane = null;
            using (OracleConnection ora = new OracleConnection(Conexion.connection))
            {
                try
                {
                    ora.Open();
                    OracleCommand command = new OracleCommand(
                        @"SELECT
                    TO_CHAR(A.FECHA_RECEPCION,'DD/MM/YYYY'),
                    A.NOMBRE_RECEPTOR,
                    P.NOMBRES||' '|| P.PRIMER_APELLIDO||' '||P.SEGUNDO_APELLIDO AS NOMBRES,
                    TO_CHAR(P.FECHA_NACIMIENTO,'DD/MM/YYYY'),
                    N.NACIONALIDAD,
                    E.ESTADO_CIVIL,
                    pkg_postulante.fn_total_cargas_familiares(P.RUN_POSTULANTE) AS TOTAL_CARGAS,
                    NVL(Z.PERTENECE_PUEBLO_IND_ORIG,0) AS PERTENECE_PUEBLO,
                    NVL(T.TITULO,'NO POSEE') AS TITULO,
                    NVL(C.RUN_CONVIVIENTE,0) AS RUN_CONYUGE,
                    C.NOMBRES||' '||C.PRIMER_APELLIDO||' '||C.SEGUNDO_APELLIDO AS NOMBRE_CONYUGE,
                    D.CALLE,
                    D.NUMERO,
                    NVL(D.BLOCK,0) AS BLOCK,
                    NVL(D.DEPTO,'NO POSEE')AS DEPTO,
                    D.MANZANA,
                    NVL(D.SITIO,'NO POSEE') AS SITIO,
                    X.COMUNA,
                    R.REGION,
                    NVL(Y.FONO_TRABAJO,0) AS FONO_TRABAJO,
                    NVL(Y.FONO_DOMICILIO,0) AS FONO_DOMICILIO,
                    Y.FONO_MOVIL,
                    NVL(Y.CODIGO_POSTAL,0) AS CODIGO_POSTAL,
                    Y.EMAIL,
                    U.ID_TITULO_POSTULACION,
                    CO.COMUNA AS COMUNA_SUBSIDIO,
                    RE.REGION AS REGION_SUBSIDIO,
                    TI.NOMBRE_TIPO_VIVIENDA TIPO_VIVIENDA,
                    to_char(U.VALOR_VIVIENDA,'$9g999g999g999') as VALOR_VIVIENDA,
                    to_char(MO.MONTO_AHORRADO,'$9g999g999g999') AS MONTO_AHORRADO,
                    FLOOR(NVL((SELECT AVG(PPSQ.PUNTAJE_TOTAL) FROM POSTULANTE_PUNTAJE PPSQ),0)) AS PUNTAJE_MINIMO,
                    NVL(PU.PUNTAJE_TOTAL,0)
                    FROM POSTULANTE P JOIN ANEXO_A A
                    ON (P.NRO_FOLIO_A = A.NRO_FOLIO_A)
                    JOIN NACIONALIDAD N
                    ON (P.ID_NACIONALIDAD = N.ID_NACIONALIDAD)
                    JOIN ESTADO_CIVIL E
                    ON (P.ID_ESTADO_CIVIL = E.ID_ESTADO_CIVIL)
                    JOIN ACREDITACIONES Z
                    ON(Z.NRO_FOLIO_A = P.NRO_FOLIO_A)
                    LEFT JOIN TITULO T
                    ON (T.NRO_FOLIO_A = Z.NRO_FOLIO_A)
                    LEFT JOIN CONVIVIENTE_CIVIL C
                    ON (C.NRO_FOLIO_A = P.NRO_FOLIO_A)
                    LEFT JOIN DOMICILIO D
                    ON (D.NRO_FOLIO_A = P.NRO_FOLIO_A)
                    JOIN COMUNA X
                    ON(X.ID_COMUNA = D.ID_COMUNA)
                    JOIN REGION R 
                    ON(R.ID_REGION = X.ID_REGION)
                    LEFT JOIN CONTACTO Y
                    ON(Y.NRO_FOLIO_A = P.NRO_FOLIO_A)
                    JOIN UBICACION_PREFERENCIA U
                    ON (U.NRO_FOLIO_A = P.NRO_FOLIO_A)
                    JOIN COMUNA CO
                    ON(U.ID_COMUNA = CO.ID_COMUNA)
                    JOIN REGION RE
                    ON(CO.ID_REGION = RE.ID_REGION)
                    JOIN ANEXO_D DE
                    ON(DE.NRO_FOLIO_A = A.NRO_FOLIO_A)
                    JOIN antecedentes_constr_viv ACV
                    ON(ACV.NRO_FOLIO_D = DE.NRO_FOLIO_D)
                    LEFT JOIN TIPO_VIVIENDA TI
                    ON(ACV.ID_TIPO_VIVIENDA = TI.ID_TIPO_VIVIENDA)
                    JOIN AHORRO MO
                    ON(MO.NRO_FOLIO_A = P.NRO_FOLIO_A)
                    LEFT JOIN POSTULANTE_PUNTAJE PU
                    ON(P.RUN_POSTULANTE = PU.RUN_POSTULANTE)
                    WHERE P.RUN_POSTULANTE = :RUT", ora);
                    command.Parameters.Add(":RUT", OracleDbType.Int32).Value = rut;
                    OracleDataReader lector = command.ExecuteReader();
                    if (lector.HasRows)
                    {
                        ane = new Anexo_e();
                        ane.rut_postulante = rut;
                        ane.fecha_postulacion = lector.GetString(0);
                        ane.receptor_postulacion = lector.GetString(1);
                        ane.nombre_completo = lector.GetString(2);
                        ane.fecha_nacimiento = lector.GetString(3);
                        ane.nacionalidad = lector.GetString(4);
                        ane.estado_civil = lector.GetString(5);
                        ane.total_cargas_familiares = Util.GetInt(lector[6]);
                        ane.pueblo_ind_orig = Util.GetInt(lector[7]);
                        ane.titulo = lector.GetString(8);
                        ane.run_conyuge = Util.GetInt(lector[9]);
                        ane.nombre_completo_conyuge = lector.GetString(10);
                        ane.calle = lector.GetString(11);
                        ane.numero = Util.GetInt(lector[12]);
                        ane.block = Util.GetInt(lector[13]);
                        ane.departamento = lector.GetString(14);
                        ane.manzana = lector.GetString(15);
                        ane.sitio = lector.GetString(16);
                        ane.comuna = lector.GetString(17);
                        ane.region = lector.GetString(18);
                        ane.telefono_trabajo = Util.GetInt(lector[19]);
                        ane.telefono_domicilio = Util.GetInt(lector[20]);
                        ane.celular = Util.GetInt(lector[21]);
                        ane.codigo_postal = Util.GetInt(lector[22]);
                        ane.email = lector.GetString(23);
                        ane.titulo_postula = lector.GetString(24);
                        ane.comuna_subsidio = lector.GetString(25);
                        ane.region_subsidio = lector.GetString(26);
                        ane.tipo_vivienda = lector.GetString(27);
                        ane.valor_propiedad = lector.GetString(28);
                        ane.monto_ahorrado = lector.GetString(29);
                        ane.puntaje_minimo = Util.GetInt(lector[30]);
                        ane.puntaje_obtenido = Util.GetInt(lector[31]);

                    }
                }
                catch(Exception ex)
                {
                    Console.WriteLine("--------------- ERROR\n" + ex.Message);
                    ane = null;
                }
                ora.Close();
            }
            return ane;
        }
    }
}