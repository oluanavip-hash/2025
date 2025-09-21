/*
# [FEATURE] Implement Admin Role for Dashboard
This migration introduces an admin role to allow privileged access to data, starting with viewing all orders in the dashboard.

## Query Description:
This script performs the following actions:
1.  **Adds a 'role' column** to the `profiles` table to distinguish between regular users and administrators. The default role is 'user'.
2.  **Creates a helper function** to securely check a user's role.
3.  **Updates the Row Level Security (RLS) policies** on the `orders` table. The new policy allows users with the 'admin' role to view all orders, while regular users can still only see their own.
4.  **Sets the first registered user as an admin** to facilitate immediate testing. You can manage roles manually in the Supabase table editor later.

This change is essential for the dashboard functionality and enhances security by explicitly defining user roles. No data will be lost.

## Metadata:
- Schema-Category: "Structural"
- Impact-Level: "Medium"
- Requires-Backup: false
- Reversible: true

## Structure Details:
- **Table Modified**: `public.profiles`
  - **Column Added**: `role` (text, default 'user')
- **Table Modified**: `public.orders`
  - **RLS Policies**: Updated to be role-based.
- **Function Created**: `get_user_role(uuid)`

## Security Implications:
- RLS Status: Enabled
- Policy Changes: Yes. Policies on `orders` are updated for role-based access, which is a security enhancement.
- Auth Requirements: Policies are based on `auth.uid()` and the new `role` column in `profiles`.

## Performance Impact:
- Indexes: None added or removed.
- Triggers: None added or removed.
- Estimated Impact: Low. The new policy may have a minor performance impact on order queries, which is acceptable for the added security.
*/

-- 1. Add role column to profiles table if it doesn't exist
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'user';

-- 2. Create a function to check user role securely
-- This function will be used in our RLS policies.
-- Using SECURITY DEFINER is safe here because it only reads a non-sensitive 'role' column.
-- Setting search_path prevents potential hijacking attacks.
CREATE OR REPLACE FUNCTION get_user_role(user_id uuid)
RETURNS TEXT AS $$
DECLARE
  user_role TEXT;
BEGIN
  SELECT role INTO user_role FROM public.profiles WHERE id = user_id;
  RETURN user_role;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public;

-- 3. Drop existing select policy on orders table to avoid conflicts
DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;

-- 4. Create new RLS policies for the orders table
-- Policy for Admins: Admins can see all orders.
CREATE POLICY "Allow admin to view all orders"
ON public.orders
FOR SELECT
TO authenticated
USING (get_user_role(auth.uid()) = 'admin');

-- Policy for Users: Regular users can only see their own orders.
CREATE POLICY "Allow user to view their own orders"
ON public.orders
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- 5. Grant permission for authenticated users to use the helper function
GRANT EXECUTE ON FUNCTION get_user_role(uuid) TO authenticated;

-- 6. Set the first user as an admin for testing purposes.
-- This makes the earliest registered user an admin.
DO $$
DECLARE
    first_user_id uuid;
BEGIN
    -- Find the ID of the first user who signed up
    SELECT id INTO first_user_id FROM auth.users ORDER BY created_at LIMIT 1;
    
    -- If a user is found, update their profile role to 'admin'
    IF first_user_id IS NOT NULL THEN
        UPDATE public.profiles SET role = 'admin' WHERE id = first_user_id;
    END IF;
END $$;
