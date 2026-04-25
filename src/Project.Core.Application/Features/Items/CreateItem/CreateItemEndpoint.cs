using System.Security.Claims;
using Project.Core.Application.Abstractions;
using Project.Core.Application.Extensions;
using Project.Core.Application.Features.Items.Constants;
using Project.Core.Application.Features.Items.GetItem;
using Project.Core.Domain.Abstractions;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace Project.Core.Application.Features.Items.CreateItem;

public sealed record CreateItemDto(
    string Name,
    Guid CategoryId,
    decimal Price,
    DateOnly ReleaseDate,
    string Description
);

internal sealed class CreateItemEndpoint : IApiEndpoint
{
    public void MapEndpoint(WebApplication app)
    {
        app.MapPost("/items", async (
            CreateItemDto itemDto,
            IHandler<CreateItemRequest, Result<ItemDetailsDto>> handler,
            ClaimsPrincipal user,
            ILogger<CreateItemEndpoint> logger,
            CancellationToken cancellationToken) =>
        {
            var userEmail = user?.FindFirstValue("email");

            if (string.IsNullOrWhiteSpace(userEmail))
            {
                return Results.Unauthorized();
            }

            var request = new CreateItemRequest(
                itemDto.Name,
                itemDto.CategoryId,
                itemDto.Price,
                itemDto.ReleaseDate,
                itemDto.Description,
                userEmail);

            var result = await handler.HandleAsync(request, cancellationToken);

            return result.Match(
                onSuccess: data =>
                {
                    logger.LogInformation(
                        "Created item {ItemName} with price {ItemPrice}",
                        data.Name,
                        data.Price);

                    return Results.CreatedAtRoute(
                        EndpointNames.GetItem,
                        new { id = data.Id },
                        data);
                },
                onFailure: error => Results.BadRequest(error));
        })
        .RequireAuthorization()
        .Produces<ItemDetailsDto>(StatusCodes.Status201Created)
        .ProducesValidationProblem()
        .Produces(StatusCodes.Status401Unauthorized);
    }
}