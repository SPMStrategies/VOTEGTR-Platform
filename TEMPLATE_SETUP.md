# Setting Up Campaign Website Templates

## Quick Setup for Testing

### 1. Create a Template Repository

Create a new repository on GitHub called `patriot-template` with this structure:

```
patriot-template/
├── index.html
├── site.config.json
├── styles.css
└── netlify.toml
```

### Example Files:

**index.html:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><!-- CANDIDATE_NAME --> for <!-- OFFICE --></title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1 class="candidate-name"><!-- CANDIDATE_NAME --></h1>
        <p class="campaign-slogan"><!-- SLOGAN --></p>
    </header>
    
    <nav>
        <a href="#about">About</a>
        <a href="#issues">Issues</a>
        <a href="#volunteer">Volunteer</a>
        <a href="#contact">Contact</a>
    </nav>
    
    <main>
        <section id="hero">
            <h2>Vote <!-- CANDIDATE_NAME --> for <!-- OFFICE --></h2>
            <p><!-- BIOGRAPHY --></p>
        </section>
        
        <section id="issues">
            <h2>Key Issues</h2>
            <div class="issues-content"><!-- KEY_ISSUES --></div>
        </section>
        
        <section id="volunteer">
            <h2>Join Our Campaign</h2>
            <form name="volunteer" method="POST" data-netlify="true">
                <input type="text" name="name" placeholder="Your Name" required>
                <input type="email" name="email" placeholder="Your Email" required>
                <input type="tel" name="phone" placeholder="Phone Number">
                <textarea name="message" placeholder="How would you like to help?"></textarea>
                <button type="submit">Volunteer Now</button>
            </form>
        </section>
    </main>
    
    <footer>
        <p>Paid for by <!-- CANDIDATE_NAME --> for <!-- OFFICE --></p>
        <p>Contact: <!-- CAMPAIGN_EMAIL --> | <!-- CAMPAIGN_PHONE --></p>
    </footer>
    
    <script>
        // Load configuration and replace placeholders
        fetch('site.config.json')
            .then(res => res.json())
            .then(config => {
                document.body.innerHTML = document.body.innerHTML
                    .replace(/<!-- CANDIDATE_NAME -->/g, config.candidate.name)
                    .replace(/<!-- OFFICE -->/g, config.candidate.office)
                    .replace(/<!-- SLOGAN -->/g, config.candidate.slogan || 'Together We Win')
                    .replace(/<!-- BIOGRAPHY -->/g, config.candidate.bio || '')
                    .replace(/<!-- KEY_ISSUES -->/g, config.candidate.keyIssues || '')
                    .replace(/<!-- CAMPAIGN_EMAIL -->/g, config.contact.email || '')
                    .replace(/<!-- CAMPAIGN_PHONE -->/g, config.contact.phone || '');
                    
                // Update primary color
                if (config.branding && config.branding.primaryColor) {
                    document.documentElement.style.setProperty('--primary-color', config.branding.primaryColor);
                }
            });
    </script>
</body>
</html>
```

**styles.css:**
```css
:root {
    --primary-color: #DC2626;
    --secondary-color: #1E40AF;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Georgia, serif;
    line-height: 1.6;
    color: #333;
}

header {
    background: var(--primary-color);
    color: white;
    text-align: center;
    padding: 2rem;
}

.candidate-name {
    font-size: 3rem;
    margin-bottom: 0.5rem;
}

.campaign-slogan {
    font-size: 1.5rem;
    font-style: italic;
}

nav {
    background: #333;
    padding: 1rem;
    text-align: center;
}

nav a {
    color: white;
    text-decoration: none;
    padding: 0 1.5rem;
    font-size: 1.1rem;
}

nav a:hover {
    color: var(--primary-color);
}

main {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem;
}

section {
    margin-bottom: 3rem;
}

#hero {
    background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
    padding: 3rem;
    border-radius: 10px;
    text-align: center;
}

#hero h2 {
    color: var(--primary-color);
    font-size: 2.5rem;
    margin-bottom: 1rem;
}

form {
    display: flex;
    flex-direction: column;
    max-width: 500px;
    margin: 0 auto;
}

form input,
form textarea {
    margin-bottom: 1rem;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 1rem;
}

form button {
    background: var(--primary-color);
    color: white;
    padding: 1rem;
    border: none;
    border-radius: 5px;
    font-size: 1.2rem;
    cursor: pointer;
}

form button:hover {
    background: darkred;
}

footer {
    background: #333;
    color: white;
    text-align: center;
    padding: 2rem;
    margin-top: 3rem;
}
```

**site.config.json:**
```json
{
  "candidate": {
    "name": "Your Name",
    "office": "Office",
    "party": "Republican",
    "location": "Your District",
    "bio": "Your biography here",
    "slogan": "Your Campaign Slogan"
  },
  "contact": {
    "email": "campaign@example.com",
    "phone": "(555) 123-4567",
    "headquarters": "123 Main St, Your City"
  },
  "branding": {
    "primaryColor": "#DC2626",
    "logo": null
  },
  "social": {
    "facebook": "",
    "twitter": "",
    "instagram": ""
  }
}
```

**netlify.toml:**
```toml
[build]
  publish = "."

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
```

### 2. Make it a Template

1. Go to your repository Settings
2. Check "Template repository" under the repository name

### 3. Test the System

1. Add your GitHub and Netlify tokens to `.env.local`
2. Log in to the dashboard
3. Go to `/onboarding`
4. Fill out the form
5. Submit to create a campaign website

The system will:
- Create a new GitHub repo from your template
- Update the `site.config.json` with campaign data
- Deploy to Netlify
- Give you a live URL

## Production Templates

For production, you'll want more sophisticated templates with:
- React/Next.js for dynamic content
- Multiple pages
- Better SEO
- Mobile responsiveness
- Analytics integration
- More form types

But this simple template will work for testing the automation!