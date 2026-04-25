using Azure.Identity;
using Project.Core.Application;
using Project.Core.Application.Extensions;
using Project.Core.Api.Data;
using Project.Core.Api.Shared.Cors;
using Project.Core.Api.Shared.ErrorHandling;
using Project.Core.Api.Shared.OpenApi;
using Project.Core.Api.Shared.Authentication;
using Project.Core.Infrastructure;
using Microsoft.AspNetCore.HttpLogging;

var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();

builder.Services.AddProblemDetails()
                .AddExceptionHandler<GlobalExceptionHandler>();

var credential = new DefaultAzureCredential(new DefaultAzureCredentialOptions
{
    ManagedIdentityClientId = builder.Configuration["AZURE_CLIENT_ID"]
});

builder.AddProjectCoreNpgsql<Project.Core.Infrastructure.Database.ProjectCoreContext>("ProjectCoreDB", credential);

builder.Services.AddApplication();
builder.Services.AddInfrastructure();

// Configure authentication options with validation
builder.Services.AddOptions<AuthOptions>()
                .Bind(builder.Configuration.GetSection(AuthOptions.SectionName))
                .ValidateDataAnnotations()
                .ValidateOnStart();

// Register the JWT Bearer options configurator first
builder.Services.ConfigureOptions<JwtBearerOptionsSetup>();

// Then add the authentication services
builder.Services.AddAuthentication()
                .AddJwtBearer();

builder.Services.AddAuthorizationBuilder();

builder.Services.AddHttpLogging(options =>
{
    options.LoggingFields = HttpLoggingFields.RequestMethod |
                            HttpLoggingFields.RequestPath |
                            HttpLoggingFields.ResponseStatusCode |
                            HttpLoggingFields.Duration;
    options.CombineLogs = true;
});

builder.AddProjectCoreOpenApi();

builder.AddProjectCoreCors();

builder.Services.AddValidation();

var app = builder.Build();

app.UseCors();

app.MapDefaultEndpoints();
app.MapApiEndpoints();

app.UseHttpLogging();

if (app.Environment.IsDevelopment())
{
    app.UseProjectCoreSwaggerUI();
}
else
{
    app.UseExceptionHandler();
}

app.UseStatusCodePages();

await app.MigrateDbAsync<Project.Core.Infrastructure.Database.ProjectCoreContext>();

app.Run();