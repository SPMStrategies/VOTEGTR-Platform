# VOTEGTR - Simplified MVP Scope

Based on your requirements, here's what we're building vs. cutting:

## ✅ MUST HAVE FOR LAUNCH

### Core Features
1. **Marketing site** (votegtr.com) with Stripe checkout
2. **Dashboard** (app.votegtr.com) for content management
3. **3-5 locked templates** (no HTML/CSS editing)
4. **Automated deployment** to Netlify
5. **Basic email notifications** (welcome, payment failed, site live)
6. **7-day grace period** for failed payments
7. **Netlify Forms** pass-through to dashboard

### Tech Stack (Simplified)
- **Frontend**: Keep Next.js for now (you already started)
- **Database**: Supabase (simple, cheap)
- **Payments**: Stripe Checkout (embedded)
- **Hosting**: Netlify (easiest)
- **CDN**: Cloudflare (free tier)
- **Emails**: Resend ($20/month)

## ❌ CUT FROM MVP (Add Later)

### Features to Skip
- ~~Content moderation system~~ (you're not liable)
- ~~AI content generation~~ (nice-to-have)
- ~~Advanced analytics~~ (Google Analytics is enough)
- ~~Custom HTML/CSS editing~~ (locked templates only)
- ~~Multiple staff accounts~~ (one login per campaign)
- ~~Template versioning system~~ (manual updates fine for 10-100 sites)
- ~~Support ticket system~~ (use email)
- ~~Webhook validation~~ (add when you scale)

### Simplified Architecture
```
Customer Journey:
1. Browse templates on votegtr.com
2. Pay with Stripe
3. Fill out form on app.votegtr.com
4. Site deploys to Netlify
5. Manage content in simple dashboard
```

## 🚀 LAUNCH CHECKLIST (2-3 Weeks)

### Week 1: Foundation
- [ ] Set up Supabase database
- [ ] Create Stripe products ($99 and $179)
- [ ] Build marketing site with template gallery
- [ ] Implement Stripe Checkout flow
- [ ] Create 3 campaign templates

### Week 2: Dashboard & Automation
- [ ] Build login/auth system
- [ ] Create onboarding form
- [ ] Implement GitHub repo creation
- [ ] Set up Netlify deployment
- [ ] Build basic content editor (blog posts only)

### Week 3: Polish & Launch
- [ ] Set up email notifications
- [ ] Test payment flows
- [ ] Deploy to production
- [ ] Create documentation
- [ ] Soft launch with 1-2 beta customers

## 💰 INITIAL COSTS

### Monthly Expenses (for 50 sites)
- Supabase: $25/month
- Netlify: ~$100/month (with Cloudflare CDN)
- Resend: $20/month
- Domain: $15/year
- **Total**: ~$150/month

### One-Time Costs
- Stripe setup: Free
- Cloudflare: Free tier
- GitHub: Free for public repos

## ⚠️ ACCEPTABLE RISKS (Your Preferences)

You're comfortable with:
1. **No content moderation** - Platform disclaimer is enough
2. **Competition copying** - First mover advantage matters more
3. **Basic support** - Email only, no tickets
4. **Simple architecture** - Can rebuild later if successful
5. **Manual processes** - You can handle template updates manually

## 🎯 SUCCESS METRICS

Launch is successful if:
- 5 paying customers in first month
- Sites deploy successfully
- Payment processing works
- No critical security issues
- Customers can update content

## 🔑 KEY DECISIONS MADE

Based on your answers:
1. **Speed > Perfection** - Launch fast, iterate later
2. **Simple > Scalable** - Build for 100, not 10,000
3. **Lock templates** - No CSS/HTML editing reduces risk
4. **Hands-off content** - You're a platform, not a publisher
5. **Email support only** - Personal touch for early customers

## IMMEDIATE NEXT STEPS

1. **Create Stripe account** and set up products
2. **Reserve votegtr.com** domain
3. **Set up Supabase** project
4. **Create GitHub** organization for templates
5. **Start building** marketing site

## WHAT WE'RE EXPLICITLY NOT WORRYING ABOUT

- Scale beyond 100 sites
- Automated template updates
- Content liability
- Complex analytics
- Multi-user permissions
- API rate limits (until you hit them)
- Perfect code (MVP = move fast)

This approach gets you to market in 2-3 weeks instead of 2-3 months.