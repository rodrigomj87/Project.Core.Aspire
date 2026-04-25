using Project.Core.Application.Abstractions;
using Project.Core.Application.Abstractions.Data;
using Project.Core.Domain.Abstractions;
using Project.Core.Domain.Abstractions.Errors;
using Project.Core.Domain.Entities;

namespace Project.Core.Application.Features.Items.UpdateItem;

public sealed record UpdateItemRequest(
    Guid Id,
    string Name,
    Guid CategoryId,
    decimal Price,
    DateOnly ReleaseDate,
    string Description,
    string LastUpdatedBy);

public sealed class UpdateItemHandler(
    IRepository<Item> itemRepository,
    IUnitOfWork unitOfWork)
    : IHandler<UpdateItemRequest, Result>
{
    public async Task<Result> HandleAsync(UpdateItemRequest command, CancellationToken cancellationToken)
    {
        var existingItem = await itemRepository.GetByIdAsync(command.Id, cancellationToken);

        if (existingItem is null)
        {
            return Result.Failure(Error.NotFound("Items.NotFound", "Item was not found."));
        }

        existingItem.Name = command.Name;
        existingItem.CategoryId = command.CategoryId;
        existingItem.Price = command.Price;
        existingItem.ReleaseDate = command.ReleaseDate;
        existingItem.Description = command.Description;
        existingItem.LastUpdatedBy = command.LastUpdatedBy;

        await itemRepository.UpdateAsync(existingItem, cancellationToken);
        await unitOfWork.CommitAsync(cancellationToken);

        return Result.Success();
    }
}