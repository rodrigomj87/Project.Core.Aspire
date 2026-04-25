# .NET Backend Blueprint
A comprehensive .NET 10 backend template using Aspire for local development and deployment to Azure. This template provides a modern, cloud-ready API with authentication, authorization and database integration.

**Video Walkthrough**: [Watch the full tutorial on YouTube](https://youtu.be/EfKC_9I1YiM)

## Overview

This template includes:

- **.NET 10 Web API** with Entity Framework Core and PostgreSQL
- **Clean Architecture** with clear layer separation (Domain, Application, Infrastructure, Api)
- **Vertical Slice Architecture** within the Application layer, organizing features as self-contained slices
- **Keycloak authentication** for JWT-based security
- **Global error handling** for consistent API responses
- **Pipeline decorators** for cross-cutting concerns (logging, validation)
- **Angular 21 SPA frontend** with Angular Material, OIDC/PKCE authentication via Keycloak, and i18n (`pt-BR`)
- **Aspire** orchestration for local development
- **Azure Container Apps** deployment ready
- **CI/CD pipeline** for GitHub Actions

## Prerequisites

Before getting started, ensure you have the following tools installed:

- **[.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)** - The latest .NET SDK
- **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** - For containerized services (PostgreSQL, Keycloak)
- **[Aspire CLI](https://learn.microsoft.com/dotnet/aspire/cli/install)** - To run the application locally and deploy to Azure
- **[Node.js 22+](https://nodejs.org/)** - Required to build and run the Angular 21 frontend
- **[Angular CLI 21+](https://angular.dev/tools/cli)** - Used internally by `npm start` / `npm run build`; install via `npm install -g @angular/cli`

## Getting Started

### Running the Project Locally

1. **Navigate to the root directory** of the project
2. **Run the application** using Aspire:
   ```bash
   dotnet run --project src/Project.Core.AppHost
   ```
   Or alternatively:
   ```bash
   aspire run
   ```

3. **Access the Aspire Dashboard** using the URL provided in the terminal output

### Testing the API

Once the application is running, you can test the API using:

- **Swagger UI**: Access it from the Aspire Dashboard by clicking the **API Docs** link for the API service
- **Aspire Dashboard**: Monitor application health, logs, and metrics through the dashboard

### Authentication with Keycloak

The template uses Keycloak for authentication. Once the application is running:

#### Testing API with Swagger UI

1. **Access Swagger UI** from the Aspire Dashboard by clicking the **API Docs** link
2. **Click the "Authorize" button** in the Swagger UI interface
3. **Complete the OAuth2 flow**:
   - You'll be redirected to the Keycloak login page
   - **Login with**: `demo` / `demo`
   - After successful authentication, you'll be redirected back to Swagger UI
4. **Test API endpoints**: You can now use all API endpoints in Swagger UI with the obtained access token

#### Managing Keycloak (Admin Access)

If you need to manage Keycloak realm, clients, scopes, or users:

1. **Access Keycloak Admin Console** from the Aspire Dashboard by clicking on the Keycloak service endpoint
2. **Login with admin credentials**:
   - **Username**: `admin`
   - **Password**: `admin`
3. From here you can:
   - Create additional users
   - Configure client scopes
   - Manage roles and permissions
   - Adjust authentication flows

#### Exporting Keycloak Realm

To export the Keycloak realm configuration (useful for backup or version control):

1. **Find the Keycloak volume name** assigned by Aspire:
   ```bash
   docker volume ls
   ```
   Look for a volume name similar to `projectcore.apphost-<hash>-keycloak-data`

2. **Stop the running Keycloak container** (if any):
   ```bash
   docker ps
   ```
   Find the Keycloak container ID, then stop it:
   ```bash
   docker stop <keycloak-container-id>
   ```

3. **Run the export command** (replace `<keycloak-volume-name>` with the actual volume name):
   ```bash
   docker run --rm -v <keycloak-volume-name>:/opt/keycloak/data -v "${PWD}\kc-export:/export" -e KC_DB=dev-file quay.io/keycloak/keycloak:26.4 export --realm projectcore --dir /export --users realm_file
   ```

4. The exported realm configuration will be saved to the `kc-export` directory in your project root


## Frontend Angular

The template includes an Angular 21 frontend (`src/Project.Core.Web`) integrated via Aspire.

### Running the Frontend

The frontend starts automatically when you run Aspire:
```bash
dotnet run --project src/Project.Core.AppHost
```

Angular is served on **http://localhost:4200** and appears in the Aspire Dashboard as `projectcore-web`.

### Frontend Features

- **Área pública**: Landing page explicativa da stack
- **Área privada (autenticada)**: listagem de Categorias e CRUD completo de Itens
- **Autenticação OIDC/PKCE** via Keycloak (`projectcore-spa` client)
- **Angular Material** com sidenav recolhível e layout responsivo
- **i18n** com `@angular/localize` (locale `pt`)

### Running Frontend Standalone (without Aspire)

```bash
cd src/Project.Core.Web
npm install
npm start
```

The development defaults in `environment.development.ts` point to `http://localhost:8080` (Keycloak) and `http://localhost:5000` (API). When Aspire injects `KEYCLOAK_AUTHORITY` and `API_URL` environment variables, `generate-env.js` writes `environment.generated.ts` with the correct URLs.

### CORS (Production)

When deploying to Azure, add the Angular frontend URL to the `AllowedOrigins` in `appsettings.json` of the API project:
```json
"Cors": {
  "AllowedOrigins": ["https://your-frontend.azurecontainerapps.io"]
}
```



### Deploy with Aspire

1. **Deploy to Azure**:
   ```bash
   aspire deploy
   ```

2. Follow the prompts to:
   - Select your Azure subscription
   - Choose a deployment region
   - Provide environment-specific configuration

The deployment will provision:
- Azure Container Apps Environment
- Azure Container Apps for the API backend
- Azure Container Apps for the Angular frontend
- Azure Container Apps for Keycloak
- PostgreSQL Flexible Server
- Container Registry
- Managed Identity
- All necessary networking and security configurations

### Post-Deployment Configuration

After the deployment completes, you need to configure Keycloak for your Azure environment:

#### 1. Import the Realm Configuration

1. **Access your deployed Keycloak instance** using the URL provided in the Azure Container Apps
2. **Login to the Admin Console**:
   - **Username**: `admin`
   - **Password**: Check your Azure Key Vault or deployment outputs for the admin password
3. **Import the realm**:
   - Navigate to the realm dropdown in the top-left corner
   - Click **Create Realm**
   - Click **Browse** and select `src/Project.Core.AppHost/realms/projectcore-realm.json`
   - Click **Create** to import the realm

### Testing the API with Postman

A Postman collection is included at [src/Project.Core.Api/postman_collection.json](src/Project.Core.Api/postman_collection.json) for testing the API, both locally and on Azure.

#### Setting up Postman

1. **Import the collection**:
   - Open Postman
   - Click **Import** and select `src/Project.Core.Api/postman_collection.json`

2. **Configure collection variables**:
   - Right-click the imported collection and select **Edit**
   - Navigate to the **Variables** tab
   - For **local testing**, the default values should work (check the current values)
   - For **Azure testing**, update:
     - `baseUrl` with your deployed API endpoint (e.g., `https://your-api.azurecontainerapps.io`)
     - `keycloakUrl` with your deployed Keycloak endpoint (e.g., `https://your-keycloak.azurecontainerapps.io`)
   - Save the changes

3. **Authenticate for protected endpoints** (POST/PUT/DELETE requests):
   - Navigate to the collection's **Authorization** tab
   - Click **Get New Access Token** (OAuth 2.0 settings are pre-configured)
   - Sign in on the Keycloak page with **demo** / **demo**
   - Click **Use Token** to apply it to your requests

You can now send requests to test your deployed API!

## CI/CD Pipelines (Optional)

### GitHub Actions

While `aspire deploy` is great for manual deployments, you can set up automated CI/CD pipelines for continuous deployment.

The included workflow (`.github/workflows/azure-dev.yml`) covers:
- **`setup-dotnet`** — installs .NET 10
- **`setup-node`** — installs Node.js 22 (required for the Angular frontend build)
- **`dotnet build`** — validates the .NET solution
- **`npm ci && npm run build`** — validates the Angular frontend compiles successfully
- **`azd provision`** — provisions Azure infrastructure (Container Apps for API + Angular + Keycloak, PostgreSQL, ACR)
- **`azd deploy`** — builds Docker images (API and Angular via `PublishAsDockerFile()`) and deploys to Azure Container Apps

**Note**: `aspire deploy` / `azd deploy` uses Aspire's `PublishAsDockerFile()` to build the Angular Docker image in Azure Container Registry — no local Docker build is needed in CI.

To set up GitHub Actions with Azure Developer CLI:

1. **Install Azure Developer CLI** if not already installed:
   ```bash
   winget install microsoft.azd
   ```

2. **Initialize the Azure Developer CLI project**:
   ```bash
   azd init
   ```

3. **Run the pipeline configuration command**:
   ```bash
   azd pipeline config --provider github
   ```

4. **Follow the interactive prompts** to configure:
   - GitHub repository connection
   - Azure authentication (Federated Identity recommended)
   - Deployment settings and environments

4. **Commit and push** your changes to trigger the pipeline

## Project Structure

```
├── src/
│   ├── Project.Core.Domain/              # Domain layer (entities, abstractions, value objects)
│   │   ├── Entities/                     # Domain entities (Item, Category)
│   │   └── Abstractions/                 # Result pattern, Error types
│   ├── Project.Core.Application/         # Application layer (use cases as vertical slices)
│   │   ├── Abstractions/                 # Interfaces (IHandler, IApiEndpoint, IRepository, IUnitOfWork)
│   │   ├── Features/                     # Vertical slices grouped by feature
│   │   ├── Pipelines/                    # Cross-cutting decorators (Logging, Validation)
│   │   └── Extensions/                   # Endpoint mapping and Result helpers
│   ├── Project.Core.Infrastructure/      # Infrastructure layer (data access, external services)
│   │   ├── Database/                     # EF Core DbContext, configurations, migrations
│   │   └── Repository/                   # Repository and UnitOfWork implementations
│   ├── Project.Core.Api/                 # Presentation layer (host, composition root)
│   │   ├── Data/                         # Aspire Npgsql integration and DB seeding
│   │   └── Shared/                       # Authentication, CORS, OpenApi, error handling
│   ├── Project.Core.AppHost/             # Aspire orchestration (PostgreSQL, Keycloak, API, Web)
│   ├── Project.Core.ServiceDefaults/     # Shared Aspire service configurations
│   └── Project.Core.Web/                 # Angular 21 frontend (OIDC/PKCE, Material, i18n)
│       ├── src/app/core/                 # Auth service, interceptor, guard, API services
│       ├── src/app/layout/               # App shell (authenticated) + Public shell
│       └── src/app/features/             # Home, Categories list, Items CRUD
├── .github/workflows/                    # GitHub Actions workflows
└── azure.yaml                           # Azure Developer CLI configuration
```

## Architecture

This template combines **Clean Architecture** with **Vertical Slice Architecture**. Clean Architecture defines the layer boundaries (Domain, Application, Infrastructure, Api) and dependency direction, while Vertical Slices organize the use cases within the Application layer as self-contained feature slices.

### Clean Architecture Layers

```
Domain  <──  Application  <──  Infrastructure
                 ^
                 │
                Api (composition root)
```

- **Domain** - Entities, value objects, and abstractions (Result pattern, Error types). No dependencies on other layers.
- **Application** - Use cases organized as vertical slices, handler abstractions (`IHandler<TRequest, TResponse>`), repository contracts, endpoint contracts (`IApiEndpoint`), and pipeline decorators. Depends only on Domain.
- **Infrastructure** - EF Core `ProjectCoreContext`, entity configurations, repository and UnitOfWork implementations. Depends on Domain and Application.
- **Api** - ASP.NET Core host, Aspire integration, DI composition root, authentication/CORS/OpenApi configuration. References Application, Infrastructure, and ServiceDefaults.

### Vertical Slices (Feature Organization)

Each feature in the Application layer is organized as independent slices. Every operation (CreateItem, GetItems, etc.) is a self-contained folder with its own **Endpoint** and **Handler**:

```
Application/Features/
├── Items/
│   ├── Constants/
│   │   └── EndpointNames.cs              # Shared route names
│   ├── CreateItem/
│   │   ├── CreateItemEndpoint.cs          # Minimal API route + DTOs
│   │   └── CreateItemHandler.cs           # IHandler implementation + request record
│   ├── GetItem/
│   │   ├── GetItemEndpoint.cs
│   │   └── GetItemHandler.cs
│   ├── GetItems/
│   │   ├── GetItemsEndpoint.cs
│   │   └── GetItemsHandler.cs
│   ├── UpdateItem/
│   │   ├── UpdateItemEndpoint.cs
│   │   └── UpdateItemHandler.cs
│   └── DeleteItem/
│       ├── DeleteItemEndpoint.cs
│       └── DeleteItemHandler.cs
└── Categories/
    └── GetCategories/
        ├── GetCategoriesEndpoint.cs
        └── GetCategoriesHandler.cs
```

### Pipeline Decorators

Cross-cutting concerns are applied transparently via the decorator pattern over `IHandler<,>`:

1. **LoggingDecorator** - Logs request start/end and flags failures
2. **ValidationDecorator** - Runs FluentValidation rules before the handler executes

Decorators are registered automatically via Scrutor in `DependencyInjection.AddApplication()`.

### Key Principles

- **Dependency inversion** - All layers depend inward toward Domain; infrastructure details are behind abstractions
- **Self-contained slices** - Each operation has its own Endpoint + Handler; changes don't ripple across features
- **Automatic registration** - Handlers, endpoints, and validators are discovered and registered by assembly scanning
- **Result pattern** - Handlers return `Result<T>` instead of throwing exceptions, enabling explicit error handling
- **Minimal API endpoints** - Each `IApiEndpoint` maps its own route via `MapEndpoint(WebApplication app)`

## Installing the Template

To use this template for creating new projects:

1. **Navigate to the template root directory**
2. **Install the template**:
   ```bash
   dotnet new install .\
   ```

### Using the Template

Once installed, create a new project using the template:

```bash
# Create a new project in the current directory
dotnet new backend

# Create a new project with a specific name
dotnet new backend -n MyAwesomeBackend
```

### Template Parameters

The template supports the following parameters:

- `-n|--name`: Name of the project (default: current directory name)


### Configuration

### Local Development

The template uses Keycloak for local authentication. Configuration is handled automatically through Aspire service discovery.

**Key features enabled for local development:**
- **Global error handling** - Consistent error responses across all endpoints
- **CORS configuration** - Properly configured for local development
- **Health checks** - Built-in health monitoring endpoints
- **Logging and telemetry** - Integrated with Aspire dashboard

### Production

In production (Azure), the following are automatically configured:
- Managed Identity for secure service-to-service communication
- Azure Database for PostgreSQL
- Container Apps for scalable hosting


## License

This template is provided as-is for educational and development purposes.