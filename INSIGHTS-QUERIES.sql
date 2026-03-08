-- StrainTracker — Insight Queries
-- Use these in Supabase client calls or Edge Functions

-- ============================================
-- Top-rated strains (min 2 sessions)
-- ============================================
SELECT
  p.strain_name,
  p.strain_type,
  ROUND(AVG(e.star_rating), 1) as avg_rating,
  COUNT(*) as session_count
FROM sessions s
JOIN products p ON p.id = s.product_id
JOIN effects e ON e.session_id = s.id
WHERE s.user_id = :user_id
GROUP BY p.id, p.strain_name, p.strain_type
HAVING COUNT(*) >= 2
ORDER BY avg_rating DESC
LIMIT 10;

-- ============================================
-- Most common effects by strain type
-- ============================================
SELECT
  p.strain_type,
  unnest(e.mood_tags) as tag,
  'mood' as category,
  COUNT(*) as frequency
FROM sessions s
JOIN products p ON p.id = s.product_id
JOIN effects e ON e.session_id = s.id
WHERE s.user_id = :user_id
GROUP BY p.strain_type, tag
ORDER BY p.strain_type, frequency DESC;

-- Same for body_tags
SELECT
  p.strain_type,
  unnest(e.body_tags) as tag,
  'body' as category,
  COUNT(*) as frequency
FROM sessions s
JOIN products p ON p.id = s.product_id
JOIN effects e ON e.session_id = s.id
WHERE s.user_id = :user_id
GROUP BY p.strain_type, tag
ORDER BY p.strain_type, frequency DESC;

-- ============================================
-- Usage frequency (sessions per week, last 8 weeks)
-- ============================================
SELECT
  date_trunc('week', s.started_at) as week_start,
  COUNT(*) as session_count
FROM sessions s
WHERE s.user_id = :user_id
  AND s.started_at >= now() - interval '8 weeks'
GROUP BY week_start
ORDER BY week_start;

-- ============================================
-- Terpene-effect correlations (highest-rated sessions)
-- ============================================
SELECT
  terpene->>'name' as terpene_name,
  ROUND(AVG(e.star_rating), 1) as avg_rating,
  array_agg(DISTINCT unnest_mood) as common_moods
FROM sessions s
JOIN products p ON p.id = s.product_id
JOIN effects e ON e.session_id = s.id,
  jsonb_array_elements(p.terpenes) as terpene,
  unnest(e.mood_tags) as unnest_mood
WHERE s.user_id = :user_id
GROUP BY terpene_name
ORDER BY avg_rating DESC;

-- ============================================
-- Quick stats
-- ============================================
SELECT
  COUNT(DISTINCT s.id) as total_sessions,
  ROUND(AVG(e.star_rating), 1) as avg_rating,
  (
    SELECT p.strain_name
    FROM sessions s2
    JOIN products p ON p.id = s2.product_id
    WHERE s2.user_id = :user_id
    GROUP BY p.strain_name
    ORDER BY COUNT(*) DESC
    LIMIT 1
  ) as favorite_strain,
  (
    SELECT unnest(e2.mood_tags)
    FROM sessions s2
    JOIN effects e2 ON e2.session_id = s2.id
    WHERE s2.user_id = :user_id
    GROUP BY unnest(e2.mood_tags)
    ORDER BY COUNT(*) DESC
    LIMIT 1
  ) as most_common_effect
FROM sessions s
JOIN effects e ON e.session_id = s.id
WHERE s.user_id = :user_id;
