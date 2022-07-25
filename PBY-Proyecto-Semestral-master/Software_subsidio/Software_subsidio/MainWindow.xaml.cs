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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Software_subsidio
{
    /// <summary>
    /// Lógica de interacción para MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            this.WindowStartupLocation = WindowStartupLocation.CenterScreen;
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Mostrar_anexo_e mos_E = new Mostrar_anexo_e();
            mos_E.Show();
            this.Close();
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            if(Biblioteca.asignacion_puntaje.Sacar_puntaje() >= -1 )
            {
                MessageBox.Show("correcta asignacion de puntaje");
            }
            else
            {
                MessageBox.Show("no se pudo asginar el puntaje");
            }
        }
    }
}
