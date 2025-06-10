// Follow this setup guide to integrate the Deno runtime into your Supabase functions:
// https://supabase.com/docs/guides/functions/deno-runtime

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight request
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Create a Supabase client with the admin key
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    )

    // Parse the request body
    const { email_address } = await req.json()

    if (!email_address) {
      return new Response(
        JSON.stringify({ error: 'Email address is required' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Query the auth.users table to check if the email exists
    const { data, error } = await supabaseClient
      .from('auth.users')
      .select('id')
      .eq('email', email_address)
      .maybeSingle()

    if (error) throw error

    // Return whether the email exists
    return new Response(
      JSON.stringify(data !== null),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error(error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
}) 