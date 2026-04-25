namespace Project.Core.Application.Abstractions.Data;

public sealed record ItemPageReadModel(
    Guid Id,
    string Name,
    string Category,
    decimal Price,
    DateOnly ReleaseDate,
    string LastUpdatedBy);

public interface IItemReadRepository
{
    Task<List<ItemPageReadModel>> GetPageAsync(
        int pageNumber,
        int pageSize,
        string? name,
        CancellationToken cancellationToken = default);

    Task<int> CountAsync(string? name, CancellationToken cancellationToken = default);
}