using System.Reflection;
using FluentValidation;
using Project.Core.Application.Abstractions;
using Project.Core.Application.Extensions;
using Project.Core.Application.Pipelines;
using Microsoft.Extensions.DependencyInjection;

namespace Project.Core.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        var assembly = typeof(DependencyInjection).Assembly;

        services.AddValidatorsFromAssembly(assembly);
        services.AddHandlersFromAssembly(assembly);
        services.RegisterApiEndpointsFromAssembly(assembly);

        return services;
    }

    private static IServiceCollection AddHandlersFromAssembly(
        this IServiceCollection services,
        Assembly assembly)
    {
        var handlerTypes = assembly.GetTypes()
            .Where(t =>
                t.IsClass &&
                !t.IsAbstract &&
                !t.ContainsGenericParameters)
            .ToList();

        foreach (var implementation in handlerTypes)
        {
            var handlerInterfaces = implementation
                .GetInterfaces()
                .Where(i =>
                    i.IsGenericType &&
                    i.GetGenericTypeDefinition() == typeof(IHandler<,>));

            foreach (var handlerInterface in handlerInterfaces)
            {
                services.AddScoped(handlerInterface, implementation);
            }
        }

        services.Decorate(typeof(IHandler<,>), typeof(ValidationDecorator<,>));
        services.Decorate(typeof(IHandler<,>), typeof(LoggingDecorator<,>));

        return services;
    }
}