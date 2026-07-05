# aaqueen-ecom — Architecture

<!-- AUTO-GENERATED:architecture -->
## Pattern

GetX feature-based (features/ + global/ + controller/)

## Layers

| Layer | Location | Notes |
|-------|----------|-------|
| Presentation | `lib/features/**/presentation`, `lib/view/` | Screens and widgets |
| Controllers | `lib/features/**/controller`, `lib/controller/` | GetX / flow control |
| Data | `lib/features/**/data`, repositories | API and persistence |
| Domain | `lib/features/**/domain`, models | Entities and constants |
| Global | `lib/global/` | Shared API, theme, SP, utils |

## State management

- Primary: **GetX**
- Bindings: `lib/controller/initial_binding.dart` (if present)

## Network layer

- API helpers under `lib/global/apiutils/` or project-specific API utils
- Endpoints documented in `api-reference.md`

## Services

- AnalyticsService (lib/global/services/analytics_service.dart)
- AppService (lib/global/services/app_service.dart)
- AuthService (lib/global/services/auth_service.dart)
- BaseService (lib/global/base/base_service.dart)
- ConnectivityService (lib/global/services/connectivity_service.dart)
- HiveService (lib/global/services/hive_service.dart)
- StorageService (lib/global/services/storage_service.dart)
- UploadResult (lib/global/services/storage_service.dart)
- _PeriodicTask (lib/global/base/base_service.dart)

## Repositories

- AdminRepository (lib/data/repositories/admin_repository.dart)
- BaseRepository (lib/global/base/base_repository.dart)
- _CacheEntry (lib/global/base/base_repository.dart)
<!-- END AUTO-GENERATED:architecture -->
