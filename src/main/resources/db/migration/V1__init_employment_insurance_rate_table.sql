-- ===========================================
-- 2025年度雇用保险费率表
-- 用于雇用保险的计算
-- 令和7(2025)年度 雇用保険料率のご案内
-- ===========================================

-- 创建雇用保险费率表
CREATE TABLE employment_insurance_rate (
    id BIGSERIAL PRIMARY KEY,
    business_type VARCHAR(50) NOT NULL UNIQUE,
    employee_rate NUMERIC(10, 4) NOT NULL,
    employer_unemployment_rate NUMERIC(10, 4) NOT NULL,
    employer_two_programs_rate NUMERIC(10, 4) NOT NULL,
    total_rate NUMERIC(10, 4) NOT NULL,
    effective_from_date DATE NOT NULL,
    effective_to_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 添加表注释
COMMENT ON TABLE employment_insurance_rate IS '2025年度雇用保险费率表，用于雇用保险的计算';
COMMENT ON COLUMN employment_insurance_rate.business_type IS '事业类型';
COMMENT ON COLUMN employment_insurance_rate.employee_rate IS '劳动者负担费率（失业等给付・育児休業给付的保险费率）';
COMMENT ON COLUMN employment_insurance_rate.employer_unemployment_rate IS '事业主负担费率（失业等给付・育児休業给付的保险费率）';
COMMENT ON COLUMN employment_insurance_rate.employer_two_programs_rate IS '雇用保险二事业的保险费率（仅事业主负担）';
COMMENT ON COLUMN employment_insurance_rate.total_rate IS '合计保险费率';
COMMENT ON COLUMN employment_insurance_rate.effective_from_date IS '生效开始日期';
COMMENT ON COLUMN employment_insurance_rate.effective_to_date IS '生效结束日期';

-- 创建索引
CREATE INDEX idx_employment_insurance_rate_business_type ON employment_insurance_rate(business_type);
CREATE INDEX idx_employment_insurance_rate_dates ON employment_insurance_rate(effective_from_date, effective_to_date);

-- 插入2025年度雇用保险费率数据
-- 适用期间：令和7(2025)年4月1日から令和8（2026）年3月31日まで
INSERT INTO employment_insurance_rate (
    business_type,
    employee_rate,
    employer_unemployment_rate,
    employer_two_programs_rate,
    total_rate,
    effective_from_date,
    effective_to_date
) VALUES
-- 一般的事业
-- 劳动者负担: 5.5/1000, 事业主负担(失业等给付): 5.5/1000, 事业主负担(二事业): 3.5/1000, 合计: 14.5/1000
(
    '一般の事業',
    0.0055,
    0.0055,
    0.0035,
    0.0145,
    '2025-04-01',
    '2026-03-31'
),
-- 农林水産・清酒制造的事业
-- 劳动者负担: 6.5/1000, 事业主负担(失业等给付): 6.5/1000, 事业主负担(二事业): 3.5/1000, 合计: 16.5/1000
(
    '農林水産・清酒製造の事業',
    0.0065,
    0.0065,
    0.0035,
    0.0165,
    '2025-04-01',
    '2026-03-31'
),
-- 建设的事业
-- 劳动者负担: 6.5/1000, 事业主负担(失业等给付): 6.5/1000, 事业主负担(二事业): 4.5/1000, 合计: 17.5/1000
(
    '建設の事業',
    0.0065,
    0.0065,
    0.0045,
    0.0175,
    '2025-04-01',
    '2026-03-31'
);

-- 创建触发器函数，用于自动更新 updated_at 字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 创建触发器
CREATE TRIGGER update_employment_insurance_rate_updated_at
    BEFORE UPDATE ON employment_insurance_rate
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

