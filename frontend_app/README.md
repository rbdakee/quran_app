# Quran App — Frontend (Flutter)

## Current Status (2026-03-17)

Frontend scaffold is already implemented and connected around the backend contract.

Implemented:
- App bootstrap with `MaterialApp.router`
- Routing with `go_router`:
  - `/today`
  - `/progress`
  - `/reviews`
  - `/today/summary`
- State management with `flutter_riverpod`
- API layer (`api_client`, network error wrappers, repositories)
- Shared typed models (`freezed` + `json_serializable`)
- Feature modules:
  - `today`
  - `progress`
  - `reviews`
  - `summary`
  - `shell`
- Reusable UI widgets for lesson flow and state handling

## Project Structure

```text
lib/
  core/
    constants/
    network/
    router/
    theme/
  shared/
    models/
    widgets/
  features/
    today/
    progress/
    reviews/
    summary/
    shell/
  main.dart
```

## Next Focus

1. End-to-end UX polish for lesson flow (`today` -> `summary`)
2. Robust loading/error/empty states across all screens
3. Widget tests for key user journeys
4. Final API contract sanity pass against `frontend/API_ENDPOINTS.md`

## Run

```bash
cd frontend_app
flutter pub get
flutter run
```

For backend API, run server from project root:

```bash
python -m uvicorn api.main:app --reload --port 8000
```
