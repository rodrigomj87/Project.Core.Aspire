using Microsoft.AspNetCore.Builder;

namespace Project.Core.Application.Abstractions;

public interface IApiEndpoint
{
    void MapEndpoint(WebApplication app);
}