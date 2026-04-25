using Project.Core.Application.Abstractions;
using Project.Core.Application.Extensions;
using Project.Core.Domain.Abstractions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace Project.Core.Application.Features.Categories.GetCategories;

internal sealed class GetCategoriesEndpoint : IApiEndpoint
{
    public void MapEndpoint(WebApplication app)
    {
        app.MapGet("/categories", async (
            IHandler<GetCategoriesRequest, Result<List<CategoryDto>>> handler,
            CancellationToken cancellationToken) =>
        {
            var result = await handler.HandleAsync(new GetCategoriesRequest(), cancellationToken);
            return result.Match(
                onSuccess: data => Results.Ok(data),
                onFailure: error => Results.BadRequest(error));
        })
        .Produces<List<CategoryDto>>(StatusCodes.Status200OK)
        .Produces(StatusCodes.Status400BadRequest);
    }
}