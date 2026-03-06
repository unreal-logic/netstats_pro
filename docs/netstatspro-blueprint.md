# Complete Blueprint — Netstatspro SaaS

This document is the authoritative blueprint for the product: pages, actions, data, domain rules, schema surface, APIs, UX patterns, user stories, acceptance criteria, roadmap, MVP backlog, testing and rollout guidance. It consolidates the netball formats and rule nuances you provided (SSN, SN Reserves, FAST5, Indoor 6s/7s, NetSetGO, futureFERNS) and the SaaS platform requirements for multi‑organisation support.

## Product Summary and Core Principles
- **Product Focus** — Mobile-first & Tablet-optimized SaaS application for multi‑tenant netball statistics, live scoring, ruleset engine, analytics, competition management and billing.
- **Tenancy model** — Users may belong to multiple organisations; players are organisation‑wide.
- **Rules model** — Immutable `ruleset_version` per game; rules engine validates every event and logs decisions.
- **Event model** — `game_events` is the canonical event stream; analytics are derived by replay/aggregation.
- **Offline** — Local queue + deterministic server reconciliation; conflict resolution UI for scorers.
- **Primary users** — Scorers, Coaches, Club Admins, Match Delegates/HTOM/CM, Analysts, Super Admin.

## Full Page Inventory (UI Surface) and Actions

### Global / Shell
- **Organisation switcher** — switch active organisation; quick-create shortcuts.
- **Top nav** — Dashboard, Games, Players, Teams, Competitions, Venues, Analytics, Members, Billing, Rulesets, Admin, Help.

### Dashboard (Organisation)
- **Actions** — View upcoming fixtures; quick-create game/team/player; filter by competition/date/team.
- **Data** — upcoming games, recent results, team highlights, player highlights, alerts.

### Games
- **Game list** — filter by competition, date, status.
- **Game wizard** — select ruleset/version; choose venue; choose competition; add teams; pick players from organisation pool; set period config; confirm court layout.
- **Live scoring** — timer controls; score controls; tappable court; event buttons; substitutions; undo/redo; quarter controls; power play/super shot indicators.
- **Event history** — chronological log; filter by player/team/event type; edit/delete events (with audit).
- **Post‑game review** — finalise match; run RTRR; generate match report (PDF); replay events.
- **Data** — game metadata, `ruleset_version_id`, event stream, lineups, score timeline, `rules_engine_logs`.

### Teams
- **Team list & profile** — roster, colours, logo, season stats, historical lineups.
- **Actions** — CRUD, add/remove players, assign coach, export roster.
- **Data** — team metadata, `team_players`, team stats.

### Players
- **Player list & profile** — bio, photo, DOB, preferred positions, organisation history, match history, aggregated stats.
- **Actions** — CRUD, assign to teams, mark availability, upload photo.
- **Data** — player profile, team memberships, `player_match_stats`.

### Competitions
- **Competition list & profile** — fixtures, ladder, standings, ruleset association.
- **Actions** — CRUD, add/remove teams, generate fixtures, set points system.
- **Data** — competition metadata, fixtures, standings.

### Venues
- **Venue list & profile** — address, indoor/outdoor, court layouts, run‑off, line width.
- **Actions** — CRUD, add court layout, attach images.
- **Data** — venue metadata, `court_layouts`.

### Rulesets (Admin for organisation)
- **Ruleset list & versioning** — create ruleset, publish version, import from templates (SSN, FAST5, Indoor, Junior).
- **Ruleset editor** — `period_config`, `scoring_zones` (draw polygon), `position_constraints`, features (`super_shot`, `power_play`, `rolling_subs`), `rotation_policies`.
- **Actions** — create/version, preview court overlay, simulate events.
- **Data** — `rulesets`, `ruleset_versions`, `scoring_zones`.

### Analytics
- **Dashboards** — organisation, competition, team, player.
- **Reports** — Super Shot, Power Play, Fast5 distribution, rotation compliance, net interactions.
- **Exports** — CSV/JSON raw events, PDF match reports.
- **Data** — aggregated tables, heatmaps (geojson), derived metrics.

### Members & Roles
- **Members list** — invite, resend invite, remove.
- **Roles UI** — assign Owner/Admin/Coach/Scorer/Analyst/Viewer/Match Delegate.
- **Actions** — role management, membership audit.
- **Data** — `organisation_members`, role permissions.

### Billing & Subscription
- **Subscription page** — plan, usage, upgrade/downgrade, cancel.
- **Payment methods** — add/update card, billing contact.
- **Invoices** — list, download, payment history.
- **Data** — `organisation_subscriptions`, invoices, usage metrics.

### Super Admin (SaaS owner)
- **Tenant management** — view organisations, suspend/restore, usage, revenue.
- **System settings** — feature flags, email templates, global ruleset templates.
- **Support tools** — impersonate tenant (read-only), force password reset, view audit logs.

### Support & Help
- **Knowledge base** — articles for scorers, coaches, admins.
- **Ticketing** — submit ticket, view status.
- **System status** — uptime, incidents.

## Data Model Highlights (Tables and Relationships)
- **Core:** `users`, `organisations`, `organisation_members`.
- **Domain:** `players` (`organisation_id`), `teams`, `team_players`, `competitions`, `competition_teams`, `venues`, `games` (`ruleset_version_id`), `game_players`, `game_events` (coordinates, `zone_id`, `points_awarded`, `metadata_json`).
- **Rules:** `rulesets`, `ruleset_versions`, `period_configs`, `scoring_zones` (geojson), `position_constraints`, `ruleset_features`, `rotation_policies`, `court_layouts`.
- **Analytics:** `player_match_stats`, `team_match_stats`, `competition_standings`.
- **Operational:** `audit_logs`, `notifications`, `files`, `rules_engine_logs`, `rtrr_reviews`.
- **Tenancy:** every domain table includes `organisation_id` for logical isolation.

## Rules Engine Specification (Functional)
- **Function** — `decision = rules_engine(event, game_state, ruleset_version)` (pure, deterministic).
- **Validations** — position constraints (offside), shot zone mapping (distance → `scoring_zones`), time window checks (Super Shot / Power Play), substitution rules, team size, release vs through‑ring edge cases, inclusive/exclusive line rules.
- **Outputs** — `valid` flag, `points_awarded`, `zone_id`, `decision_log_id`.
- **Audit** — every decision stored in `rules_engine_logs`; overrides require user role and reason.
- **Replayable** — event stream replay must reproduce identical decisions for same `ruleset_version`.

## Event Model and Analytics Mapping
- **Event attributes** — `event_type`, `player_id`, `team_id`, coordinates, `release_timestamp`, `quarter_number`, `metadata_json`.
- **Shot event** — must include `shot_distance_m`, `zone_id`, `is_super_shot_candidate`, `is_power_play`, `points_awarded`.
- **Derived metrics** — GAG%, CP%, Super Shot accuracy, Power Play yield, Feed Efficiency, Rotation Compliance Score, Net Interaction Rate.
- **Spatial** — store coordinates as floats and GeoJSON for heatmaps.

## API Surface (Representative)
- **POST** `/api/v1/organisations` — create organisation.
- **POST** `/api/v1/games` — create game with `ruleset_version_id`.
- **POST** `/api/v1/games/{id}/events` — submit event; returns `points_awarded`, `rules_engine_log_id`.
- **GET** `/api/v1/games/{id}/events` — event timeline.
- **GET** `/api/v1/analytics/player/{id}` — player metrics (ruleset-aware).
- **POST** `/api/v1/rulesets/{id}/simulate` — simulate event stream.
- **Auth** — JWT with tenant scoping; RBAC enforced.

## Wireframe & UX Patterns (Key Screens)
- **Game Wizard** — stepper: Ruleset → Venue → Competition → Teams → Players → Confirm. Ruleset step shows templates (SSN, SN Reserves, FAST5, Indoor, Junior).
- **Live Scoring** — large tappable court, dynamic event buttons, top bar with ruleset and timers, bottom quick actions (undo, review). Power Play/Super Shot visual countdown.
- **Match Review** — event list with `rules_engine_decision` badges, edit modal with audit trail, override button for authorised roles.
- **Ruleset Editor** — visual zone drawing, numeric period config, toggle features, preview court overlay.

## User Stories (Exemplar, Ready for Backlog)
- **Create organisation** — Owner can create organisation and invite members.
- **Create game with ruleset** — Scorer can create a game and select SSN ruleset; Super Shot windows are enforced.
- **Record Super Shot** — Scorer records a shot in Super Shot window; system awards 2 points and logs decision.
- **Fast5 power play** — Scorer marks Power Play active; points doubled for that quarter for that team.
- **Rotation report** — Coach runs NetSetGO rotation report and receives compliance warnings.
- **RTRR** — Match Delegate opens RTRR, attaches evidence, records verdict; match result updated.

## Acceptance Criteria (Examples)
- **Game creation** — game saved with `ruleset_version_id` and UI reflects period lengths.
- **Event validation** — submitting a Super Shot during non‑Super Shot window returns `valid=false` and a `rules_engine_log` entry.
- **Offline sync** — events queued offline sync to server and server returns consistent `points_awarded` for 99.5% of test runs.
- **Audit** — any override creates `audit_logs` with user, reason, timestamp.

## Roadmap and MVP Backlog (Phased)

### MVP (0–3 months)
- Multi‑tenant core, players/teams/competitions, game wizard, live scoring for SSN & SN Reserves (Super Shot, period config), event store, basic player/team analytics, organisation roles, Stripe billing, basic dashboard.

### V1 (3–6 months)
- Ruleset admin/versioning, Fast5 support (power play, 3‑point zones), Indoor 6s/7s support, junior rotation policies, match review & RTRR, PDF match reports, offline sync.

### V2 (6–12 months)
- Advanced spatial analytics (heatmaps, feed→goal flow), API & webhooks, fixture generation, enterprise features (usage dashboards, SLAs), cross‑organisation competitions.

## Testing, QA and Validation Plan
- **Rules engine unit tests** — exhaustive cases per `ruleset_version` (edge cases: release vs through‑ring, line inclusive).
- **Event replay tests** — deterministic replay must match live aggregates.
- **Performance tests** — simulate pro match event rates and offline sync bursts.
- **Pilot program** — staged pilots with 3 clubs (solo team, small club, large association) for UX and offline validation.
- **Acceptance testing** — UAT with scorers and match delegates for RTRR and override flows.

## Monitoring, Support and Operational Readiness
- **Monitoring** — event ingestion rate, sync failures, error rates, uptime.
- **Support** — knowledge base, in‑app ticketing, match‑day escalation path.
- **Backups & retention** — nightly backups; retention configurable per organisation.
- **SLA** — define for enterprise customers (uptime, response times).

## Pricing Model (High Level)
- **Free tier** — single team, limited games/month, basic analytics.
- **Solo Team** — 1 team, X players, Y games, core features.
- **Club** — up to 10 teams, advanced analytics, offline sync.
- **Association / Enterprise** — unlimited teams, API access, dedicated support, custom SLA.

## Implementation Team and Timeline (Recommended)
- **Core team** — Product Manager, Tech Lead, Backend (2), Frontend (2), Mobile (1), QA (1), DevOps (1), UX (1), Data Engineer (1).
- **Sprints** — 2‑week sprints; MVP in ~6 sprints with pilot rollout in sprint 7–8.

## Technical Architecture (Mobile App)
- **State Management** — BLoC (Business Logic Component). Strict separation of logic and presentation. Use of `Cubit` for simple state and `Bloc` for complex event-driven areas (e.g. `LiveMatchBloc`).
- **Local Database** — Drift (SQLite). Used for robust offline-first architecture, storing games, lineups, and queued events. Selected over Isar for stable relationship mapping and LTS support.
- **UI & Navigation** — Material 3 Adaptive Form Factors. Uses `NavigationBar` on mobile devices (<600px viewport) and dynamically adapts to a side-anchored `NavigationRail` on larger tablet/desktop form factors.
- **Clean Architecture Principles** — Domain layer relies heavily on isolated Use Cases (e.g., `GetMatchSummaryUseCase`, `GetLiveMatchUseCase`) to retrieve and aggregate repository data deterministically.

## Design System (`lib/core/design_system/`)

The application ships a complete, standalone design system installed under `lib/core/design_system/`. Import the single barrel file to access all tokens, theme, and widgets:

```dart
import 'package:netstats_pro/core/design_system/design_system.dart';
```

### Structure

| Path | Contents |
|------|----------|
| `tokens/app_colors.dart` | `AppColors` — brand, semantic (success/warning/error/info), full slate-neutral palette, dark/light surface pairs, primary-tinted surfaces |
| `tokens/app_typography.dart` | `AppTypography` — full M3 TypeScale using **Inter** (google_fonts); ships a `TextTheme` factory getter |
| `tokens/app_spacing.dart` | `AppSpacing` (8px grid, EdgeInsets helpers, SizedBox gaps) · `AppRadius` (border radius constants + helpers) · `AppElevation` (elevation levels, BoxShadow presets) |
| `theme/app_theme.dart` | `AppTheme.light` / `AppTheme.dark` — fully-explicit `ColorScheme` + all component themes |
| `widgets/buttons/app_button.dart` | `AppButton` (5 variants × 3 sizes) · `AppIconButton` |
| `widgets/app_widgets.dart` | `AppCard` · `RadioTile` · `ProgressDots` · `AppChip` · `AppBadge` · `AppDropdownTile` |

### Color Palette
- **Primary** — Blue-500 (`#3B82F6`) for brand actions
- **Neutrals** — Full Slate palette (50–950) for surfaces and text
- **Semantic** — Green success, Amber warning, Red error, Cyan info

### Compatibility Shims
`lib/core/theme/` re-exports the design system so all existing import paths remain valid:
- `core/theme/app_theme.dart` → re-exports `AppTheme`
- `core/theme/colors.dart` → re-exports `AppColors`; alias `NetStatsColors` retained for backward compat
- `core/theme/typography.dart` → re-exports `AppTypography`

