using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Role
{
    public int RoleId { get; set; }

    private string? _roleName;
    public string RoleName
    {
        get
        {
            var isEnglish = System.Threading.Thread.CurrentThread.CurrentUICulture.Name == "en-US";
            if (isEnglish && !string.IsNullOrEmpty(RoleNameEn))
            {
                return RoleNameEn;
            }
            return _roleName ?? "";
        }
        set => _roleName = value;
    }

    public string? RoleNameEn { get; set; }

    public virtual ICollection<Account> Accounts { get; set; } = new List<Account>();
}
