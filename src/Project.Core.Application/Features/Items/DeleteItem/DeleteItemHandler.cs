using Project.Core.Application.Abstractions;
using Project.Core.Application.Abstractions.Data;
using Project.Core.Domain.Abstractions;
using Project.Core.Domain.Entities;

namespace Project.Core.Application.Features.Items.DeleteItem;

public sealed record DeleteItemRequest(Guid Id);

public sealed class DeleteItemHandler(
    IRepository<Item> itemRepository,
    IUnitOfWork unitOfWork)
    : IHandler<DeleteItemRequest, Result>
{
    public async Task<Result> HandleAsync(DeleteItemRequest command, CancellationToken cancellationToken)
    {
        var item = await itemRepository.GetByIdAsync(command.Id, cancellationToken);

        if (item is null)
        {
            return Result.Success();
        }

        await itemRepository.DeleteAsync(item, cancellationToken);
        await unitOfWork.CommitAsync(cancellationToken);

        return Result.Success();
    }
}