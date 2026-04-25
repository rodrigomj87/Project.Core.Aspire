using FluentValidation;

namespace Project.Core.Application.Features.Items.UpdateItem;

public sealed class UpdateItemValidator : AbstractValidator<UpdateItemRequest>
{
    public UpdateItemValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Name is required.")
            .MaximumLength(50).WithMessage("Name must not exceed 50 characters.");

        RuleFor(x => x.CategoryId)
            .NotEmpty().WithMessage("CategoryId is required.");

        RuleFor(x => x.Price)
            .GreaterThan(0).WithMessage("Price must be greater than 0.")
            .LessThanOrEqualTo(999.99m).WithMessage("Price must not exceed 999.99.");

        RuleFor(x => x.ReleaseDate)
            .NotEqual(default(DateOnly)).WithMessage("ReleaseDate is required.");

        RuleFor(x => x.Description)
            .MaximumLength(500).WithMessage("Description must not exceed 500 characters.");

        RuleFor(x => x.LastUpdatedBy)
            .NotEmpty().WithMessage("LastUpdatedBy is required.");
    }
}
