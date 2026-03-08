# StrainTracker — Database Schema

## Supabase Tables

### profiles
Extends Supabase auth.users automatically.

| Column | Type | Notes |
|--------|------|-------|
| id | uuid (PK) | References auth.users(id) |
| display_name | text | Optional |
| created_at | timestamptz | Default now() |
| updated_at | timestamptz | Default now() |

### products
| Column | Type | Notes |
|--------|------|-------|
| id | uuid (PK) | Default gen_random_uuid() |
| strain_name | text | NOT NULL |
| strain_type | text | CHECK: indica, sativa, hybrid |
| thc_pct | numeric(5,2) | Nullable |
| cbd_pct | numeric(5,2) | Nullable |
| terpenes | jsonb | Array of {name, pct} objects |
| producer | text | Nullable |
| batch_number | text | Nullable |
| lab_name | text | Nullable |
| source_url | text | COA link if scanned |
| is_seed_data | boolean | Default false |
| created_by | uuid | References profiles(id), nullable for seed data |
| created_at | timestamptz | Default now() |

### sessions
| Column | Type | Notes |
|--------|------|-------|
| id | uuid (PK) | Default gen_random_uuid() |
| user_id | uuid | References profiles(id), NOT NULL |
| product_id | uuid | References products(id), NOT NULL |
| consumption_method | text | CHECK: flower, pre-roll, vape, concentrate, edible, tincture, topical |
| started_at | timestamptz | Default now() |
| notification_sent_at | timestamptz | Nullable |
| logged_at | timestamptz | Nullable (set when effects logged) |
| created_at | timestamptz | Default now() |

### effects
| Column | Type | Notes |
|--------|------|-------|
| id | uuid (PK) | Default gen_random_uuid() |
| session_id | uuid | References sessions(id), NOT NULL, UNIQUE |
| mood_tags | text[] | Array of mood tag strings |
| body_tags | text[] | Array of body tag strings |
| context_tags | text[] | Array of context tag strings |
| star_rating | integer | CHECK: 1-5, NOT NULL |
| notes | text | Nullable |
| time_of_day | text | Nullable: morning, afternoon, evening, night |
| activity | text | Nullable |
| sleep_quality | text | Nullable: poor, fair, good, great |
| eaten_recently | boolean | Nullable |
| created_at | timestamptz | Default now() |

## Row Level Security (RLS)
All tables must have RLS enabled:
- **profiles**: Users can read/update only their own row
- **products**: All authenticated users can read; users can insert; seed data is public
- **sessions**: Users can CRUD only their own sessions
- **effects**: Users can CRUD only effects on their own sessions

## Effects Taxonomy (Tag Values)

### Mood Tags
Relaxed, Happy, Energized, Focused, Anxious, Sleepy, Creative, Giggly, Calm

### Body Tags
Body high, Head high, Pain relief, Hungry, Dry mouth, Tingly, Heavy

### Context Tags
Solo, Social, Working, Creative, Physical activity, Winding down

### Consumption Methods
Flower, Pre-roll, Vape, Concentrate, Edible, Tincture, Topical

## Seed Products (5 Mock Products)

```sql
INSERT INTO products (strain_name, strain_type, thc_pct, cbd_pct, terpenes, producer, batch_number, lab_name, is_seed_data) VALUES
('Blue Dream', 'hybrid', 24.3, 0.8, '[{"name":"Myrcene","pct":0.42},{"name":"Caryophyllene","pct":0.28},{"name":"Pinene","pct":0.15}]'::jsonb, 'Theory Wellness', 'BD-2026-0142', 'MCR Labs', true),
('Northern Lights', 'indica', 21.7, 1.2, '[{"name":"Myrcene","pct":0.55},{"name":"Linalool","pct":0.22},{"name":"Caryophyllene","pct":0.18}]'::jsonb, 'Fernway', 'NL-2026-0088', 'SC Labs', true),
('Green Crack', 'sativa', 22.1, 0.3, '[{"name":"Terpinolene","pct":0.48},{"name":"Myrcene","pct":0.31},{"name":"Ocimene","pct":0.12}]'::jsonb, 'Garden Remedies', 'GC-2026-0201', 'Confident Cannabis', true),
('Wedding Cake', 'hybrid', 27.5, 0.5, '[{"name":"Limonene","pct":0.38},{"name":"Caryophyllene","pct":0.35},{"name":"Linalool","pct":0.19}]'::jsonb, 'Insa', 'WC-2026-0067', 'MCR Labs', true),
('Granddaddy Purple', 'indica', 20.8, 0.9, '[{"name":"Myrcene","pct":0.61},{"name":"Pinene","pct":0.24},{"name":"Caryophyllene","pct":0.16}]'::jsonb, 'Sira Naturals', 'GDP-2026-0033', 'SC Labs', true);
```
