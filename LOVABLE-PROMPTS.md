# StrainTracker — Lovable Prompt Sequence

Use these prompts in order in Lovable. Each builds on the previous. Review what Lovable generates after each one before moving to the next.

**Important**: Your Supabase database is already set up (tables, seed data, RLS policies). Tell Lovable NOT to recreate tables — just connect to what exists.

---

## Prompt 1: App Shell + Auth

```
I'm building StrainTracker, a mobile-first cannabis session tracking app. It's already connected to Supabase with tables set up (profiles, products, sessions, effects).

Start by creating a dark-themed app with these colors: background #0f0f0f, cards #1a1a1a, accent green #22c55e, text white and gray.

I need:
- Sign up, log in, and password reset pages using Supabase auth (email and password)
- After login, a bottom navigation bar with 4 tabs: Scan, Sessions, Insights, and Profile
- The Profile tab should show the user's email and when they joined
- If someone isn't logged in, redirect them to the login page

Make everything mobile-first with big tap targets. The user might be using this app while impaired, so keep it simple and easy to navigate with one thumb.
```

---

## Prompt 2: Product Browsing + QR Scanner

```
Skip database setup — my tables already exist in Supabase (products, sessions, effects). There are 5 seed products already loaded (Blue Dream, Northern Lights, Green Crack, Wedding Cake, Granddaddy Purple).

On the Scan tab, I need:
- A QR code scanner at the top of the page (use the html5-qrcode library). When something is scanned, just show a message "COA parsing coming soon" for now
- Below the scanner, a "Browse Products" button that shows all products from my Supabase products table
- Each product should show as a card with: strain name, type (indica/sativa/hybrid with color-coded badges — purple for indica, orange for sativa, green for hybrid), THC%, and CBD%
- An "Add Product" button that lets users enter a new strain manually (name, type, THC%, CBD%)
- Tapping a product card should start the session creation flow (next prompt)
```

---

## Prompt 3: Starting a Session

```
When a user taps a product from the Browse Products list, take them to a session creation screen:

- Show the selected product info at the top (strain name, type badge, THC/CBD)
- Below that, show big tappable buttons to pick how they're consuming it: Flower, Pre-roll, Vape, Concentrate, Edible, Tincture, or Topical. Only one can be selected at a time.
- A big green "Start Session" button at the bottom

When they tap Start Session:
- Save the session to the Supabase sessions table
- Show a confirmation message: "Session started! We'll check in with you in 30 minutes."
- Go to the Sessions tab where the new session appears at the top with a countdown timer showing how long until the 30-minute check-in
- The session card should have a "Log Effects" button that gets more prominent after 30 minutes

Also ask for notification permission so we can remind them to log effects after 30 minutes.
```

---

## Prompt 4: Logging Effects

```
When a user taps "Log Effects" on an active session, open the effects logging screen.

At the top show "How's [strain name] treating you?" with the strain type badge.

The screen should have:
- A 5-star rating with big tappable stars (this is the only required field)
- A "Mood" section with tappable pill buttons the user can toggle on/off (multi-select): Relaxed, Happy, Energized, Focused, Anxious, Sleepy, Creative, Giggly, Calm
- A "Body" section with the same style pills: Body high, Head high, Pain relief, Hungry, Dry mouth, Tingly, Heavy
- A "Context" section: Solo, Social, Working, Creative, Physical activity, Winding down
- A collapsible "Add more detail" section with: time of day (Morning/Afternoon/Evening/Night), sleep quality (Poor/Fair/Good/Great), eaten recently (Yes/No), and an optional notes text box

Green pills when selected, subtle outline when not. Big green Save button at the bottom.

When saved, store in the Supabase effects table, mark the session as logged, and show a quick success confirmation.

Remember: no required text input. The user might be high. Keep it all tappable.
```

---

## Prompt 5: Session History Dashboard

```
On the Sessions tab, build a session history dashboard:

- Search bar at the top to filter by strain name
- Scrollable filter chips below the search: All, Indica, Sativa, Hybrid, 4+ Stars, This Week
- Session cards listed newest first, each showing: strain name, type badge, date, how they consumed it, star rating, and the top 3 effect tags as small pills
- Tapping a session card opens a detail view with: full product info (strain, type, THC, CBD, terpenes), session info (method, date, how long between start and log), all the effects they logged organized by mood/body/context, their rating, and any notes

If the user has no sessions yet, show a friendly empty state that says something like "No sessions yet — scan a product to get started" with a button to the Scan tab.

Dark cards with subtle borders, good spacing between them.
```

---

## Prompt 6: Insights Dashboard

```
On the Insights tab, show the user patterns from their session data:

- "Quick Stats" card at top: total sessions, favorite strain (most logged), most common effect, average rating
- "Your Top Strains" — a ranked list or bar chart showing strains by average rating (only show strains with at least 2 sessions)
- "Effects by Type" — show the most common mood and body effects for indica vs sativa vs hybrid sessions
- "Usage Over Time" — a simple bar chart of sessions per week for the last 8 weeks
- "Terpene Patterns" — which terpenes are in their highest-rated sessions

If they have fewer than 3 sessions, show an encouraging message like "Log a few more sessions to unlock your insights!"

Use charts with the dark theme and green accent color. Make it feel like a personal cannabis journal coming to life.
```

---

## Prompt 7: Polish + PWA

```
Final polish:

- Add loading skeleton animations for any screen that fetches data
- Add error states with retry buttons if something fails to load
- Make it installable as a PWA (add-to-homescreen) with app name "StrainTracker", dark theme colors
- Add a simple privacy policy page accessible from the Profile tab
- Make sure everything works nicely on both phone and tablet sizes
- Add smooth transitions between pages
- Make sure all buttons and interactive elements have clear pressed/active states
```

---

## Tips for Working with Lovable

- **One prompt at a time** — paste one, review what it builds, then continue
- **Don't recreate the database** — your tables are already in Supabase from the SQL setup. If Lovable tries to create new tables, tell it to use the existing ones
- **Iterate** — if something looks off, describe what to change conversationally ("make the cards bigger", "the scanner should be at the top")
- **QR scanner** — Lovable may need help with the html5-qrcode library. If it struggles, tell it to just show the product browser first and add scanning later
- **Notifications** — Web Push is complex. If Lovable can't do the 30-min notification easily, skip it and add a simple in-app timer countdown instead
