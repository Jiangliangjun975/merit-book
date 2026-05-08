-- ============================================
-- 功德簿 Supabase 建表 SQL
-- 在 Supabase 的 SQL Editor 中运行此脚本
-- ============================================

-- 1. 创建规则表
CREATE TABLE IF NOT EXISTS rules (
  id BIGSERIAL PRIMARY KEY,
  rule_id TEXT UNIQUE NOT NULL,
  label TEXT NOT NULL,
  score INTEGER NOT NULL DEFAULT 0,
  type TEXT NOT NULL CHECK (type IN ('add', 'sub', 'danger')),
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. 创建记录表
CREATE TABLE IF NOT EXISTS records (
  id BIGSERIAL PRIMARY KEY,
  person TEXT NOT NULL CHECK (person IN ('leida', 'liangjun')),
  rule_id TEXT NOT NULL,
  label TEXT NOT NULL,
  score INTEGER NOT NULL DEFAULT 0,
  type TEXT NOT NULL CHECK (type IN ('add', 'sub', 'danger')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. 创建索引（加速查询）
CREATE INDEX IF NOT EXISTS idx_records_person ON records(person);
CREATE INDEX IF NOT EXISTS idx_records_created_at ON records(created_at);
CREATE INDEX IF NOT EXISTS idx_rules_type ON rules(type);

-- 4. 开启 Realtime（实时同步必须）
ALTER PUBLICATION supabase_realtime ADD TABLE rules;
ALTER PUBLICATION supabase_realtime ADD TABLE records;

-- 5. 设置 RLS（Row Level Security）- 允许匿名读写
-- 注意：因为是双人私用，这里简化为允许所有 anon 用户读写
ALTER TABLE rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE records ENABLE ROW LEVEL SECURITY;

-- 规则表策略
CREATE POLICY "Allow all access to rules" ON rules
  FOR ALL USING (true) WITH CHECK (true);

-- 记录表策略
CREATE POLICY "Allow all access to records" ON records
  FOR ALL USING (true) WITH CHECK (true);
