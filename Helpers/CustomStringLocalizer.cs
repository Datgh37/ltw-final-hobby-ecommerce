using Microsoft.Extensions.Localization;
using System;
using System.Collections.Generic;
using System.Linq;

namespace TuNhanTamTInh_Ecommerce.Helpers
{
    public class CustomStringLocalizer : IStringLocalizer
    {
        public LocalizedString this[string name]
        {
            get
            {
                var parts = name.Split('|');
                if (parts.Length == 2)
                {
                    return new LocalizedString(name, Loc.T(parts[0].Trim(), parts[1].Trim()));
                }
                return new LocalizedString(name, name);
            }
        }

        public LocalizedString this[string name, params object[] arguments]
        {
            get
            {
                var str = this[name].Value;
                return new LocalizedString(name, string.Format(str, arguments));
            }
        }

        public IEnumerable<LocalizedString> GetAllStrings(bool includeParentCultures)
        {
            return Enumerable.Empty<LocalizedString>();
        }
    }

    public class CustomStringLocalizerFactory : IStringLocalizerFactory
    {
        public IStringLocalizer Create(Type resourceSource) => new CustomStringLocalizer();
        public IStringLocalizer Create(string baseName, string location) => new CustomStringLocalizer();
    }
}
