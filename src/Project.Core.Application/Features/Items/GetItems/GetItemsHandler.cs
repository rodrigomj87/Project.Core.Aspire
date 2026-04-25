using Project.Core.Application.Abstractions;
using Project.Core.Application.Abstractions.Data;
using Project.Core.Domain.Abstractions;

namespace Project.Core.Application.Features.Items.GetItems;

public sealed record GetItemsRequest(
    int PageNumber = 1,
    int PageSize = 5,
    string? Name = null);

public sealed record ItemsPageDto(int TotalPages, IEnumerable<ItemSummaryDto> Data);

public sealed record ItemSummaryDto(
    Guid Id,
    string Name,
    string Category,
    decimal Price,
    DateOnly ReleaseDate,
    string LastUpdatedBy);

public sealed class GetItemsHandler(IItemReadRepository itemReadRepository)
    : IHandler<GetItemsRequest, Result<ItemsPageDto>>
{
    public async Task<Result<ItemsPageDto>> HandleAsync(GetItemsRequest command, CancellationToken cancellationToken)
    {
        var totalItems = await itemReadRepository.CountAsync(command.Name, cancellationToken);
        var totalPages = (int)Math.Ceiling(totalItems / (double)command.PageSize);
        var itemsOnPage = await itemReadRepository.GetPageAsync(
            command.PageNumber,
            command.PageSize,
            command.Name,
            cancellationToken);

        var mapped = itemsOnPage
            .Select(item => new ItemSummaryDto(
                item.Id,
                item.Name,
                item.Category,
                item.Price,
                item.ReleaseDate,
                item.LastUpdatedBy))
            .ToList();

        return Result.Success(new ItemsPageDto(totalPages, mapped));
    }
}