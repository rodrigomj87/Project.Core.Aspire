using Project.Core.Infrastructure.Database.Configurations;
using Project.Core.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Project.Core.Infrastructure.Database;

public class ProjectCoreContext(DbContextOptions<ProjectCoreContext> options)
    : DbContext(options)
{
    public DbSet<Item> Items => Set<Item>();

    public DbSet<Category> Categories => Set<Category>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ItemEntityConfiguration).Assembly);
    }
}