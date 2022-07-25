using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;


namespace Software_subsidio
{
    /// <summary>
    /// Lógica de interacción para Mostrar_anexo_e.xaml
    /// </summary>
    public partial class Mostrar_anexo_e : Window
    {
        public Mostrar_anexo_e()
        {
            this.WindowStartupLocation = WindowStartupLocation.CenterScreen;
            InitializeComponent();
        }

        private void Txt_rut_TextChanged(object sender, TextChangedEventArgs e)
        {
            Biblioteca.Util.TextBoxToInt(txt_rut);
        }
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            int rut = 
            Biblioteca.Util.TextBoxToInt(txt_rut);
            Biblioteca.Anexo_e ae = Biblioteca.Anexo_e.Buscar(rut);
            if(ae == null)
            {
                Console.WriteLine("Es nullo");
                date_fecha.Clear();
                txt_receptor.Clear();
                txt_run_postulante.Clear();
                nombre_completo.Clear();
                fecha_nac.Clear();
                nacionalidad_txt.Clear();
                estado_civil_txt.Clear();
                carga_familiar_txt.Clear();
                pueblo_txt.Clear();
                titulo_txt.Clear();
                run_conyuge_txt.Clear();
                nombre_conyuge_txt.Clear();
                calle_txt.Clear();
                numero_txt.Clear();
                block_txt.Clear();
                depto_txt.Clear();
                manzana_txt.Clear();
                sitio_txt.Clear();
                region_txt.Clear();
                comuna_txt.Clear();
                telefono_trabajo.Clear();
                telefono_domicilio.Clear();
                telefono_movil.Clear();
                codigo_postal.Clear();
                email.Clear();
                titulo_postula.Clear();
                region_subsidio.Clear();
                comuna_subsidio.Clear();
                tipo_vivienda.Clear();
                valor_propiedad.Clear();
                monto_ahorrado.Clear();
                puntaje_min.Clear();
                puntaje_obt.Clear();
                ImagePerfil.Source = null;
                return;
            }
            Console.WriteLine("NO es nullo");
            date_fecha.Text = ae.fecha_postulacion;
            txt_receptor.Text = ae.receptor_postulacion;
            txt_run_postulante.Text = ae.rut_postulante.ToString();
            nombre_completo.Text = ae.nombre_completo;
            fecha_nac.Text = ae.fecha_nacimiento;
            nacionalidad_txt.Text = ae.nacionalidad;
            estado_civil_txt.Text = ae.estado_civil;
            carga_familiar_txt.Text = ae.total_cargas_familiares.ToString();
            if(ae.pueblo_ind_orig > 0)
            {
                pueblo_txt.Text = "Si";
            }
            else
            {
                pueblo_txt.Text = "No";
            }
            titulo_txt.Text = ae.titulo;
            run_conyuge_txt.Text = ae.run_conyuge.ToString();
            nombre_conyuge_txt.Text = ae.nombre_completo_conyuge;
            calle_txt.Text = ae.calle;
            numero_txt.Text = ae.numero.ToString();
            block_txt.Text = ae.block.ToString();
            depto_txt.Text = ae.departamento;
            manzana_txt.Text = ae.manzana;
            sitio_txt.Text = ae.sitio;
            region_txt.Text = ae.region;
            comuna_txt.Text = ae.comuna;
            if(ae.telefono_trabajo != 0)
            {
                telefono_trabajo.Text = ae.telefono_trabajo.ToString();
            }
            else
            {
                telefono_trabajo.Clear();
            }
            if (ae.telefono_domicilio != 0)
            {
                telefono_domicilio.Text = ae.telefono_domicilio.ToString();
            }
            else
            {
                telefono_domicilio.Clear();
            }
            if(ae.celular != -1)
            {
                telefono_movil.Text = ae.celular.ToString();
            }
            else
            {
                telefono_movil.Clear();
            }
            if(ae.codigo_postal != 0)
            {
                codigo_postal.Text = ae.codigo_postal.ToString();
            }
            else
            {
                codigo_postal.Clear();
            }
            email.Text = ae.email;
            titulo_postula.Text = ae.titulo_postula;
            region_subsidio.Text = ae.region_subsidio;
            comuna_subsidio.Text = ae.comuna_subsidio;
            tipo_vivienda.Text = ae.tipo_vivienda;
            valor_propiedad.Text = ae.valor_propiedad.ToString();
            monto_ahorrado.Text = ae.monto_ahorrado.ToString();
            puntaje_min.Text = ae.puntaje_minimo.ToString();
            puntaje_obt.Text = ae.puntaje_obtenido.ToString();


            try
            {
                ImagePerfil.Source = new BitmapImage(
                    new Uri($"fotos/{rut}.jpg", UriKind.Relative));
            }
            catch
            {
                ImagePerfil.Source = null;
            }
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            MainWindow ini = new MainWindow();
            ini.Show();
            this.Close();
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            date_fecha.Clear();
            txt_receptor.Clear();
            txt_run_postulante.Clear();
            nombre_completo.Clear();
            fecha_nac.Clear();
            nacionalidad_txt.Clear();
            estado_civil_txt.Clear();
            carga_familiar_txt.Clear();
            pueblo_txt.Clear();
            titulo_txt.Clear();
            run_conyuge_txt.Clear();
            nombre_conyuge_txt.Clear();
            calle_txt.Clear();
            numero_txt.Clear();
            block_txt.Clear();
            depto_txt.Clear();
            manzana_txt.Clear();
            sitio_txt.Clear();
            region_txt.Clear();
            comuna_txt.Clear();
            telefono_trabajo.Clear();
            telefono_domicilio.Clear();
            telefono_movil.Clear();
            codigo_postal.Clear();
            email.Clear();
            titulo_postula.Clear();
            region_subsidio.Clear();
            comuna_subsidio.Clear();
            tipo_vivienda.Clear();
            valor_propiedad.Clear();
            monto_ahorrado.Clear();
            puntaje_min.Clear();
            puntaje_obt.Clear();
            ImagePerfil.Source = null;
        }
    }
}
