using Project.Core.Application.Abstractions;
using Project.Core.Application.Abstractions.Data;
using Project.Core.Application.Features.Items.GetItem;
using Project.Core.Domain.Abstractions;
using Project.Core.Domain.Entities;

namespace Project.Core.Application.Features.Items.CreateItem;

public sealed record CreateItemRequest(
    string Name,
    Guid CategoryId,
    decimal Price,
    DateOnly ReleaseDate,
    string Description,
    string LastUpdatedBy);

public sealed class CreateItemHandler(
    IRepository<Item> itemRepository,
    IUnitOfWork unitOfWork)
    : IHandler<CreateItemRequest, Result<ItemDetailsDto>>
{
    public async Task<Result<ItemDetailsDto>> HandleAsync(CreateItemRequest command, CancellationToken cancellationToken)
    {
        var item = new Item
        {
            Id = Guid.CreateVersion7(),
            Name = command.Name,
            CategoryId = command.CategoryId,
            Price = command.Price,
            ReleaseDate = command.ReleaseDate,
            Description = command.Description,
            LastUpdatedBy = command.LastUpdatedBy
        };

        await itemRepository.AddAsync(item, cancellationToken);
        await unitOfWork.CommitAsync(cancellationToken);

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