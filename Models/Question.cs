using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Question
{
    public int QuestionId { get; set; }

    public int TopicId { get; set; }

    public string QuestionText { get; set; } = null!;

    public string? AnswerText { get; set; }

    public string? AccountId { get; set; }

    public DateTime PostedDate { get; set; }

    public virtual Account? Account { get; set; }

    public virtual Topic Topic { get; set; } = null!;
}
