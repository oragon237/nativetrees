-- 007_safety.sql — Phase 6: Safety & Operations (reports).
-- Per code-database.md §25.

CREATE TABLE IF NOT EXISTS reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  entity_type VARCHAR(60) NOT NULL CHECK (entity_type IN
    ('species', 'observation', 'identification_request', 'marketplace_listing', 'comment', 'user')),
  entity_id UUID NOT NULL,
  reason VARCHAR(40) NOT NULL CHECK (reason IN
    ('incorrect_information', 'incorrect_identification', 'suspicious_listing', 'spam',
     'inappropriate_content', 'misleading_seller', 'other')),
  description TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'open'
    CHECK (status IN ('open', 'in_review', 'resolved', 'dismissed')),
  assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
  resolution TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_reports_status ON reports (status);
CREATE INDEX IF NOT EXISTS idx_reports_entity ON reports (entity_type, entity_id);
