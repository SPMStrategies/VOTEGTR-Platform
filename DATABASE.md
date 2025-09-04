# VOTEGTR Platform - Database Architecture

## Database Overview
**Primary Database**: Supabase (PostgreSQL)
- **Purpose**: Central database for all platform operations
- **Location**: Supabase cloud
- **Access**: Via Supabase client libraries and REST API

## Field Type Legend
- `UUID` - Unique identifier (auto-generated)
- `TEXT` - String/text data
- `JSONB` - JSON data (flexible structure)
- `BOOLEAN` - True/false values
- `INTEGER` - Whole numbers
- `TIMESTAMP` - Date and time with timezone
- `DATE` - Date only
- `PK` - Primary Key (unique identifier for table)
- `FK` - Foreign Key (links to another table)

## Database Schema

### 1️⃣ USERS & AUTHENTICATION

#### Table: `auth.users` (Managed by Supabase Auth)
- **Purpose**: Core authentication and user accounts
- **Managed by**: Supabase Auth (automatic)

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | User identifier |
| email | TEXT | Login email |
| password_hash | TEXT | Encrypted password |
| created_at | TIMESTAMP | Account creation |

#### Table: `public.profiles`
- **Purpose**: Extended user information for candidates/staff

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK FK(auth.users) | Links to Supabase Auth |
| email | TEXT UNIQUE | Contact email |
| full_name | TEXT | Display name |
| phone | TEXT | Contact phone |
| created_at | TIMESTAMP | Account creation |
| updated_at | TIMESTAMP | Last modified |

### 2️⃣ CAMPAIGN MANAGEMENT

#### Table: `public.campaigns`
- **Purpose**: Each candidate's campaign website configuration

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Campaign identifier |
| user_id | UUID FK(profiles) | Owner of campaign |
| campaign_name | TEXT | "Smith for Congress 2024" |
| candidate_name | TEXT | "John Smith" |
| office | TEXT | "U.S. House - District 5" |
| party | TEXT | "Republican" |
| location | TEXT | "Texas" |
| slug | TEXT UNIQUE | URL: "smith-for-congress" |
| template_id | TEXT | Which template they chose |
| github_repo_url | TEXT | GitHub repository URL |
| netlify_site_id | TEXT | Netlify site identifier |
| netlify_site_url | TEXT | Live website URL |
| custom_domain | TEXT | "smithforcongress.com" |
| settings | JSONB | {colors, fonts, layout} |
| ai_content | JSONB | Generated bio, policies |
| status | TEXT | 'creating', 'active', 'paused' |
| created_at | TIMESTAMP | Campaign created |
| updated_at | TIMESTAMP | Last modified |

#### Table: `public.templates`
- **Purpose**: Available website templates for selection

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Template identifier |
| name | TEXT | "Patriot Template" |
| slug | TEXT UNIQUE | "patriot-template" |
| description | TEXT | Template description |
| preview_url | TEXT | Demo site URL |
| github_template_repo | TEXT | Source repository |
| tier_required | TEXT | 'standard' or 'professional' |
| features | JSONB | ["blog", "events", "donations"] |
| created_at | TIMESTAMP | Template added |

#### Table: `public.website_configs`
- **Purpose**: Stores onboarding form data and customizations

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Config identifier |
| campaign_id | UUID FK(campaigns) | Which campaign |
| template_id | UUID FK(templates) | Which template used |
| onboarding_data | JSONB | All form responses |
| color_scheme | JSONB | {primary: "#FF0000", secondary: "#0000FF"} |
| fonts | JSONB | {heading: "Montserrat", body: "Open Sans"} |
| custom_css | TEXT | Additional CSS overrides |
| created_at | TIMESTAMP | Configuration created |
| updated_at | TIMESTAMP | Last modified |

### 3️⃣ CONTENT MANAGEMENT

#### Table: `public.content_items`
- **Purpose**: Blog posts, press releases, events, endorsements

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Content identifier |
| campaign_id | UUID FK(campaigns) | Which campaign |
| type | TEXT | 'blog', 'press_release', 'endorsement', 'event' |
| title | TEXT | "Veterans Town Hall Meeting" |
| slug | TEXT | "veterans-town-hall" |
| content | JSONB | {body: "HTML", excerpt: "...", images: [...]} |
| status | TEXT | 'draft', 'published', 'archived' |
| published_at | TIMESTAMP | When published |
| created_at | TIMESTAMP | Content created |
| updated_at | TIMESTAMP | Last modified |

**Unique Constraint**: (campaign_id, slug) - No duplicate URLs per campaign

#### Table: `public.content_versions`
- **Purpose**: Track edit history for content

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Version identifier |
| campaign_id | UUID FK(campaigns) | Which campaign |
| page | TEXT | 'about', 'issues', 'home' |
| content | JSONB | Complete content snapshot |
| version | INTEGER | Version number (1, 2, 3...) |
| created_by | UUID FK(profiles) | Who made the edit |
| created_at | TIMESTAMP | When edited |

### 4️⃣ FORM SUBMISSIONS

#### Table: `public.form_submissions` (Legacy)
- **Purpose**: Store form data from campaign websites (if not using Netlify Forms)

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Submission identifier |
| campaign_id | UUID FK(campaigns) | Which campaign |
| form_type | TEXT | 'volunteer', 'contact', 'newsletter' |
| data | JSONB | {name: "...", email: "...", message: "..."} |
| created_at | TIMESTAMP | Submission time |

#### Table: `public.netlify_forms`
- **Purpose**: Store Netlify form webhook data

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Record identifier |
| campaign_id | UUID FK(campaigns) | Which campaign |
| form_name | TEXT | 'volunteer-signup', 'contact' |
| submission_data | JSONB | Raw Netlify payload |
| processed | BOOLEAN | Has been viewed/handled |
| created_at | TIMESTAMP | Received from Netlify |

### 5️⃣ BILLING & SUBSCRIPTIONS

#### Table: `public.subscriptions`
- **Purpose**: Stripe subscription management

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Subscription identifier |
| user_id | UUID FK(profiles) | Customer |
| stripe_customer_id | TEXT UNIQUE | cus_xxx from Stripe |
| stripe_subscription_id | TEXT UNIQUE | sub_xxx from Stripe |
| stripe_price_id | TEXT | price_xxx ($99 or $179) |
| status | TEXT | 'active', 'canceled', 'past_due' |
| current_period_start | TIMESTAMP | Billing cycle start |
| current_period_end | TIMESTAMP | Next renewal date |
| cancel_at | TIMESTAMP | Scheduled cancellation |
| canceled_at | TIMESTAMP | When canceled |
| created_at | TIMESTAMP | Subscription created |
| updated_at | TIMESTAMP | Last modified |

### 6️⃣ ANALYTICS

#### Table: `public.analytics`
- **Purpose**: Website traffic and engagement metrics

| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Record identifier |
| campaign_id | UUID FK(campaigns) | Which campaign |
| date | DATE | Analytics for which day |
| visitors | INTEGER | Unique visitors |
| page_views | INTEGER | Total page views |
| top_pages | JSONB | [{path: "/about", views: 123}, ...] |
| top_referrers | JSONB | [{source: "facebook.com", count: 45}, ...] |
| created_at | TIMESTAMP | Record created |

**Unique Constraint**: (campaign_id, date) - One record per campaign per day

## Database Relationships

```
auth.users
    ↓ (1:1)
profiles ←─────────────────────┐
    ↓ (1:many)                 │
campaigns                       │
    ↓ (1:1)                    │ (references)
website_configs                 │
    ↓ (1:many)                 │
content_items                   │
content_versions ───────────────┘
form_submissions
netlify_forms
analytics
    ↑ (many:1)
subscriptions → profiles
```

## Data Flow Examples

### When a candidate signs up:
1. Create `auth.users` entry (Supabase Auth)
2. Auto-create `profiles` entry (via trigger)
3. Create `subscriptions` entry (after Stripe payment)
4. Create `campaigns` entry
5. Create `website_configs` with onboarding data

### When content is published:
1. Insert/update `content_items`
2. Create `content_versions` for history
3. Trigger GitHub commit via API
4. Netlify auto-deploys
5. Website goes live

### When a form is submitted:
1. Netlify receives form on campaign website
2. Netlify webhook → our API endpoint
3. Insert into `netlify_forms`
4. Campaign staff views in dashboard

### When viewing analytics:
1. Fetch from external service (Google Analytics/Plausible)
2. Store daily snapshot in `analytics` table
3. Display graphs in dashboard

## Security & Access Control

All tables have Row Level Security (RLS) enabled:
- Users can only see their own data
- Campaigns are isolated between accounts
- Form submissions are read-only to campaign owners
- Public website visitors cannot access any database directly

## Backup & Recovery

- **Automatic backups**: Daily via Supabase
- **Point-in-time recovery**: Last 30 days
- **Content versioning**: All edits tracked in `content_versions`
- **Audit trail**: All changes timestamped with user ID