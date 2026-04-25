using Project.Core.Application.Abstractions.Data;
using Project.Core.Infrastructure.Database;
using Project.Core.Infrastructure.Repository;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Project.Core.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services)
    {
        services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
        services.AddScoped<IUnitOfWork, UnitOfWork>();
        services.AddScoped<IItemReadRepository, ItemReadRepository>();

        return services;
    }

    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var connectionString =
            configuration.GetConnectionString("ProjectCoreDB") ??
            configuration.GetConnectionString("connection") ??
            throw new InvalidOperationException("Connection string 'ProjectCoreDB' was not found.");

        services.AddDbContext<ProjectCoreContext>(options =>
        {
            options.UseNpgsql(connectionString);
        });

        return services.AddInfrastructure();
    }
}