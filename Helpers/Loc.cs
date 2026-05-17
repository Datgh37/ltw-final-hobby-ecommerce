using System.Threading;

namespace TuNhanTamTInh_Ecommerce.Helpers
{
    public static class Loc
    {
        public static string T(string vi, string en)
        {
            var culture = Thread.CurrentThread.CurrentUICulture.Name;
            return culture == "en-US" ? en : vi;
        }
    }
}
