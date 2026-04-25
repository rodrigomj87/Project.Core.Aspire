using Project.Core.Application.Abstractions.Data;
using Project.Core.Infrastructure.Database;
using Microsoft.EntityFrameworkCore;

namespace Project.Core.Infrastructure.Repository;

public sealed class ItemReadRepository(ProjectCoreContext context) : IItemReadRepository
{
    public async Task<List<ItemPageReadModel>> GetPageAsync(
        int pageNumber,
        int pageSize,
        string? name,
        CancellationToken cancellationToken = default)
    {
        var skipCount = (pageNumber - 1) * pageSize;

        var filteredItems = context.Items
            .Where(item => string.IsNullOrWhiteSpace(name)
                || EF.Functions.Like(item.Name, $"%{name}%"));

        return await filteredItems
            .OrderBy(item => item.Name)
            .Skip(skipCount)
            .Take(pageSize)
            .Include(item => item.Category)
            .Select(item => new ItemPageReadModel(
                item.Id,
                item.Name,
                item.Category != null ? item.Category.Name : string.Empty,
                item.Price,
                item.ReleaseDate,
                item.LastUpdatedBy))
            .AsNoTracking()
            .ToListAsync(cancellationToken);
    }

    public Task<int> CountAsync(string? name, CancellationToken cancellationToken = default)
    {
        return context.Items
            .Where(item => string.IsNullOrWhiteSpace(name)
                || EF.Functions.Like(item.Name, $"%{name}%"))
            .CountAsync(cancellationToken);
    }
}