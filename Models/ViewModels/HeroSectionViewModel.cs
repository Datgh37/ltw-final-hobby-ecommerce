namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class HeroSectionViewModel
    {
        public List<Category> Categories { get; set; } = new List<Category>();
        public List<Series> Series { get; set; } = new List<Series>();
        
        // Dictionary mapping CategoryId to a list of Series associated with it
        public Dictionary<int, List<Series>> CategorySeriesMap { get; set; } = new Dictionary<int, List<Series>>();
    }
}
