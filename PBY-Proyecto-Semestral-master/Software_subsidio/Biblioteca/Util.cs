using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace Biblioteca
{
    public class Util
    {
        public static int GetInt(object obj)
        {
            if (int.TryParse(obj.ToString(), out int valor))
            {
                return valor;
            }
            return -1;

        }
        public static string Getstring (object obj)
        {
            return (string)obj;
        }
        public static int TextBoxToInt(TextBox tb)
        {
            int value = -1;
            string text = tb.Text;
            text = text.Replace(".", "");
            text = text.Replace(",", "");
            text = text.Split('-')[0];
            if (text != "")
            {
                if (int.TryParse(tb.Text, out value))
                {
                    return value;
                }
                else
                {
                    value = -1;
                    tb.Text = tb.Text.Remove(tb.Text.Length - 1);
                }
            }

            return value;
        }
    }
}
