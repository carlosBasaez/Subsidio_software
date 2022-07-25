using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.DataAccess.Client;

namespace Biblioteca
{
    public class asignacion_puntaje
    {
        public static int Sacar_puntaje()
        {
            int ap = -2;
            using (OracleConnection ora = new OracleConnection(Conexion.connection))
            {
                try
                {
                    ora.Open();
                    OracleCommand command = new OracleCommand("sp_asignar_puntajes", ora);
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    ap = command.ExecuteNonQuery();


                }
                catch(Exception ex)
                {
                    Console.WriteLine("---------------------------------- ERROR\n" + ex.Message + "\n----------------------------------");
                    ap = -3;
                }
            }
            return ap;
        }
    }
}
