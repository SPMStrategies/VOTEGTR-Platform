# VOTEGTR.com Platform - Product Requirements Document

## Executive Summary
VOTEGTR.com is a Website-as-a-Service (WaaS) platform specifically designed for Republican political candidates running for office. The platform enables candidates to quickly launch professional campaign websites by selecting templates, entering their information, and subscribing to a monthly plan. The system automatically generates, deploys, and manages campaign websites with built-in content management and form handling capabilities.

## Business Model
- **Target Market**: Republican candidates running for local, state, and federal offices
- **Pricing Tiers**: 
  - Standard: $99/month
  - Professional: $179/month
- **Value Proposition**: Instant professional campaign website with automated deployment and management

## Core Platform Components

### 1. Main Marketing Website (VOTEGTR.com)
- **URL**: `https://votegtr.com`
- Landing page showcasing platform features
- Template gallery with live previews
- Pricing comparison table
- Sign-up flow with Stripe integration
- Customer testimonials and case studies

### 2. Customer Dashboard (VOTEGTR-Platform)
- **URL**: `https://app.votegtr.com` or `https://dashboard.votegtr.com`
- **Purpose**: Administrative backend where campaign staff log in to manage their campaign websites
- **Access**: Secure login for candidates and authorized campaign staff

#### 2.1 Customer Acquisition & Onboarding Flow

**Overview**: The onboarding process is split between the marketing website (payment) and the dashboard (setup form) for optimal conversion and security.

**Step 1: Browse & Select (votegtr.com)**
- Customer visits `votegtr.com`
- Browses template gallery with live previews
- Views pricing comparison
- Clicks "Get Started" on preferred plan

**Step 2: Payment via Stripe Checkout (votegtr.com)**
- **Embedded Stripe Checkout** overlay appears (customer stays on votegtr.com)
- Subscription options:
  - $99/month Standard Plan:
    - Basic template customization
    - Standard form handling
    - Basic analytics
    - 5GB storage
  
  - $179/month Professional Plan:
    - Advanced customization options
    - Priority support
    - Advanced analytics
    - Unlimited storage
    - Custom domain included
    - Priority deployment

- **Stripe Checkout Configuration**:
  ```javascript
  // Embedded on votegtr.com
  stripe.redirectToCheckout({
    lineItems: [{price: 'price_[plan]_monthly', quantity: 1}],
    mode: 'subscription',
    successUrl: 'https://app.votegtr.com/onboarding?session_id={CHECKOUT_SESSION_ID}',
    cancelUrl: 'https://votegtr.com/pricing'
  });
  ```
- After successful payment → Redirects to `app.votegtr.com/onboarding`

**Step 3: Account Creation (app.votegtr.com)**
- System verifies Stripe session ID
- Creates Supabase Auth account
- Creates profile and subscription records
- User sets password for future logins

**Step 4: Campaign Information Form (app.votegtr.com/onboarding)**
- **Basic Information**:
  - Candidate name
  - Office seeking
  - District/jurisdiction
  - Election date
  - Party affiliation confirmation
  
- **Contact Details**:
  - Campaign headquarters address
  - Phone numbers
  - Email addresses
  - Social media handles
  
- **Branding Assets**:
  - Campaign logo upload
  - Color scheme selection
  - Font preferences
  - Hero images/headshots
  
- **Content Sections**:
  - Biography
  - Platform/issues (key policy positions)
  - Endorsements list
  - Campaign slogan
  - Call-to-action messages

**Step 5: Template Selection (app.votegtr.com/onboarding)**
- Choose from available templates based on subscription tier
- Preview with their entered information
- Confirm selection

**Step 6: Automated Website Generation**
- Automatic GitHub repository creation
- Template customization with provided content
- Netlify deployment pipeline setup
- DNS configuration (if custom domain)
- SSL certificate provisioning
- Email notification when site is live (~3-5 minutes)

**Why This Flow Works**:
- **Higher Conversion**: Payment on trusted marketing domain (20-30% better)
- **Security**: Only paying customers access onboarding forms
- **User Experience**: Simple linear flow without confusion
- **Data Protection**: Sensitive campaign data only entered after authentication

#### 2.2 Content Management System
- **Blog/News Section**:
  - Create/edit/delete articles
  - Rich text editor
  - Image uploads
  - Scheduling/publishing controls
  - Categories and tags
  
- **Press Releases**:
  - Template-based creation
  - Media contact management
  - Distribution tracking
  
- **Endorsements**:
  - Add/remove endorsers
  - Endorser photos and bios
  - Categorization (elected officials, organizations, community leaders)
  
- **Events Calendar**:
  - Create campaign events
  - RSVP management
  - Location mapping
  - Event reminders
  
- **Media Gallery**:
  - Photo albums
  - Video embeds
  - Document library

#### 2.3 Form Management
All forms handled via Netlify Forms with data flowing back to dashboard:

- **Volunteer Sign-up Form**:
  - Name, contact info
  - Areas of interest
  - Availability
  - Skills/expertise
  
- **Email Newsletter Subscribe**:
  - Email capture
  - Preference management
  - GDPR compliance
  
- **Contact Form**:
  - General inquiries
  - Issue-specific feedback
  - Meeting requests
  
- **Survey/Polling Forms**:
  - Custom question builder
  - Multiple choice/text responses
  - Results analytics
  
- **Donation Interest Form**:
  - FEC compliance notice
  - Contact for donation information
  - Contribution limits disclaimer

#### 2.4 Analytics Dashboard
- Website traffic metrics
- Form submission reports
- Content engagement tracking
- Geographic visitor data
- Referral source analysis
- Email subscriber growth

#### 2.5 Settings & Configuration
- Domain management
- SEO settings
- Social media integration
- Email notification preferences
- Billing and subscription management
- User access control (for campaign staff)

### 3. Generated Campaign Websites
Each customer gets an automated, deployed website with:

**URL Structure**:
- **Standard Plan**: `https://{campaign-slug}.votegtr.com`
- **Professional Plan**: Custom domain support (e.g., `https://www.smithforcongress.com`)

**Pages Included**:
- **Homepage**: Hero section, key messages, call-to-action
- **About Page**: Candidate biography, values, family
- **Issues Page**: Policy positions on key Republican priorities
- **News/Blog**: Campaign updates and press releases
- **Events Page**: Upcoming rallies, town halls, fundraisers
- **Endorsements Page**: Supporting individuals and organizations
- **Volunteer Page**: Sign-up forms and involvement opportunities
- **Contact Page**: Campaign office info and contact forms
- **Donate Page**: FEC-compliant donation information

## URL Architecture & Routing

### Platform URLs
```
https://votegtr.com/                    # Main marketing website
https://app.votegtr.com/                # Dashboard for campaign staff login
├── /login                              # Staff authentication
├── /register                           # New candidate sign-up
├── /dashboard                          # Main dashboard overview
├── /campaigns/{campaign-id}/
│   ├── /content/
│   │   ├── /blog                      # Create/edit blog posts
│   │   ├── /press-releases            # Manage press releases  
│   │   ├── /endorsements              # Add/edit endorsements
│   │   ├── /events                    # Manage campaign events
│   │   └── /media                     # Upload images/videos
│   ├── /forms/                        # View Netlify form submissions
│   │   ├── /volunteers                # Volunteer sign-ups
│   │   ├── /newsletter                # Email subscribers
│   │   ├── /contact                   # Contact form submissions
│   │   └── /surveys                   # Survey responses
│   ├── /analytics/                    # Traffic and engagement metrics
│   ├── /settings/                     # Website configuration
│   │   ├── /domain                    # Custom domain settings
│   │   ├── /branding                  # Colors, fonts, logos
│   │   └── /seo                       # SEO and metadata
│   └── /billing/                      # Subscription management
└── /account/                          # User profile settings
```

### Generated Campaign Sites
```
https://{campaign-slug}.votegtr.com/    # Standard plan URL
https://www.{custom-domain}.com/        # Professional plan with custom domain
```

## Technical Architecture

### Frontend Stack
- **Dashboard** (`app.votegtr.com`): Astro, TypeScript, Tailwind CSS
- **Marketing Site** (`votegtr.com`): Astro, TypeScript, Tailwind CSS  
- **Campaign Sites**: Static HTML/CSS/JS generated from templates
- **Template Engine**: Handlebars/Liquid for content injection

### Backend Services
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Payment**: Stripe API
- **Form Handling**: Netlify Forms API
- **Repository Management**: GitHub API
- **Deployment**: Netlify API
- **File Storage**: Supabase Storage
- **CDN & Security**: Cloudflare (in front of Netlify)

### Hosting Architecture (Netlify + Cloudflare CDN)

**Traffic Flow**:
```
Visitor → Cloudflare CDN → Netlify → Campaign Website
           ↓
    (Cached assets)
    - Images, CSS, JS
    - Static pages
    - 60-80% bandwidth savings
```

**Configuration**:
1. **Netlify Hosting**:
   - Handles deployments from GitHub
   - Processes form submissions
   - Manages build pipeline
   - Provides SSL certificates
   - Instant cache invalidation

2. **Cloudflare CDN Layer**:
   - Free CDN tier for all campaign sites
   - Aggressive caching rules for static assets
   - DDoS protection and WAF
   - Image optimization (Polish)
   - Minification of CSS/JS
   - Brotli compression

**Benefits**:
- **Cost Reduction**: 60-80% lower bandwidth costs
- **Performance**: <1 second global load times
- **Security**: Enterprise-grade DDoS protection
- **Reliability**: 99.99% uptime with dual-layer redundancy

### Automation Pipeline
1. Customer completes onboarding form
2. System creates GitHub repository from template
3. Injects customer content into template files
4. Commits changes to repository
5. Triggers Netlify deployment
6. Configures Cloudflare DNS (for custom domains)
7. Sets up Cloudflare caching rules
8. Notifies customer of live website

## Database Architecture

**📚 Complete Database Documentation**: See [DATABASE.md](./DATABASE.md) for full schema, field definitions, and relationships.

### Key Database Tables
- **Users & Auth**: `profiles`, `auth.users` (Supabase Auth)
- **Campaigns**: `campaigns`, `templates`, `website_configs`
- **Content**: `content_items`, `content_versions`
- **Forms**: `netlify_forms`, `form_submissions`
- **Billing**: `subscriptions` (Stripe integration)
- **Analytics**: `analytics` (traffic metrics)

All tables use PostgreSQL with Row Level Security (RLS) enabled for data isolation between accounts.

## Implementation Phases

### Phase 1: MVP (Weeks 1-3)
- [ ] Basic dashboard with authentication
- [ ] Template selection interface
- [ ] Stripe payment integration
- [ ] Onboarding form builder
- [ ] GitHub repository creation
- [ ] Netlify deployment automation
- [ ] Basic content management (blog posts)

### Phase 2: Core Features (Weeks 4-6)
- [ ] Complete content management system
- [ ] Netlify Forms integration
- [ ] Analytics dashboard
- [ ] Multiple template options
- [ ] Custom domain setup
- [ ] Email notifications

### Phase 3: Advanced Features (Weeks 7-8)
- [ ] Advanced customization options
- [ ] Multi-user access for campaign staff
- [ ] A/B testing capabilities
- [ ] Email marketing integration
- [ ] Advanced SEO tools
- [ ] Performance optimization

## Success Criteria
- Website generation completes in < 5 minutes
- Zero-downtime deployments
- 99.9% uptime for all services
- Page load times < 2 seconds
- Mobile-responsive on all devices
- FEC compliance for all donation-related content

## Compliance & Legal
- FEC regulations for political campaigns
- Political advertising disclaimers
- Data privacy (CCPA/GDPR where applicable)
- Accessibility standards (WCAG 2.1 AA)
- Terms of Service and Privacy Policy
- Acceptable use policy for content

## Support & Documentation
- Video tutorials for onboarding
- Knowledge base for common tasks
- Email support (24-48 hour response)
- Priority support for Professional tier
- Campaign best practices guide
- Template customization guide

## Competitive Advantages
- Republican-specific design aesthetic and messaging
- Rapid deployment (live in minutes)
- No technical expertise required
- Built-in compliance features
- Integrated content management
- Affordable pricing for local campaigns
- Netlify's enterprise-grade infrastructure

## Cost Optimization Strategy

### Infrastructure Costs (Per Month)
**Without Optimization**:
- Netlify Hosting: ~$20-99 per site
- Bandwidth overages: ~$55 per 100GB
- Form submissions: ~$19 per site
- **Total**: ~$500-2000/month for 50 sites

**With Cloudflare CDN Optimization**:
- Netlify Hosting: ~$20-99 per site (same)
- Bandwidth: 80% reduced via Cloudflare caching
- Cloudflare: FREE tier (includes CDN, DDoS, SSL)
- Form submissions: ~$19 per site (same)
- **Total**: ~$200-600/month for 50 sites
- **Savings**: 60-70% reduction in bandwidth costs

### Cloudflare Configuration
**Caching Rules**:
- Images: Cache 30 days
- CSS/JS: Cache 7 days  
- HTML: Cache 4 hours
- API responses: No cache

**Page Rules** (3 free per domain):
1. `*.votegtr.com/assets/*` - Cache Everything
2. `*.votegtr.com/api/*` - Bypass Cache
3. `*.votegtr.com/admin/*` - Bypass Cache

### DNS Architecture
```
Campaign Domain → Cloudflare DNS → Netlify
                     ↓
              (Orange Cloud ON)
              - CDN enabled
              - DDoS protection
              - SSL/TLS
```

## Risk Management
- **Political neutrality**: Clear Republican branding
- **Content moderation**: Automated flagging system
- **Scalability**: CDN and caching strategy via Cloudflare
- **Security**: Regular security audits + Cloudflare WAF
- **Compliance**: Legal review of all templates
- **Customer support**: Dedicated support team during election season
- **Cost overruns**: Cloudflare CDN prevents bandwidth spikes