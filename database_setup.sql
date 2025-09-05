-- VOTEGTR Platform Database Setup
-- Run this in Supabase SQL Editor

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    phone TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. CAMPAIGNS TABLE
CREATE TABLE IF NOT EXISTS public.campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    campaign_name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    candidate_name TEXT NOT NULL,
    office TEXT NOT NULL,
    location TEXT,
    template TEXT DEFAULT 'patriot-template',
    status TEXT DEFAULT 'draft',
    netlify_site_id TEXT,
    netlify_site_url TEXT,
    github_repo_url TEXT,
    custom_domain TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. SUBSCRIPTIONS TABLE
CREATE TABLE IF NOT EXISTS public.subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    campaign_id UUID REFERENCES public.campaigns(id) ON DELETE CASCADE,
    stripe_subscription_id TEXT UNIQUE NOT NULL,
    stripe_customer_id TEXT NOT NULL,
    status TEXT NOT NULL,
    tier TEXT NOT NULL,
    current_period_start TIMESTAMP WITH TIME ZONE,
    current_period_end TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. CONTENT_ITEMS TABLE
CREATE TABLE IF NOT EXISTS public.content_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id UUID NOT NULL REFERENCES public.campaigns(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    title TEXT,
    content TEXT,
    metadata JSONB DEFAULT '{}',
    order_index INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. CAMPAIGN_SETTINGS TABLE
CREATE TABLE IF NOT EXISTS public.campaign_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id UUID NOT NULL REFERENCES public.campaigns(id) ON DELETE CASCADE,
    settings_type TEXT NOT NULL,
    settings_data JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(campaign_id, settings_type)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_campaigns_user_id ON public.campaigns(user_id);
CREATE INDEX IF NOT EXISTS idx_campaigns_slug ON public.campaigns(slug);
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_stripe_subscription_id ON public.subscriptions(stripe_subscription_id);
CREATE INDEX IF NOT EXISTS idx_content_items_campaign_id ON public.content_items(campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_settings_campaign_id ON public.campaign_settings(campaign_id);

-- Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.campaign_settings ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Profiles: Users can only see and edit their own profile
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Campaigns: Users can only manage their own campaigns
CREATE POLICY "Users can view own campaigns" ON public.campaigns
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert own campaigns" ON public.campaigns
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own campaigns" ON public.campaigns
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Users can delete own campaigns" ON public.campaigns
    FOR DELETE USING (user_id = auth.uid());

-- Subscriptions: Users can only view their own subscriptions
CREATE POLICY "Users can view own subscriptions" ON public.subscriptions
    FOR SELECT USING (user_id = auth.uid());

-- Content Items: Users can manage content for their campaigns
CREATE POLICY "Users can view own content" ON public.content_items
    FOR SELECT USING (
        campaign_id IN (
            SELECT id FROM public.campaigns WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert own content" ON public.content_items
    FOR INSERT WITH CHECK (
        campaign_id IN (
            SELECT id FROM public.campaigns WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update own content" ON public.content_items
    FOR UPDATE USING (
        campaign_id IN (
            SELECT id FROM public.campaigns WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete own content" ON public.content_items
    FOR DELETE USING (
        campaign_id IN (
            SELECT id FROM public.campaigns WHERE user_id = auth.uid()
        )
    );

-- Campaign Settings: Users can manage settings for their campaigns
CREATE POLICY "Users can view own settings" ON public.campaign_settings
    FOR SELECT USING (
        campaign_id IN (
            SELECT id FROM public.campaigns WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert own settings" ON public.campaign_settings
    FOR INSERT WITH CHECK (
        campaign_id IN (
            SELECT id FROM public.campaigns WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update own settings" ON public.campaign_settings
    FOR UPDATE USING (
        campaign_id IN (
            SELECT id FROM public.campaigns WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete own settings" ON public.campaign_settings
    FOR DELETE USING (
        campaign_id IN (
            SELECT id FROM public.campaigns WHERE user_id = auth.uid()
        )
    );

-- Function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name)
    VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name')
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add updated_at triggers to all tables
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_campaigns_updated_at BEFORE UPDATE ON public.campaigns
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_content_items_updated_at BEFORE UPDATE ON public.content_items
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_campaign_settings_updated_at BEFORE UPDATE ON public.campaign_settings
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- Success message
SELECT 'Database setup complete! All tables and policies created successfully.' as message;