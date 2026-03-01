# Mini News Intelligence App

A clean, scalable Flutter application built as part of a **Junior Developer Assignment**. It delivers a polished business news experience with category-based browsing, full-text search, offline favourites, and a complete local authentication flow — all wired together with clean architecture, Riverpod state management, and Hive local storage.

---

## Features

| Screen | Highlights |
|---|---|
| **Splash** | Animated branding screen with smart auth redirect |
| **Register** | Local account creation with duplicate-email guard |
| **Login** | Credential validation, persisted session via Hive |
| **Forgot Password** | In-app password reset against local storage |
| **Home Feed** | Category chips (Business · Tech · Sports · Health · Science), infinite scroll, pull-to-refresh, gradient app bar that hides on scroll |
| **Search** | Debounced API search via NewsAPI `/everything`, paginated results |
| **Article Detail** | Full article view, save/unsave favourite with animated heart button |
| **Favourites** | Fully offline, Hive-persisted list; survives app restarts |

---

## Architecture

The project follows a layered **Clean Architecture** approach, keeping concerns clearly separated across three logical tiers:

```
Presentation  →  Providers (State)  →  Repository  →  Network / Local
```

- **Presentation**: Flutter widgets (`screens/`, `widgets/`) that are purely reactive — they read state and dispatch events, never touching network or storage directly.
- **State Management (Riverpod)**: `StateNotifier` + `StateNotifierProvider` classes in `features/providers/` act as the glue. They orchestrate business logic and expose immutable state snapshots.
- **Repository Pattern**: `NewsRepository` abstract interface in `features/repository/` decouples the notifiers from the concrete `NewsRepositoryImpl`. Swapping the API or adding a mock for tests requires zero changes to the UI or providers.
- **Data Sources**: Two independent data sources live in `features/core/local/` (Hive) and `network/` (Dio). Each has a single responsibility.

---

## Folder Structure

```
lib/
├── main.dart                          # App entry — Hive init, ProviderScope, router
│
├── constants/
│   ├── app_colors.dart                # Centralised colour tokens (deep-blue palette)
│   ├── app_text_styles.dart           # Shared text style definitions
│   ├── app_sizes.dart                 # Spacing / radius constants
│   └── app_strings.dart              # String literals (copy, labels)
│
├── network/
│   ├── api_endpoints.dart             # Base URL, path constants, API key
│   └── dio_client.dart               # Configured Dio singleton (timeouts)
│
├── utils/
│   ├── validators.dart               # Form validation helpers (email, password)
│   └── extensions.dart              # Dart extension helpers (String, DateTime)
│
├── widgets/
│   ├── app_button.dart              # Reusable gradient primary button
│   ├── app_textfield.dart           # Styled text input with error display
│   └── app_loader.dart              # Centred circular progress indicator wrapper
│
└── features/
    ├── model/
    │   └── article_model.dart        # Article POJO with fromJson / toJson
    │
    ├── repository/
    │   ├── news_repository.dart      # Abstract contract (interface)
    │   └── news_repository_impl.dart # Dio-based implementation
    │
    ├── core/
    │   └── local/
    │       ├── auth_local_storage.dart    # Hive CRUD for auth (register/login/session)
    │       └── favorites_storage.dart    # Hive CRUD for saved articles
    │
    ├── providers/
    │   ├── auth_provider.dart        # AuthNotifier + AuthState (login/register/reset)
    │   ├── news_provider.dart        # NewsNotifier + NewsState (fetch/paginate/search)
    │   └── fav_provider.dart         # FavNotifier — toggle + read saved articles
    │
    ├── routes/
    │   └── app_router.dart           # GoRouter config + auth redirect guard
    │
    └── screens/
        ├── login_page.dart
        ├── register_page.dart
        ├── forgot_password_page.dart
        ├── splash/
        │   └── splash_page.dart
        └── post_login/
            ├── main_shell_page.dart      # Bottom nav shell (ShellRoute)
            ├── home_page.dart
            ├── search_page.dart
            ├── favourite_page.dart
            ├── article_details_page.dart
            └── news_card.dart            # Reusable card widget
```

---

## Tech Stack & Key Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^3.2.1 | State management (`StateNotifier` pattern) |
| `go_router` | ^17.1.0 | Declarative routing with auth redirect guard |
| `hive` + `hive_flutter` | ^2.2.3 / ^1.1.0 | Offline persistence (auth + favourites) |
| `dio` | ^5.9.1 | HTTP client with timeout configuration |

---

## Key Architectural Decisions

### 1. Local Authentication (No Firebase)
Authentication is implemented entirely offline using **Hive**. Credentials are stored keyed by email; a `loggedIn` boolean flag drives the GoRouter redirect guard. This keeps the app self-contained and dependency-light.

> **Trade-off**: Passwords are stored in plain-text in local storage — acceptable for an assignment demo but should be hashed (e.g., SHA-256 or bcrypt) in a production app.

### 2. Riverpod `StateNotifier` over `AsyncNotifier`
`StateNotifier<T>` was chosen for fine-grained control: loading, loadingMore, hasMore, and error fields are all first-class citizens of the state class rather than relying on the `AsyncValue` union. This makes pagination and pull-to-refresh logic much cleaner.

### 3. Repository Abstraction
`NewsRepository` (abstract) → `NewsRepositoryImpl` (Dio). This inversion of dependency means:
- Unit tests can inject a `MockNewsRepository` with zero friction.
- The concrete implementation is swapped in one line in the provider.

### 4. GoRouter + ShellRoute
- A top-level `redirect` callback reads Hive on every navigation event to enforce the auth guard.
- `ShellRoute` wraps the three main screens (`home`, `search`, `favourites`) in a shared `BottomNavigationBar` shell without duplicating state.

### 5. Pagination Strategy
Infinite scroll is driven by a `ScrollController` listener that fires `loadMore()` when the user is within **200px** of the end of the list. The `NewsState` tracks `page`, `hasMore`, and `loadingMore` as separate fields to avoid double-fetches.

### 6. Favourites — Offline-First
Favourites are stored and retrieved directly from Hive (`favBox`). `FavNotifier` holds a `Set<String>` of saved article URLs in memory for O(1) lookups during list rendering. The full `Article` objects are persisted to Hive via `toJson()` / `fromJson()`.

---

## Getting Started

### Prerequisites
- Flutter 3.x (`flutter --version`)
- A valid [NewsAPI](https://newsapi.org/) key placed in `lib/network/api_endpoints.dart`

### Run
```bash
# Install dependencies
flutter pub get

# Run on a connected device / emulator
flutter run
```

### Build
```bash
flutter build apk --release
```

---

## API

Uses **NewsAPI** (`https://newsapi.org/v2`):

| Endpoint | Used For |
|---|---|
| `GET /top-headlines` | Category-based news feed with pagination |
| `GET /everything` | Full-text article search with pagination |

---

## Screens Overview

```
Splash → Login / Register / Forgot Password
                ↓ (on successful login)
         Bottom Nav Shell
         ├── Home      (category chips + infinite scroll feed)
         ├── Search    (API search + paginated results)
         └── Favourites (offline Hive-backed saved articles)
                ↓ (tap any card)
         Article Detail (full view + favourite toggle)
```

---

## Assignment Coverage Checklist

- [x] Clean, modern UI with deep-blue gradient theme
- [x] Scalable, feature-first folder structure
- [x] Riverpod (`StateNotifier`) state management throughout
- [x] Dio-based API integration (NewsAPI)
- [x] Hive local persistence for auth session & favourites
- [x] Proper loading states and error handling
- [x] Authentication flow with persisted login state
- [x] Category-based news feed
- [x] Pull-to-refresh
- [x] Infinite scroll pagination
- [x] Search with API filtering
- [x] Article detail screen
- [x] Save / unsave favourites (offline)
- [x] GoRouter with auth redirect guard
- [x] Null safety — Flutter 3+
- [x] Repository pattern with abstract interface

---

## Author

Built as part of the **Flutter Junior Developer Assignment** — *Mini News Intelligence App*.
