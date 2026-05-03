using AutoMapper;
using TuNhanTamTInh_Ecommerce.DTOs;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Helpers
{
    public class AutoMapperProfile : Profile
    {
        public AutoMapperProfile()
        {
            CreateMap<Product, ProductUpdateInfoDTO>().ReverseMap();
            CreateMap<Product, ProductCardViewModel>();
        }
    }
}
