# StrainTracker

## Overview
A mobile-first web app for cannabis consumers to track how different products affect them. The core differentiator: scanning the QR code on Massachusetts cannabis packaging auto-populates product data from the certificate of analysis (COA), eliminating manual entry. Users log effects 30 minutes post-session via tappable tags and build a personal picture of what works for them over time.

## Tech Stack
- **Frontend**: React + Tailwind CSS (via Lovable)
- **Backend/Database**: Supabase (PostgreSQL + Auth + Edge Functions + Realtime)
- **Auth**: Supabase Auth (email/password, optional OAuth)
- **QR Scanning**: html5-qrcode library
- **Notifications**: Web Push API (via Supabase Edge Function for scheduling)
- **Hosting**: Lovable deploy (Netlify) + Supabase cloud

## Design Principles
- Dark mode default
- Minimum 44px tap targets
- No required text input anywhere in the core loop
- Single-thumb navigation
- **The user may be high — design accordingly**
- Mobile-first, large text, clear contrast

## Out of Scope (V1)
- Social features / public data sharing
- Strain recommendations engine
- Dispensary integrations
- Native iOS/Android app
