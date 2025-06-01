# 🤖 AI Development Instructions

## UNTUK SETIAP AI YANG CODING PROJECT INI

---

## 🚨 CRITICAL RULES (JANGAN DILANGGAR!)

### SECURITY FIRST
```typescript
❌ JANGAN:
- Hardcode API keys di code
- Skip input validation
- Panggil database dari frontend
- Ignore error handling

✅ SELALU:
- Gunakan environment variables
- Sanitasi semua input user
- Gunakan API routes untuk database
- Handle semua error scenarios
CODE QUALITY
typescript❌ JANGAN:
- Skip TypeScript types
- Ignore responsive design  
- Write duplicate code
- Skip component testing

✅ SELALU:
- Definisi types yang jelas
- Mobile-first approach
- Reusable components
- Test major functionality

🏗️ ARCHITECTURE PATTERNS
File Structure (WAJIB DIIKUTI)
src/
├── app/
│   ├── (auth)/          # Auth pages: login, register, complete
│   ├── (dashboard)/     # Protected: dashboard, profile, social, custom
│   ├── (public)/        # Public: about, contact, terms
│   ├── [username]/      # Dynamic user profiles
│   ├── api/            # API routes ONLY
│   └── globals.css
├── components/
│   ├── ui/             # Basic components (Button, Input, Modal)
│   ├── auth/           # Auth-specific components
│   ├── dashboard/      # Dashboard components
│   ├── public/         # Public page components
│   └── shared/         # Shared across sections
├── lib/
│   ├── supabase.ts     # Supabase client
│   ├── utils.ts        # Utility functions
│   └── validations.ts  # Zod schemas
└── types/
    └── database.ts     # TypeScript types
Component Pattern
typescript// Template untuk setiap component
interface ComponentNameProps {
  // Define props dengan TypeScript
  id?: string;
  className?: string;
  children?: React.ReactNode;
}

export default function ComponentName({ 
  id, 
  className = "", 
  children,
  ...props 
}: ComponentNameProps) {
  // 1. State management
  const [loading, setLoading] = useState(false);
  
  // 2. Event handlers
  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setLoading(true);
    
    try {
      // API call here
    } catch (error) {
      // Error handling
    } finally {
      setLoading(false);
    }
  };
  
  // 3. Render with error boundaries
  return (
    <div className={`component-base ${className}`} id={id}>
      {children}
    </div>
  );
}
API Route Pattern
typescript// Template untuk API routes
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

export async function POST(request: NextRequest) {
  try {
    // 1. Parse & validate input
    const body = await request.json();
    // Validate with Zod schema
    
    // 2. Check authentication
    const supabase = createClient();
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    
    if (authError || !user) {
      return NextResponse.json(
        { error: 'Unauthorized' }, 
        { status: 401 }
      );
    }
    
    // 3. Business logic
    const { data, error } = await supabase
      .from('table_name')
      .insert(validatedData);
    
    if (error) {
      throw error;
    }
    
    // 4. Return response
    return NextResponse.json({ 
      success: true, 
      data 
    });
    
  } catch (error) {
    console.error('API Error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

🎨 UI/UX GUIDELINES
Design System
typescript// Colors (Tailwind classes)
const colors = {
  primary: 'purple-500',    // #8B5CF6
  secondary: 'yellow-400',  // #FCD34D
  success: 'green-500',
  error: 'red-500',
  warning: 'orange-500',
  gray: 'gray-500'
};

// Spacing scale
const spacing = 'space-y-4 p-4 m-4'; // 16px base

// Typography
const typography = {
  h1: 'text-3xl font-bold',
  h2: 'text-2xl font-semibold', 
  h3: 'text-xl font-medium',
  body: 'text-base',
  small: 'text-sm text-gray-600'
};
Responsive Design
typescript// Mobile-first approach
className="
  w-full p-4                    // Mobile
  md:w-1/2 md:p-6              // Tablet  
  lg:w-1/3 lg:p-8              // Desktop
"

// Common patterns
const responsiveClasses = {
  container: 'max-w-7xl mx-auto px-4 sm:px-6 lg:px-8',
  grid: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4',
  flexCenter: 'flex items-center justify-center',
  button: 'px-4 py-2 rounded-lg font-medium transition-colors'
};
Component Library
typescript// Gunakan components ini untuk consistency
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Modal } from '@/components/ui/Modal';
import { Loading } from '@/components/ui/Loading';
import { Toast } from '@/components/ui/Toast';

// Jangan buat custom kecuali benar-benar perlu

🔐 AUTHENTICATION PATTERNS
Client-side Auth Check
typescript'use client';
import { useAuth } from '@/hooks/useAuth';

export default function ProtectedComponent() {
  const { user, loading } = useAuth();
  
  if (loading) return <Loading />;
  if (!user) return <LoginPrompt />;
  
  return <ActualComponent />;
}
Server-side Auth Check
typescriptimport { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';

export default async function ProtectedPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  
  if (!user) {
    redirect('/login');
  }
  
  return <PageContent user={user} />;
}

🗄️ DATABASE PATTERNS
Data Fetching
typescript// Client-side fetching
const fetchUserProfile = async (userId: string) => {
  const response = await fetch(`/api/profile/${userId}`);
  if (!response.ok) throw new Error('Failed to fetch');
  return response.json();
};

// Server-side fetching
const getUserProfile = async (userId: string) => {
  const supabase = createClient();
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('user_id', userId)
    .single();
    
  if (error) throw error;
  return data;
};
Data Mutations
typescript// Always use API routes for mutations
const updateProfile = async (profileData: ProfileData) => {
  const response = await fetch('/api/profile', {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(profileData)
  });
  
  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message);
  }
  
  return response.json();
};

🎯 SPECIFIC FEATURE GUIDELINES
Form Handling
typescriptimport { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { profileSchema } from '@/lib/validations';

const ProfileForm = () => {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting }
  } = useForm({
    resolver: zodResolver(profileSchema)
  });
  
  const onSubmit = async (data: ProfileFormData) => {
    try {
      await updateProfile(data);
      toast.success('Profile updated!');
    } catch (error) {
      toast.error('Failed to update profile');
    }
  };
  
  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* Form fields with proper validation */}
    </form>
  );
};
Image Upload
typescriptconst uploadProfileImage = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  
  const response = await fetch('/api/upload/profile', {
    method: 'POST',
    body: formData
  });
  
  if (!response.ok) throw new Error('Upload failed');
  return response.json();
};
Analytics Tracking
typescriptconst trackClick = async (linkId: string, type: 'social' | 'custom') => {
  // Don't wait for response, fire and forget
  fetch('/api/analytics/track', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ linkId, type, timestamp: Date.now() })
  }).catch(() => {
    // Silently fail, analytics shouldn't break UX
  });
};

🚨 ERROR HANDLING PATTERNS
Global Error Boundary
typescript'use client';
export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <html>
      <body>
        <div className="min-h-screen flex items-center justify-center">
          <div className="text-center">
            <h2 className="text-2xl font-bold mb-4">Something went wrong!</h2>
            <button 
              onClick={reset}
              className="px-4 py-2 bg-purple-500 text-white rounded"
            >
              Try again
            </button>
          </div>
        </div>
      </body>
    </html>
  );
}
API Error Handling
typescript// Consistent error response format
const errorResponse = (message: string, status: number = 400) => {
  return NextResponse.json(
    { 
      success: false,
      error: message,
      timestamp: new Date().toISOString()
    },
    { status }
  );
};

// Usage in API routes
if (!validatedData) {
  return errorResponse('Invalid input data', 400);
}

🧪 TESTING GUIDELINES
Component Testing
typescript// Test user interactions, not implementation details
import { render, screen, fireEvent } from '@testing-library/react';
import { ProfileForm } from './ProfileForm';

test('submits form with valid data', async () => {
  render(<ProfileForm />);
  
  fireEvent.change(screen.getByLabelText(/name/i), {
    target: { value: 'John Doe' }
  });
  
  fireEvent.click(screen.getByRole('button', { name: /save/i }));
  
  expect(await screen.findByText(/saved successfully/i)).toBeInTheDocument();
});
Manual Testing Checklist
typescript// Before marking feature complete:
✅ Mobile responsive (320px - 1200px+)
✅ Dark/light mode working
✅ Form validation working  
✅ Error states handled
✅ Loading states shown
✅ Success feedback given
✅ Keyboard accessible
✅ Works without JavaScript (basic functionality)

🚀 DEPLOYMENT & ENVIRONMENT
Environment Variables
bash# .env.local (NEVER commit this)
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
NEXT_PUBLIC_APP_URL=http://localhost:3000
Build Optimization
typescript// next.config.js
const nextConfig = {
  images: {
    domains: ['your-supabase-project.supabase.co'],
  },
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
};

📝 DOCUMENTATION REQUIREMENTS
Code Comments
typescript// Only comment WHY, not WHAT
// ❌ Bad: Increment counter by 1
// ✅ Good: Reset attempts after successful login to prevent lockout

// Document complex business logic
const calculateProUpgradeDiscount = (user: User) => {
  // Apply 50% discount for users registered > 6 months
  // to encourage long-term free users to convert
  const monthsSinceRegistration = getMonthsDiff(user.createdAt, new Date());
  return monthsSinceRegistration >= 6 ? 0.5 : 0;
};
Progress Updates
markdown// Format untuk update latest-progress.md
## [2025-06-01 14:30] - Feature X Implementation
**Status**: ✅ COMPLETED

### Completed:
- ✅ User registration form with validation
- ✅ Email verification flow
- ✅ Profile completion redirect

### Files Modified:
- `app/(auth)/register/page.tsx` - New registration form
- `app/api/auth/register/route.ts` - Registration API
- `components/auth/RegisterForm.tsx` - Form component

### Next Steps:
- 📋 Implement login functionality
- 📋 Add password reset flow

🎯 WORKFLOW RECAP
Sebelum Coding:

✅ Baca latest-progress.md
✅ Pahami current task
✅ Review existing code patterns
✅ Plan component structure

Saat Coding:

✅ Follow file structure
✅ Use TypeScript properly
✅ Handle errors gracefully
✅ Test on mobile & desktop

Setelah Coding:

✅ Update latest-progress.md
✅ Test all functionality
✅ Check responsive design
✅ Document any issues

Remember: Kualitas > Kecepatan. Better to build it right the first time!