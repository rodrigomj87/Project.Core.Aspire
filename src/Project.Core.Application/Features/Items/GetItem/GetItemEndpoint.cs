using Project.Core.Application.Abstractions;
using Project.Core.Application.Extensions;
using Project.Core.Application.Features.Items.Constants;
using Project.Core.Domain.Abstractions;
using Project.Core.Domain.Abstractions.Errors;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace Project.Core.Application.Features.Items.GetItem;

internal sealed class GetItemEndpoint : IApiEndpoint
{
    public void MapEndpoint(WebApplication app)
    {
        app.MapGet("/items/{id}", async (
            Guid id,
            IHandler<GetItemRequest, Result<ItemDetailsDto>> handler,
            CancellationToken cancellationToken) =>
        {
            var result = await handler.HandleAsync(new GetItemRequest(id), cancellationToken);

            return result.Match(
                onSuccess: data => Results.Ok(data),
                onFailure: error => error.Type == ErrorType.NotFound
                    ? Results.NotFound()
                    : Results.BadRequest(error));
        })
        .WithName(EndpointNames.GetItem)
        .Produces<ItemDetailsDto>(StatusCodes.Status200OK)
        .Produces(StatusCodes.Status404NotFound);
    }
}