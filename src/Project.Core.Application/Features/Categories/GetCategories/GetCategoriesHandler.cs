using Project.Core.Application.Abstractions;
using Project.Core.Application.Abstractions.Data;
using Project.Core.Domain.Abstractions;
using Project.Core.Domain.Entities;

namespace Project.Core.Application.Features.Categories.GetCategories;

public sealed record GetCategoriesRequest;

public sealed record CategoryDto(Guid Id, string Name);

public sealed class GetCategoriesHandler(IRepository<Category> categoryRepository)
    : IHandler<GetCategoriesRequest, Result<List<CategoryDto>>>
{
    public async Task<Result<List<CategoryDto>>> HandleAsync(GetCategoriesRequest command, CancellationToken cancellationToken)
    {
        var categories = await categoryRepository.GetAllAsync(cancellationToken);

        var result = categories
            .Select(category => new CategoryDto(category.Id, category.Name))
            .ToList();

        return Result.Success(result);
    }
}