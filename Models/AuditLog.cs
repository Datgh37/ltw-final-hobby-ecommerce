using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class AuditLog
{
    public int LogId { get; set; }

    public string? AccountId { get; set; }

    public string Action { get; set; } = null!;

    public DateTime Timestamp { get; set; }

    public string? Message { get; set; }

    public virtual Account? Account { get; set; }
}
