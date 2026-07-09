-- ============================================================================
-- Supabase Auth sync + authenticated user RLS for ecom_* tables
-- All new tables MUST use the ecom_ prefix (see 0001_ecom_init.sql)
-- ============================================================================

-- Sync auth.users -> ecom_user_profiles on signup
create or replace function public.ecom_handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
  v_phone text;
begin
  v_name := coalesce(
    nullif(trim(new.raw_user_meta_data->>'name'), ''),
    nullif(trim(new.raw_user_meta_data->>'full_name'), ''),
    split_part(coalesce(new.email, ''), '@', 1)
  );
  v_phone := nullif(trim(new.raw_user_meta_data->>'phone'), '');

  insert into public.ecom_user_profiles (
    user_id,
    name,
    phone,
    photo_url,
    is_email_verified,
    referral_code,
    last_login_at
  ) values (
    new.id,
    v_name,
    v_phone,
    nullif(trim(new.raw_user_meta_data->>'avatar_url'), ''),
    new.email_confirmed_at is not null,
    'REF' || upper(substr(replace(new.id::text, '-', ''), 1, 8)),
    now()
  )
  on conflict (user_id) do update set
    name = excluded.name,
    phone = coalesce(excluded.phone, public.ecom_user_profiles.phone),
    photo_url = coalesce(excluded.photo_url, public.ecom_user_profiles.photo_url),
    is_email_verified = excluded.is_email_verified or public.ecom_user_profiles.is_email_verified,
    last_login_at = now(),
    updated_at = now();

  return new;
end;
$$;

drop trigger if exists trg_ecom_on_auth_user_created on auth.users;
create trigger trg_ecom_on_auth_user_created
  after insert on auth.users
  for each row execute function public.ecom_handle_new_auth_user();

-- Helper: authenticated user owns row
create or replace function public.ecom_is_owner(row_user_id uuid)
returns boolean
language sql
stable
as $$
  select auth.uid() is not null and auth.uid() = row_user_id;
$$;

-- ----------------------------------------------------------------------------
-- ecom_user_profiles — read/insert/update own profile
-- ----------------------------------------------------------------------------
drop policy if exists ecom_user_insert_own_profile on ecom_user_profiles;
create policy ecom_user_insert_own_profile on ecom_user_profiles
  for insert with check (auth.uid() = user_id);

drop policy if exists ecom_user_update_own_profile on ecom_user_profiles;
create policy ecom_user_update_own_profile on ecom_user_profiles
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- User-owned tables — full CRUD for authenticated owner
-- ----------------------------------------------------------------------------
drop policy if exists ecom_user_manage_own_cart on ecom_cart_items;
create policy ecom_user_manage_own_cart on ecom_cart_items
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_wishlist on ecom_wishlist_items;
create policy ecom_user_manage_own_wishlist on ecom_wishlist_items
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_addresses on ecom_addresses;
create policy ecom_user_manage_own_addresses on ecom_addresses
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_orders on ecom_orders;
create policy ecom_user_manage_own_orders on ecom_orders
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_notifications on ecom_user_notifications;
create policy ecom_user_manage_own_notifications on ecom_user_notifications
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_reviews on ecom_reviews;
create policy ecom_user_manage_own_reviews on ecom_reviews
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- Additional user-scoped ecom_* tables
-- ----------------------------------------------------------------------------
alter table ecom_user_device_tokens enable row level security;
alter table ecom_membership_subscriptions enable row level security;
alter table ecom_coupon_redemptions enable row level security;
alter table ecom_search_history enable row level security;
alter table ecom_support_tickets enable row level security;
alter table ecom_reports enable row level security;
alter table ecom_referrals enable row level security;

drop policy if exists ecom_user_manage_own_device_tokens on ecom_user_device_tokens;
create policy ecom_user_manage_own_device_tokens on ecom_user_device_tokens
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_subscriptions on ecom_membership_subscriptions;
create policy ecom_user_manage_own_subscriptions on ecom_membership_subscriptions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_coupon_redemptions on ecom_coupon_redemptions;
create policy ecom_user_manage_own_coupon_redemptions on ecom_coupon_redemptions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_search_history on ecom_search_history;
create policy ecom_user_manage_own_search_history on ecom_search_history
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_support_tickets on ecom_support_tickets;
create policy ecom_user_manage_own_support_tickets on ecom_support_tickets
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_reports on ecom_reports;
create policy ecom_user_manage_own_reports on ecom_reports
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists ecom_user_manage_own_referrals on ecom_referrals;
create policy ecom_user_manage_own_referrals on ecom_referrals
  for all using (auth.uid() = user_id or auth.uid() = referred_user_id)
  with check (auth.uid() = user_id);

-- Order child tables — access via parent order ownership
alter table ecom_order_items enable row level security;
alter table ecom_order_delivery_addresses enable row level security;
alter table ecom_order_tracking_steps enable row level security;

drop policy if exists ecom_user_read_own_order_items on ecom_order_items;
create policy ecom_user_read_own_order_items on ecom_order_items
  for select using (
    exists (
      select 1 from ecom_orders o
      where o.id = ecom_order_items.order_id and o.user_id = auth.uid()
    )
  );

drop policy if exists ecom_user_read_own_order_addresses on ecom_order_delivery_addresses;
create policy ecom_user_read_own_order_addresses on ecom_order_delivery_addresses
  for select using (
    exists (
      select 1 from ecom_orders o
      where o.id = ecom_order_delivery_addresses.order_id and o.user_id = auth.uid()
    )
  );

drop policy if exists ecom_user_read_own_order_tracking on ecom_order_tracking_steps;
create policy ecom_user_read_own_order_tracking on ecom_order_tracking_steps
  for select using (
    exists (
      select 1 from ecom_orders o
      where o.id = ecom_order_tracking_steps.order_id and o.user_id = auth.uid()
    )
  );

-- Auth credential tables — service role only (no client policies)
alter table ecom_auth_accounts enable row level security;
alter table ecom_otp_verifications enable row level security;
