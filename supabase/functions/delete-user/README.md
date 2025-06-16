# Delete User Edge Function

This Edge Function provides a secure way to delete user accounts from the Supabase authentication system. It uses the service role key to perform the deletion, which is only available on the server-side.

## Deployment

To deploy this function to your Supabase project:

1. Install the Supabase CLI if you haven't already:
   ```bash
   npm install -g supabase
   ```

2. Login to your Supabase account:
   ```bash
   supabase login
   ```

3. Link your project (if not already linked):
   ```bash
   supabase link --project-ref your-project-ref
   ```

4. Deploy the function:
   ```bash
   supabase functions deploy delete-user --no-verify-jwt
   ```

5. Set up the required environment variables:
   ```bash
   supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
   supabase secrets set SUPABASE_URL=https://your-project-ref.supabase.co
   ```

## Usage

This function is called from the app when a user wants to delete their account. It requires:

1. A valid authorization header with the user's access token
2. The user ID to delete in the request body

The function verifies that the requesting user is the same as the user being deleted before performing the deletion.

## Security

This function uses the service role key, which has admin privileges. The security checks ensure that:

1. The request contains a valid authorization header
2. The requesting user is authenticated
3. The requesting user can only delete their own account

These measures prevent unauthorized account deletions. 