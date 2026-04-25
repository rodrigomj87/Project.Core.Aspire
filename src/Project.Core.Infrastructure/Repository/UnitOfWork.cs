using Project.Core.Application.Abstractions.Data;
using Project.Core.Infrastructure.Database;

namespace Project.Core.Infrastructure.Repository;

public class UnitOfWork(ProjectCoreContext dataContext) : IUnitOfWork
{
    public int Commit()
    {
        return dataContext.SaveChanges();
    }

    public async Task<int> CommitAsync(CancellationToken cancellationToken)
    {
        return await dataContext.SaveChangesAsync(cancellationToken);
    }

    public void Rollback()
    {
        dataContext.Dispose();
    }

    public async Task RollbackAsync()
    {
        await dataContext.DisposeAsync();
    }
}