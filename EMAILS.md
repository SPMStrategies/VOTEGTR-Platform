# VOTEGTR Platform - Email Notification Requirements

## Email Service Provider
**Recommended**: Resend or Postmark (better for transactional emails than SendGrid)
- Clean API
- Great deliverability
- Template management
- ~$20/month for 10,000 emails

## Required Email Templates

### 1. CUSTOMER ONBOARDING EMAILS

#### Welcome Email (Immediate after payment)
**Trigger**: Successful Stripe payment
**To**: New customer
```
Subject: Welcome to VOTEGTR - Your Campaign Website is Being Created!

Hi {candidate_name},

Thank you for choosing VOTEGTR for your campaign website.

Your website is being created and will be live in about 5 minutes at:
{campaign_url}

Next steps:
1. Check your email for login credentials
2. Access your dashboard at app.votegtr.com
3. Start adding content to your website

Questions? Reply to this email for support.

Best,
The VOTEGTR Team
```

#### Site Live Notification (5 minutes after payment)
**Trigger**: Successful Netlify deployment
```
Subject: Your Campaign Website is Live! 

{candidate_name}, your website is ready!

🌐 View your site: {campaign_url}
📊 Manage content: app.votegtr.com
📧 Support: support@votegtr.com

Login credentials:
Email: {email}
Password: {temporary_password}

Please change your password after first login.
```

### 2. BILLING & SUBSCRIPTION EMAILS

#### Payment Successful (Monthly)
**Trigger**: Successful recurring charge
```
Subject: Payment Received - VOTEGTR Invoice #{invoice_number}

Thank you for your payment of ${amount}.
Your subscription remains active until {next_billing_date}.

Download Invoice: {invoice_link}
```

#### Payment Failed - First Attempt
**Trigger**: Failed payment attempt
```
Subject: Action Required: Payment Failed for VOTEGTR

We were unable to process your payment of ${amount}.

Please update your payment method within 7 days to avoid service interruption:
{update_payment_link}

Your website remains active during this grace period.
```

#### Payment Failed - Day 3 Warning
**Trigger**: 3 days after failed payment
```
Subject: Urgent: Your Campaign Website Will Be Suspended in 4 Days

We still haven't been able to process your payment.

Update payment method: {update_payment_link}

Your website will be suspended on {suspension_date} if payment is not received.
```

#### Payment Failed - Day 6 Final Warning
**Trigger**: 6 days after failed payment
```
Subject: Final Notice: Website Suspension Tomorrow

This is your final notice. Your campaign website will be suspended tomorrow at midnight.

Update payment now: {update_payment_link}

After suspension, your site will show a "This site is temporarily unavailable" message.
```

#### Website Suspended
**Trigger**: 7 days after failed payment
```
Subject: Website Suspended - Action Required

Your campaign website has been suspended due to non-payment.

Your data is safe and will be preserved for 30 days.

To reactivate immediately:
{reactivation_link}
```

#### Subscription Canceled
**Trigger**: Customer cancels
```
Subject: Subscription Canceled - We're Sorry to See You Go

Your VOTEGTR subscription has been canceled.

Your website will remain active until {end_date}.
Your data will be preserved for 30 days after that date.

To reactivate anytime: {reactivate_link}
```

### 3. FORM SUBMISSION NOTIFICATIONS

#### New Volunteer Signup
**Trigger**: Volunteer form submission
**To**: Campaign email
```
Subject: New Volunteer: {volunteer_name}

New volunteer signup on your campaign website:

Name: {name}
Email: {email}
Phone: {phone}
Interests: {interests}

View all volunteers: app.votegtr.com/volunteers
```

#### New Contact Form Submission
**Trigger**: Contact form submission
```
Subject: New Message from {sender_name}

You have a new message from your campaign website:

From: {name} ({email})
Message: {message}

Reply directly to this email to respond.
```

### 4. SYSTEM & MAINTENANCE EMAILS

#### Scheduled Maintenance
**Trigger**: Manual - before maintenance
```
Subject: Scheduled Maintenance - {date} at {time}

We'll be performing maintenance on {date} from {start_time} to {end_time} EST.

Your website may be temporarily unavailable during this time.

No action required on your part.
```

#### Security Alert
**Trigger**: Suspicious activity detected
```
Subject: Security Alert - Unusual Activity Detected

We detected unusual activity on your account:
{activity_description}

If this was you, no action needed.
If not, please reset your password immediately: {reset_link}
```

## Email Configuration

### Required Environment Variables
```env
# Email Service (Resend example)
RESEND_API_KEY=re_xxx
FROM_EMAIL=notifications@votegtr.com
SUPPORT_EMAIL=support@votegtr.com
NO_REPLY_EMAIL=no-reply@votegtr.com
```

### Email Service Setup (Resend)
```typescript
import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);

export async function sendEmail(template: string, to: string, data: any) {
  const templates = {
    'welcome': WelcomeEmail,
    'site-live': SiteLiveEmail,
    'payment-failed': PaymentFailedEmail,
    // ... etc
  };

  const EmailComponent = templates[template];
  
  await resend.emails.send({
    from: 'VOTEGTR <notifications@votegtr.com>',
    to,
    subject: EmailComponent.subject(data),
    react: EmailComponent(data),
  });
}
```

## Email Tracking & Analytics

Track these metrics:
- Open rates
- Click rates
- Bounce rates
- Unsubscribe rates

Use UTM parameters for all links:
```
?utm_source=email&utm_medium=transactional&utm_campaign=payment-failed
```

## Unsubscribe Requirements

All marketing emails must include:
- Unsubscribe link in footer
- Physical mailing address (CAN-SPAM compliance)

Transactional emails (payment, security) are exempt but should still include:
- Clear "from" address
- Accurate subject lines

## Testing Checklist

Before launch, test each email:
- [ ] Welcome email sends after payment
- [ ] Site live notification works
- [ ] Payment failed emails trigger correctly
- [ ] Grace period countdown is accurate
- [ ] Suspension email sends after 7 days
- [ ] Form notifications reach campaign email
- [ ] All links work
- [ ] Variables populate correctly
- [ ] Mobile rendering is correct

## Future Email Features (Post-MVP)
- Campaign performance weekly digest
- Voter engagement reports
- Traffic spike alerts
- Template update announcements
- Feature releases
- Campaign tips & best practices