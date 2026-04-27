using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class WebPage
{
    public int PageId { get; set; }

    public string PageName { get; set; } = null!;

    public string Url { get; set; } = null!;

    public string? Content { get; set; }
}
