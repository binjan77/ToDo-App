#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
ENV ASPNETCORE_URLS="http://*:5000"

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ToDo-App.csproj", "."]
RUN dotnet restore "./ToDo-App.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ToDo-App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ToDo-App.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ToDo-App.dll"]