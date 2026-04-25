using Project.Core.Application.Abstractions;
using Project.Core.Application.Abstractions.Data;
using Project.Core.Domain.Abstractions;
using Project.Core.Domain.Abstractions.Errors;
using Project.Core.Domain.Entities;

namespace Project.Core.Application.Features.Items.GetItem;

public sealed record GetItemRequest(Guid Id);

public sealed record ItemDetailsDto(
    Guid Id,
    string Name,
    Guid CategoryId,
    decimal Price,
    DateOnly ReleaseDate,
    string Description,
    string LastUpdatedBy);

public sealed class GetItemHandler(IRepository<Item> itemRepository)
    : IHandler<GetItemRequest, Result<ItemDetailsDto>>
{
    public async Task<Result<ItemDetailsDto>> HandleAsync(GetItemRequest command, CancellationToken cancellationToken)
    {
        var item = await itemRepository.GetByIdAsync(command.Id, cancellationToken);

        if (item is null)
        {
            return Result.Failure<ItemDetailsDto>(
                Error.NotFound("Items.NotFound", "Item was not found."));
        }

        return Result.Success(new ItemDetailsDto(
            item.Id,
            item.Name,
            item.CategoryId,
            item.Price,
            item.ReleaseDate,
            item.Description,
            item.LastUpdatedBy));
    }
}