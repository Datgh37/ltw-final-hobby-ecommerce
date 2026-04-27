using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Cart
{
    public string CartId { get; set; } = null!;

    public string? AccountId { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual Account? Account { get; set; }

    public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();
}
