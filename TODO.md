# Ctrl+Shift+Date — Progress Tracker

## COMPLETED

### Phase 1: Core Data & Auth Bugs

- [x] **1.1 Events not saving per user** — Fixed `userId: ''` → now gets real user ID from Supabase auth before saving (`create_event_screen.dart`)

- [x] **1.2 Email registration flow** — Added display name field to sign-up form, calls backend `/auth/register` after Supabase signup to create user profile record (`sign_up_screen.dart`)

- [x] **1.3 Onboarding profile data** — Fixed `_EditProfileSheet` that had hardcoded `'John Doe'` / `'john@example.com'` — now reads from actual user data and saves via `authActionsProvider.updateProfile()` (`settings_screen.dart`)

- [x] **1.4 Delete account** — Added `DELETE /auth/account` backend endpoint that cascades deletion through all tables. Connected frontend settings delete button through `authActionsProvider.deleteAccount()` to call backend then clear local data (`auth.py`, `settings_screen.dart`, `auth_provider.dart`)

### Phase 2: UI & Theme Bugs

- [x] **2.1 Dark mode crash on toggle** — Replaced inline dark theme text styles with `AppTypography` constants + color overrides (consistent with light theme). Added missing dialog/chip/bottomSheet/tabBar themes for dark mode. Persisted theme mode to SharedPreferences via `ThemeModeNotifier` (`theme.dart`, `main.dart`, `settings_screen.dart`)

- [x] **2.2 Profile pic pixel overflow** — Fixed `_EditProfileSheet` avatar Stack with explicit `SizedBox(96x96)` constraints and proper `Positioned` offsets (`settings_screen.dart`)

### Phase 3: Social Features (partial)

- [x] **3.1 Fix adding friends** — Rewrote entire `FriendsScreen` from `StatefulWidget` with mock data → `ConsumerStatefulWidget` connected to real Riverpod providers (`friendshipsProvider`, `friendsProvider`, `pendingFriendRequestsProvider`, `outgoingFriendRequestsProvider`). All actions (send request, accept, decline, cancel, block, remove, poke) now call through `friendActionsProvider` to real API (`friends_screen.dart`)

---

## REMAINING

### Phase 3: Social Features (continued)

- [x] **3.2 Show streaks to friends** — Backend: add streak data to friends endpoint response. Frontend: add streak fields to Friendship model, display `StreakBadge` in `friend_tile.dart`
  - Files: `backend/app/routers/friends.py`, `frontend/lib/models/friendship.dart`, `frontend/lib/widgets/friend_tile.dart`

- [x] **3.3 Messaging** — Connect inbox screen to real providers, implement E2E encryption flow, real-time message delivery
  - Files: `frontend/lib/screens/inbox_screen.dart`, `frontend/lib/providers/inbox_provider.dart`, `backend/app/routers/inbox.py`

### Phase 4: Calendar & Events

- [x] **4.1 Fix recurring events** — Map UI recurrence options to RRULE strings, add `recurrenceRule` to Event model, pass to backend, build custom recurrence dialog
  - Files: `frontend/lib/screens/create_event_screen.dart`, `frontend/lib/models/event.dart`

- [x] **4.2 Fix CSV import** — Add import UI in settings, file picker for CSV/ICS, upload to `/import/csv`, replace fake onboarding calendar connections
  - Files: `frontend/lib/screens/settings_screen.dart`, `frontend/lib/services/api_service.dart`, `frontend/lib/screens/onboarding_screen.dart`

- [x] **4.3 Sharing events with friends** — Add share button on event detail, use backend `/sharing` router
  - Files: `frontend/lib/screens/event_detail_screen.dart`, `frontend/lib/providers/friends_provider.dart`

### Phase 5: Reflection & Productivity

- [x] **5.1 Reflection history hamburger menu** — Add hamburger icon with drawer/bottom sheet showing past reflections list with date, mood, productivity %
  - Files: `frontend/lib/screens/reflection_screen.dart`, new `reflection_history_screen.dart`

- [x] **5.2 Event completion confirmation** — Add done/skipped/partial toggle on events, calculate daily productivity score
  - Files: `frontend/lib/screens/day_view_screen.dart`, `frontend/lib/providers/events_provider.dart`

### Phase 6: AI Features

- [x] **6.1 AI schedule rearrangement** — Chatbot UI for rearranging unlocked events, connect to existing backend AI suggestions
- [x] **6.2 AI whitespace recommendations** — Detect empty blocks, query AI with user history, show recommendations

### Phase 7: Advanced Features

- [x] **7.1 Lock screen widget** — Uber-style countdown to event end (iOS WidgetKit / Android Glance)
- [x] **7.2 Dual calendar view** — Compare your calendar with a friend's side-by-side
- [x] **7.3 Weather per day** — Integrate weather API, show forecast on calendar days
- [x] **7.4 Polls for event planning** — Create polls for time/place, share with friends, aggregate votes
- [x] **7.5 Private events with invite links** — Privacy flag on events, invite link generation, accept/decline flow
