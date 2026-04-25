using Project.Core.Application.Abstractions;
using Project.Core.Application.Extensions;
using Project.Core.Domain.Abstractions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Project.Core.Application.Features.Items.GetItems;

internal sealed class GetItemsEndpoint : IApiEndpoint
{
    public void MapEndpoint(WebApplication app)
    {
        app.MapGet("/items", async (
            [AsParameters] GetItemsRequest request,
            IHandler<GetItemsRequest, Result<ItemsPageDto>> handler,
            CancellationToken cancellationToken) =>
        {
            var result = await handler.HandleAsync(request, cancellationToken);
            return result.Match(
                onSuccess: data => Results.Ok(data),
                onFailure: error => Results.BadRequest(error));
        })
        .Produces<ItemsPageDto>(StatusCodes.Status200OK);
    }
}