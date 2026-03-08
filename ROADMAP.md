# StrainTracker — Development Roadmap

## Phase 1: Foundation & Auth
**Goal**: User can sign up, log in, and see a skeleton app shell.

- [ ] Supabase project setup (database, auth, RLS policies)
- [ ] Run seed SQL for products table and 5 mock products
- [ ] App shell with dark mode, bottom tab navigation (Scan, Sessions, Insights, Profile)
- [ ] Sign up / Log in / Password reset screens (Supabase Auth)
- [ ] Protected routes (redirect to login if not authenticated)
- [ ] Profile page showing email and join date

**Lovable prompts**: Start with auth + dark layout + navigation shell.

---

## Phase 2: Product Scanning & Manual Entry
**Goal**: User can scan a QR code or manually pick a product.

- [ ] QR scanner screen using html5-qrcode
- [ ] Parse scanned URL → attempt to match/fetch COA data
- [ ] Fallback: show list of seed products for manual selection
- [ ] Product detail view (strain name, type, THC/CBD, terpene chips)
- [ ] Manual product entry form (for products not in database)
- [ ] COA parsing stubs for MCR Labs, SC Labs, Confident Cannabis URL formats

**Lovable prompts**: QR scanner page, product picker, product detail card.

---

## Phase 3: Session Creation & Notifications
**Goal**: User starts a session and gets a 30-min reminder to log effects.

- [ ] "Start Session" flow: select product → pick consumption method → confirm
- [ ] Session saved to database with started_at timestamp
- [ ] Web Push notification permission request (on first session)
- [ ] 30-minute delayed notification: "How are you feeling? Log your [strain] session"
- [ ] Notification tap opens effects logging for that session
- [ ] Active session indicator in app shell

**Lovable prompts**: Session creation wizard, push notification setup.

---

## Phase 4: Effects Logging
**Goal**: User logs how they feel with zero typing required.

- [ ] Tappable tag grids: mood tags, body tags, context tags (toggle on/off)
- [ ] Star rating (1-5) with large tap targets
- [ ] Optional free text note field
- [ ] Optional context fields (time of day, activity, sleep quality, eaten recently)
- [ ] Save effects linked to session, set logged_at timestamp
- [ ] Confirmation screen: "Session logged! ✓"

**Lovable prompts**: Tag grid components, star rating, effects logging form.

---

## Phase 5: Session Dashboard
**Goal**: User can browse and search their session history.

- [ ] Session list (newest first) with strain name, date, rating, top tags
- [ ] Search bar (by strain name)
- [ ] Filter chips: by strain type, effect tag, rating, consumption method
- [ ] Tap session → full detail view (product info + all logged effects)
- [ ] Empty state with CTA to start first session

**Lovable prompts**: Session list with search/filter, session detail view.

---

## Phase 6: Pattern Insights
**Goal**: User sees simple data patterns from their logged sessions.

- [ ] Top-rated strains (average star rating, min 2 sessions)
- [ ] Most common effects by strain type (indica vs sativa vs hybrid)
- [ ] Effects frequency by terpene profile (which terpenes correlate with which effects)
- [ ] Usage frequency chart (sessions per week/month)
- [ ] "You tend to rate [indicas] highest when [winding down]" style insight cards

**Lovable prompts**: Charts and insight cards on Insights tab.

---

## Phase 7: Polish & Launch
**Goal**: Production-ready, deployed, usable by real people.

- [ ] Loading states and error handling throughout
- [ ] Empty states for all screens
- [ ] PWA manifest + service worker for add-to-homescreen
- [ ] Responsive (works on tablet/desktop but optimized for phone)
- [ ] Performance pass (lazy loading, image optimization)
- [ ] Privacy policy page (required for cannabis data)
- [ ] Deploy: Lovable → production URL
- [ ] Custom domain setup (if desired)
