FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["TuNhanTamTInh_Ecommerce.csproj", "./"]
RUN dotnet restore "./TuNhanTamTInh_Ecommerce.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "./TuNhanTamTInh_Ecommerce.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./TuNhanTamTInh_Ecommerce.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TuNhanTamTInh_Ecommerce.dll"]
