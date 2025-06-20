-- Function to insert a promo code usage record
CREATE OR REPLACE FUNCTION public.insert_promo_code_usage(
  p_user_id UUID,
  p_promo_code_id UUID,
  p_used_at TIMESTAMPTZ
)
RETURNS VOID AS $$
BEGIN
  INSERT INTO public.promo_code_usages (user_id, promo_code_id, used_at)
  VALUES (p_user_id, p_promo_code_id, p_used_at);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 