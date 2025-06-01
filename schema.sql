-- ============================================
-- LINKBIO PLATFORM DATABASE SCHEMA
-- Supabase PostgreSQL Database
-- Created: June 2025
-- ============================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- REFERENCE TABLES (Static Data)
-- ============================================

-- Available niches for content creators
CREATE TABLE niches (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO niches (name, slug, description) VALUES
('Fashion & Beauty', 'fashion-beauty', 'Fashion, makeup, skincare, and beauty content'),
('Food & Cooking', 'food-cooking', 'Recipe, restaurant reviews, and culinary content'),
('Travel & Lifestyle', 'travel-lifestyle', 'Travel guides, lifestyle tips, and experiences'),
('Technology', 'technology', 'Tech reviews, tutorials, and industry news'),
('Gaming', 'gaming', 'Game reviews, streaming, and gaming culture'),
('Fitness & Health', 'fitness-health', 'Workout routines, nutrition, and wellness'),
('Education', 'education', 'Educational content and tutorials'),
('Entertainment', 'entertainment', 'Movies, music, and general entertainment'),
('Business & Finance', 'business-finance', 'Business tips, investing, and financial advice'),
('Art & Design', 'art-design', 'Creative content, design tutorials, and artwork');

-- Business categories for brands
CREATE TABLE business_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO business_categories (name, slug, description) VALUES
('Fashion & Apparel', 'fashion-apparel', 'Clothing, accessories, and fashion brands'),
('Food & Beverage', 'food-beverage', 'Restaurants, cafes, and food products'),
('Technology', 'technology', 'Software, hardware, and tech services'),
('Health & Wellness', 'health-wellness', 'Healthcare, fitness, and wellness services'),
('Education & Training', 'education-training', 'Educational institutions and training services'),
('Entertainment', 'entertainment', 'Entertainment venues and services'),
('Retail & E-commerce', 'retail-ecommerce', 'Online and offline retail stores'),
('Professional Services', 'professional-services', 'Consulting, legal, and business services'),
('Beauty & Personal Care', 'beauty-personal-care', 'Cosmetics, skincare, and personal care'),
('Home & Garden', 'home-garden', 'Home improvement and gardening services');

-- Available locations (cities)
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    country VARCHAR(100) DEFAULT 'Indonesia',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(city, province, country)
);

INSERT INTO locations (city, province) VALUES
('Surabaya', 'Jawa Timur'),
('Gresik', 'Jawa Timur'),
('Sidoarjo', 'Jawa Timur'),
('Jakarta', 'DKI Jakarta'),
('Bandung', 'Jawa Barat'),
('Yogyakarta', 'DI Yogyakarta'),
('Semarang', 'Jawa Tengah'),
('Medan', 'Sumatera Utara'),
('Makassar', 'Sulawesi Selatan'),
('Denpasar', 'Bali');

-- Social media platforms
CREATE TABLE social_platforms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(50) NOT NULL UNIQUE,
    base_url VARCHAR(255) NOT NULL,
    icon_class VARCHAR(100), -- for CSS icon classes
    color_primary VARCHAR(7), -- hex color code
    is_active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO social_platforms (name, slug, base_url, icon_class, color_primary, display_order) VALUES
('Instagram', 'instagram', 'https://instagram.com/', 'instagram', '#E4405F', 1),
('TikTok', 'tiktok', 'https://tiktok.com/@', 'tiktok', '#000000', 2),
('Facebook', 'facebook', 'https://facebook.com/', 'facebook', '#1877F2', 3),
('Twitter', 'twitter', 'https://twitter.com/', 'twitter', '#1DA1F2', 4),
('YouTube', 'youtube', 'https://youtube.com/', 'youtube', '#FF0000', 5),
('Discord', 'discord', 'https://discord.gg/', 'discord', '#5865F2', 6);

-- ============================================
-- USER PROFILES & AUTHENTICATION
-- ============================================

-- User profiles (extends Supabase auth.users)
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('content_creator', 'brand', 'admin')),
    email VARCHAR(255) NOT NULL,
    
    -- Profile content
    bio TEXT,
    tagline VARCHAR(200), -- only for content creators
    profile_image_url TEXT,
    is_age_hidden BOOLEAN DEFAULT false,
    date_of_birth DATE,
    
    -- Location
    location_id INTEGER REFERENCES locations(id) ON DELETE SET NULL,
    
    -- Content creator specific
    niche_ids INTEGER[] DEFAULT '{}', -- array of niche IDs
    
    -- Brand specific  
    business_category_id INTEGER REFERENCES business_categories(id) ON DELETE SET NULL,
    
    -- Profile status
    is_profile_complete BOOLEAN DEFAULT false,
    is_public BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    
    -- Premium features
    subscription_tier VARCHAR(20) DEFAULT 'free' CHECK (subscription_tier IN ('free', 'pro', 'business')),
    subscription_expires_at TIMESTAMP WITH TIME ZONE,
    
    -- SEO
    meta_title VARCHAR(60),
    meta_description VARCHAR(160),
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_active_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_profiles_username ON profiles(username);
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_is_public ON profiles(is_public, is_active);
CREATE INDEX idx_profiles_location ON profiles(location_id);
CREATE INDEX idx_profiles_subscription ON profiles(subscription_tier, subscription_expires_at);

-- ============================================
-- SOCIAL LINKS MANAGEMENT
-- ============================================

CREATE TABLE social_links (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    platform_id INTEGER NOT NULL REFERENCES social_platforms(id) ON DELETE CASCADE,
    username VARCHAR(255) NOT NULL,
    full_url TEXT NOT NULL,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(profile_id, platform_id)
);

CREATE INDEX idx_social_links_profile ON social_links(profile_id);
CREATE INDEX idx_social_links_active ON social_links(profile_id, is_active, display_order);

-- ============================================
-- CUSTOM LINKS MANAGEMENT
-- ============================================

CREATE TABLE custom_links (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    url TEXT NOT NULL,
    logo_url TEXT, -- optional custom logo
    thumbnail_url TEXT, -- auto-generated or uploaded
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    
    -- Click tracking
    total_clicks INTEGER DEFAULT 0,
    last_clicked_at TIMESTAMP WITH TIME ZONE,
    
    -- Scheduling (premium feature)
    scheduled_start TIMESTAMP WITH TIME ZONE,
    scheduled_end TIMESTAMP WITH TIME ZONE,
    is_scheduled BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_custom_links_profile ON custom_links(profile_id);
CREATE INDEX idx_custom_links_active ON custom_links(profile_id, is_active, display_order);
CREATE INDEX idx_custom_links_scheduled ON custom_links(is_scheduled, scheduled_start, scheduled_end);

-- ============================================
-- ANALYTICS & TRACKING
-- ============================================

-- Analytics events for detailed tracking
CREATE TABLE analytics_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    link_id UUID, -- can be social_links.id or custom_links.id
    link_type VARCHAR(20) NOT NULL CHECK (link_type IN ('social', 'custom', 'profile_view')),
    event_type VARCHAR(20) NOT NULL CHECK (event_type IN ('click', 'view', 'share')),
    
    -- Visitor information
    visitor_id VARCHAR(100), -- anonymous tracking ID
    ip_address INET,
    user_agent TEXT,
    referer TEXT,
    
    -- Geographic info
    country VARCHAR(100),
    city VARCHAR(100),
    
    -- Device info
    device_type VARCHAR(20), -- mobile, tablet, desktop
    browser VARCHAR(50),
    os VARCHAR(50),
    
    -- Timestamp
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Partitioning for better performance (monthly partitions)
CREATE INDEX idx_analytics_events_profile_date ON analytics_events(profile_id, created_at);
CREATE INDEX idx_analytics_events_link ON analytics_events(link_id, link_type);
CREATE INDEX idx_analytics_events_visitor ON analytics_events(visitor_id);

-- Daily analytics summary (for faster reporting)
CREATE TABLE analytics_daily (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    
    -- Aggregated data
    total_profile_views INTEGER DEFAULT 0,
    total_link_clicks INTEGER DEFAULT 0,
    total_social_clicks INTEGER DEFAULT 0,
    total_custom_clicks INTEGER DEFAULT 0,
    unique_visitors INTEGER DEFAULT 0,
    
    -- Top performing links
    top_link_id UUID,
    top_link_clicks INTEGER DEFAULT 0,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(profile_id, date)
);

CREATE INDEX idx_analytics_daily_profile_date ON analytics_daily(profile_id, date);

-- ============================================
-- SUBSCRIPTION & BILLING (Future)
-- ============================================

CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    tier VARCHAR(20) NOT NULL CHECK (tier IN ('pro', 'business')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'cancelled', 'expired', 'paused')),
    
    -- Billing
    amount_monthly DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    billing_cycle VARCHAR(20) DEFAULT 'monthly' CHECK (billing_cycle IN ('monthly', 'yearly')),
    
    -- Subscription period
    starts_at TIMESTAMP WITH TIME ZONE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    
    -- Payment info
    stripe_customer_id VARCHAR(255),
    stripe_subscription_id VARCHAR(255),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_subscriptions_profile ON subscriptions(profile_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status, expires_at);

-- ============================================
-- ADMIN & MODERATION
-- ============================================

-- Admin action logs
CREATE TABLE admin_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_id UUID NOT NULL REFERENCES profiles(id),
    action VARCHAR(100) NOT NULL,
    target_type VARCHAR(50), -- profiles, social_links, etc.
    target_id UUID,
    details JSONB,
    ip_address INET,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_admin_logs_admin ON admin_logs(admin_id, created_at);
CREATE INDEX idx_admin_logs_target ON admin_logs(target_type, target_id);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE custom_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_daily ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view public profiles" ON profiles
    FOR SELECT USING (is_public = true AND is_active = true);

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Social links policies
CREATE POLICY "Users can manage own social links" ON social_links
    FOR ALL USING (profile_id = auth.uid());

CREATE POLICY "Public can view active social links" ON social_links
    FOR SELECT USING (
        is_active = true AND 
        profile_id IN (
            SELECT id FROM profiles 
            WHERE is_public = true AND is_active = true
        )
    );

-- Custom links policies
CREATE POLICY "Users can manage own custom links" ON custom_links
    FOR ALL USING (profile_id = auth.uid());

CREATE POLICY "Public can view active custom links" ON custom_links
    FOR SELECT USING (
        is_active = true AND 
        profile_id IN (
            SELECT id FROM profiles 
            WHERE is_public = true AND is_active = true
        )
    );

-- Analytics policies
CREATE POLICY "Users can view own analytics" ON analytics_events
    FOR SELECT USING (profile_id = auth.uid());

CREATE POLICY "System can insert analytics" ON analytics_events
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can view own daily analytics" ON analytics_daily
    FOR SELECT USING (profile_id = auth.uid());

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to all relevant tables
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_social_links_updated_at
    BEFORE UPDATE ON social_links
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_custom_links_updated_at
    BEFORE UPDATE ON custom_links
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Function to increment click count
CREATE OR REPLACE FUNCTION increment_link_clicks()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.event_type = 'click' AND NEW.link_type = 'custom' THEN
        UPDATE custom_links 
        SET total_clicks = total_clicks + 1,
            last_clicked_at = NOW()
        WHERE id = NEW.link_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increment_custom_link_clicks
    AFTER INSERT ON analytics_events
    FOR EACH ROW EXECUTE FUNCTION increment_link_clicks();

-- Function to validate niche_ids array
CREATE OR REPLACE FUNCTION validate_niche_ids()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.role = 'content_creator' THEN
        -- Check if all niche IDs exist and are active
        IF EXISTS (
            SELECT 1 FROM unnest(NEW.niche_ids) AS niche_id
            WHERE niche_id NOT IN (
                SELECT id FROM niches WHERE is_active = true
            )
        ) THEN
            RAISE EXCEPTION 'Invalid niche ID provided';
        END IF;
        
        -- Content creators must have 1-3 niches
        IF array_length(NEW.niche_ids, 1) < 1 OR array_length(NEW.niche_ids, 1) > 3 THEN
            RAISE EXCEPTION 'Content creators must select 1-3 niches';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_profile_niche_ids
    BEFORE INSERT OR UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION validate_niche_ids();

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Additional indexes for common queries
CREATE INDEX CONCURRENTLY idx_profiles_username_lower ON profiles(LOWER(username));
CREATE INDEX CONCURRENTLY idx_profiles_full_name_search ON profiles USING gin(to_tsvector('english', full_name));
CREATE INDEX CONCURRENTLY idx_custom_links_total_clicks ON custom_links(total_clicks DESC);
CREATE INDEX CONCURRENTLY idx_analytics_events_created_at ON analytics_events(created_at);

-- ============================================
-- INITIAL DATA & SETUP
-- ============================================

-- Create admin user function (to be called after first user registration)
CREATE OR REPLACE FUNCTION create_admin_user(user_email TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE profiles 
    SET role = 'admin', 
        is_verified = true,
        subscription_tier = 'business'
    WHERE email = user_email;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- VIEWS FOR COMMON QUERIES
-- ============================================

-- Complete profile view with all related data
CREATE VIEW profile_complete AS
SELECT 
    p.*,
    l.city,
    l.province,
    bc.name as business_category_name,
    ARRAY(
        SELECT n.name 
        FROM niches n 
        WHERE n.id = ANY(p.niche_ids) AND n.is_active = true
    ) as niche_names,
    COUNT(sl.id) as social_links_count,
    COUNT(cl.id) as custom_links_count,
    COALESCE(ad.total_profile_views, 0) as total_profile_views_today
FROM profiles p
LEFT JOIN locations l ON p.location_id = l.id
LEFT JOIN business_categories bc ON p.business_category_id = bc.id
LEFT JOIN social_links sl ON p.id = sl.profile_id AND sl.is_active = true
LEFT JOIN custom_links cl ON p.id = cl.profile_id AND cl.is_active = true
LEFT JOIN analytics_daily ad ON p.id = ad.profile_id AND ad.date = CURRENT_DATE
GROUP BY p.id, l.city, l.province, bc.name, ad.total_profile_views;

-- Public profile view (for [username] pages)
CREATE VIEW profile_public AS
SELECT 
    p.id,
    p.username,
    p.full_name,
    p.role,
    p.bio,
    p.tagline,
    p.profile_image_url,
    p.date_of_birth,
    p.is_age_hidden,
    l.city,
    l.province,
    bc.name as business_category_name,
    ARRAY(
        SELECT n.name 
        FROM niches n 
        WHERE n.id = ANY(p.niche_ids) AND n.is_active = true
    ) as niche_names,
    p.meta_title,
    p.meta_description,
    p.created_at
FROM profiles p
LEFT JOIN locations l ON p.location_id = l.id
LEFT JOIN business_categories bc ON p.business_category_id = bc.id
WHERE p.is_public = true AND p.is_active = true;

-- ============================================
-- DATABASE MAINTENANCE
-- ============================================

-- Function to clean old analytics data (run monthly)
CREATE OR REPLACE FUNCTION cleanup_old_analytics()
RETURNS VOID AS $$
BEGIN
    -- Keep detailed events for 6 months
    DELETE FROM analytics_events 
    WHERE created_at < NOW() - INTERVAL '6 months';
    
    -- Keep daily summaries for 2 years
    DELETE FROM analytics_daily 
    WHERE date < CURRENT_DATE - INTERVAL '2 years';
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================

COMMENT ON TABLE profiles IS 'User profiles extending Supabase auth.users';
COMMENT ON TABLE social_links IS 'Social media links for user profiles';
COMMENT ON TABLE custom_links IS 'Custom links with logos and descriptions';
COMMENT ON TABLE analytics_events IS 'Detailed event tracking for analytics';
COMMENT ON TABLE analytics_daily IS 'Daily aggregated analytics for faster reporting';
COMMENT ON TABLE niches IS 'Available niches for content creators';
COMMENT ON TABLE business_categories IS 'Business categories for brands';
COMMENT ON TABLE locations IS 'Available cities and locations';
COMMENT ON TABLE social_platforms IS 'Supported social media platforms';

-- ============================================
-- END OF SCHEMA
-- ============================================
