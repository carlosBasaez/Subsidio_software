using Oracle.DataAccess.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Biblioteca
{
    public class Postulante
    {
        public int nro_folio_a;
        public string Rut;
        public string primer_apellido;
        public string segundo_apellido;
        public string nombres;
        public DateTime fecha_nacimiento;
        public int total_cargas;
        public string nacionalidad;
        public string estado_civil;
        public Boolean pueblo_origi;
        public string titulo;


        public static Postulante Prueba(string email, string pass)
        {
            Postulante postulante = null;
            
            using (OracleConnection ora = new OracleConnection(Conexion.connection))
            {
                try
                {
                    ora.Open();
                    OracleCommand command = new OracleCommand("SELECT RUT FROM USUARIO WHERE EMAIL=:EMAIL AND PASS=:PASS", ora);
                    command.Parameters.Add(":EMAIL", OracleDbType.Varchar2).Value = email;
                    command.Parameters.Add(":PASS", OracleDbType.Varchar2).Value = pass;
                    OracleDataReader lector = command.ExecuteReader();
                    if (lector.Read())
                    {
                        postulante = new Postulante();
                        postulante.Rut = lector.GetString(0);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(">>>>>>>" + ex);
                }
                ora.Close();
            }
            return postulante;
        }

        public static Postulante Buscar(int Rut)
        {
            Postulante post = null;
            using (OracleConnection ora = new OracleConnection(Conexion.connection))
            {
                try
                {
                    ora.Open();
                    OracleCommand command = new OracleCommand("SELECT * FROM POSTULANTE WHERE RUN_POSTULANTE =:RUT", ora);
                    command.Parameters.Add(":RUT", OracleDbType.Int32).Value = Rut;
                    OracleDataReader lector = command.ExecuteReader();
                    if (lector.Read())
                    {

                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex);
                }
                ora.Close();
            }
            return post;
        }
    }
}
