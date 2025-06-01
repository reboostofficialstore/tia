# Project File Structure

## Root Directory Structure
project-root/
├── docs/                   # All documentation
├── src/
│   ├── app/               # Next.js app directory
│   ├── components/        # Reusable UI components
│   ├── lib/              # Utility functions
│   ├── types/            # TypeScript type definitions
│   └── styles/           # Global styles
├── public/               # Static assets
├── supabase/            # Database migrations & types
└── config files...

## Detailed App Structure
src/app/
├── (auth)/              # Authentication pages
│   ├── login/
│   ├── register/
│   ├── complete/
│   └── layout.tsx
├── (dashboard)/         # Protected dashboard pages
│   ├── dashboard/
│   ├── profile/
│   ├── social/
│   ├── custom/
│   ├── analytics/
│   ├── settings/
│   └── layout.tsx
├── (public)/           # Public pages
│   ├── about/
│   ├── contact/
│   ├── terms/
│   └── layout.tsx
├── [username]/         # Dynamic user profile pages
├── api/               # API routes
│   ├── auth/
│   ├── profile/
│   ├── social/
│   ├── custom/
│   └── analytics/
├── globals.css
├── layout.tsx
└── page.tsx           # Landing page

## Components Structure
src/components/
├── ui/                # Basic UI components
│   ├── Button.tsx
│   ├── Input.tsx
│   ├── Modal.tsx
│   └── ...
├── auth/             # Authentication components
│   ├── LoginForm.tsx
│   ├── RegisterForm.tsx
│   └── CompleteForm.tsx
├── dashboard/        # Dashboard components
│   ├── Header.tsx
│   ├── Sidebar.tsx
│   ├── ProfileForm.tsx
│   └── ...
├── public/          # Public page components
│   ├── LandingHero.tsx
│   ├── UserProfile.tsx
│   └── ...
└── shared/          # Shared components
├── Navigation.tsx
├── Footer.tsx
└── ThemeToggle.tsx

## API Routes Structure
src/app/api/
├── auth/
│   ├── register/route.ts
│   ├── login/route.ts
│   └── verify/route.ts
├── profile/
│   ├── route.ts         # GET, PUT profile
│   ├── upload/route.ts  # POST profile image
│   └── check/route.ts   # Check username availability
├── social/
│   ├── route.ts         # GET, POST, PUT, DELETE social links
│   └── platforms/route.ts # GET available platforms
├── custom/
│   ├── route.ts         # GET, POST, PUT, DELETE custom links
│   └── upload/route.ts  # POST custom link logo
├── analytics/
│   ├── route.ts         # GET analytics data
│   └── track/route.ts   # POST track clicks
└── public/
└── [username]/route.ts # GET public profile data

## Database Schema (Supabase)
Tables:
├── profiles           # User profile information
├── social_links      # Social media links
├── custom_links      # Custom links with logos
├── analytics_events  # Click tracking data
├── niches           # Content creator niches
├── categories       # Brand categories
└── locations        # Available locations

## File Naming Conventions
- **Components**: PascalCase (`UserProfile.tsx`)
- **Pages**: lowercase (`dashboard/page.tsx`)
- **API Routes**: lowercase (`route.ts`)
- **Utilities**: camelCase (`dateUtils.ts`)
- **Types**: PascalCase (`UserTypes.ts`)

## Import Order
1. React imports
2. Next.js imports
3. Third-party libraries
4. Local components
5. Utilities and types
6. Styles

## Environment Variables
Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
App Configuration
NEXT_PUBLIC_APP_NAME=
NEXT_PUBLIC_APP_URL=
NEXT_PUBLIC_APP_DESCRIPTION=
External APIs
DICEBEAR_API_URL=
UPLOAD_MAX_SIZE=
Social Platform Base URLs
INSTAGRAM_BASE_URL=
TIKTOK_BASE_URL=
FACEBOOK_BASE_URL=
TWITTER_BASE_URL=
YOUTUBE_BASE_URL=
DISCORD_BASE_URL=