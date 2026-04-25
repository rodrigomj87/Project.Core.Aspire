using System.Security.Claims;
using Project.Core.Application.Abstractions;
using Project.Core.Application.Extensions;
using Project.Core.Domain.Abstractions;
using Project.Core.Domain.Abstractions.Errors;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace Project.Core.Application.Features.Items.UpdateItem;

public sealed record UpdateItemDto(
    string Name,
    Guid CategoryId,
    decimal Price,
    DateOnly ReleaseDate,
    string Description
);

internal sealed class UpdateItemEndpoint : IApiEndpoint
{
    public void MapEndpoint(WebApplication app)
    {
        app.MapPut("/items/{id}", async (
            Guid id,
            UpdateItemDto itemDto,
            IHandler<UpdateItemRequest, Result> handler,
            ClaimsPrincipal user,
            CancellationToken cancellationToken) =>
        {
            var userEmail = user?.FindFirstValue("email");

            if (string.IsNullOrWhiteSpace(userEmail))
            {
                return Results.Unauthorized();
            }

            var request = new UpdateItemRequest(
                id,
                itemDto.Name,
                itemDto.CategoryId,
                itemDto.Price,
                itemDto.ReleaseDate,
                itemDto.Description,
                userEmail);

            var result = await handler.HandleAsync(request, cancellationToken);

            return result.Match(
                onSuccess: () => Results.NoContent(),
                onFailure: error => error.Type == ErrorType.NotFound
                    ? Results.NotFound()
                    : Results.BadRequest(error));
        })
        .RequireAuthorization()
        .Produces(StatusCodes.Status204NoContent)
        .ProducesValidationProblem()
        .Produces(StatusCodes.Status401Unauthorized)
        .Produces(StatusCodes.Status404NotFound);
    }
}