using Project.Core.Application.Abstractions;
using Project.Core.Application.Extensions;
using Project.Core.Domain.Abstractions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace Project.Core.Application.Features.Items.DeleteItem;

internal sealed class DeleteItemEndpoint : IApiEndpoint
{
    public void MapEndpoint(WebApplication app)
    {
        app.MapDelete("/items/{id}", async (
            Guid id,
            IHandler<DeleteItemRequest, Result> handler,
            CancellationToken cancellationToken) =>
        {
            var result = await handler.HandleAsync(new DeleteItemRequest(id), cancellationToken);
            return result.Match(
                onSuccess: () => Results.NoContent(),
                onFailure: error => Results.BadRequest(error));
        })
        .RequireAuthorization()
        .Produces(StatusCodes.Status204NoContent)
        .Produces(StatusCodes.Status401Unauthorized);
    }
}