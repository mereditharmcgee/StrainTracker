-- StrainTracker Supabase Database Setup
-- Run this in the Supabase SQL Editor after creating your project

-- ============================================
-- 1. TABLES
-- ============================================

-- Profiles (extends Supabase auth.users)
CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id)
  VALUES (new.id);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Products
CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  strain_name text NOT NULL,
  strain_type text NOT NULL CHECK (strain_type IN ('indica', 'sativa', 'hybrid')),
  thc_pct numeric(5,2),
  cbd_pct numeric(5,2),
  terpenes jsonb DEFAULT '[]'::jsonb,
  producer text,
  batch_number text,
  lab_name text,
  source_url text,
  is_seed_data boolean DEFAULT false,
  created_by uuid REFERENCES profiles(id),
  created_at timestamptz DEFAULT now()
);

-- Sessions
CREATE TABLE sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id),
  consumption_method text NOT NULL CHECK (consumption_method IN (
    'flower', 'pre-roll', 'vape', 'concentrate', 'edible', 'tincture', 'topical'
  )),
  started_at timestamptz DEFAULT now(),
  notification_sent_at timestamptz,
  logged_at timestamptz,
  created_at timestamptz DEFAULT now()
);

-- Effects (one per session)
CREATE TABLE effects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL UNIQUE REFERENCES sessions(id) ON DELETE CASCADE,
  mood_tags text[] DEFAULT '{}',
  body_tags text[] DEFAULT '{}',
  context_tags text[] DEFAULT '{}',
  star_rating integer NOT NULL CHECK (star_rating >= 1 AND star_rating <= 5),
  notes text,
  time_of_day text CHECK (time_of_day IN ('morning', 'afternoon', 'evening', 'night')),
  activity text,
  sleep_quality text CHECK (sleep_quality IN ('poor', 'fair', 'good', 'great')),
  eaten_recently boolean,
  created_at timestamptz DEFAULT now()
);

-- ============================================
-- 2. INDEXES
-- ============================================

CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_product_id ON sessions(product_id);
CREATE INDEX idx_sessions_started_at ON sessions(started_at DESC);
CREATE INDEX idx_effects_session_id ON effects(session_id);
CREATE INDEX idx_products_strain_name ON products(strain_name);
CREATE INDEX idx_products_strain_type ON products(strain_type);

-- ============================================
-- 3. ROW LEVEL SECURITY
-- ============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE effects ENABLE ROW LEVEL SECURITY;

-- Profiles: users see/edit only their own
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Products: all authenticated users can read; users can insert their own
CREATE POLICY "Authenticated users can view all products"
  ON products FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert products"
  ON products FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by OR is_seed_data = true);

CREATE POLICY "Users can update own products"
  ON products FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by);

-- Sessions: users CRUD only their own
CREATE POLICY "Users can view own sessions"
  ON sessions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own sessions"
  ON sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sessions"
  ON sessions FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own sessions"
  ON sessions FOR DELETE
  USING (auth.uid() = user_id);

-- Effects: users CRUD only effects on their own sessions
CREATE POLICY "Users can view own effects"
  ON effects FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM sessions
      WHERE sessions.id = effects.session_id
      AND sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create effects on own sessions"
  ON effects FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM sessions
      WHERE sessions.id = effects.session_id
      AND sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own effects"
  ON effects FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM sessions
      WHERE sessions.id = effects.session_id
      AND sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own effects"
  ON effects FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM sessions
      WHERE sessions.id = effects.session_id
      AND sessions.user_id = auth.uid()
    )
  );

-- ============================================
-- 4. SEED DATA (5 Mock Products)
-- ============================================

INSERT INTO products (strain_name, strain_type, thc_pct, cbd_pct, terpenes, producer, batch_number, lab_name, is_seed_data) VALUES
(
  'Blue Dream', 'hybrid', 24.3, 0.8,
  '[{"name":"Myrcene","pct":0.42},{"name":"Caryophyllene","pct":0.28},{"name":"Pinene","pct":0.15}]'::jsonb,
  'Theory Wellness', 'BD-2026-0142', 'MCR Labs', true
),
(
  'Northern Lights', 'indica', 21.7, 1.2,
  '[{"name":"Myrcene","pct":0.55},{"name":"Linalool","pct":0.22},{"name":"Caryophyllene","pct":0.18}]'::jsonb,
  'Fernway', 'NL-2026-0088', 'SC Labs', true
),
(
  'Green Crack', 'sativa', 22.1, 0.3,
  '[{"name":"Terpinolene","pct":0.48},{"name":"Myrcene","pct":0.31},{"name":"Ocimene","pct":0.12}]'::jsonb,
  'Garden Remedies', 'GC-2026-0201', 'Confident Cannabis', true
),
(
  'Wedding Cake', 'hybrid', 27.5, 0.5,
  '[{"name":"Limonene","pct":0.38},{"name":"Caryophyllene","pct":0.35},{"name":"Linalool","pct":0.19}]'::jsonb,
  'Insa', 'WC-2026-0067', 'MCR Labs', true
),
(
  'Granddaddy Purple', 'indica', 20.8, 0.9,
  '[{"name":"Myrcene","pct":0.61},{"name":"Pinene","pct":0.24},{"name":"Caryophyllene","pct":0.16}]'::jsonb,
  'Sira Naturals', 'GDP-2026-0033', 'SC Labs', true
);
