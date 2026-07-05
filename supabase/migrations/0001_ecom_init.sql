-- ============================================================================
-- Discount Queen E-commerce — initial schema (ecom_* tables)
-- Same Supabase project as aaipo; all tables prefixed ecom_
-- ============================================================================

create extension if not exists "pgcrypto";

-- ----------------------------------------------------------------------------
-- ENUMS
-- ----------------------------------------------------------------------------
do $$ begin
  create type ecom_account_status as enum (
    'active', 'inactive', 'pending_verification', 'blocked', 'suspended', 'deleted'
  );
exception when duplicate_object then null;
end $$;

do $$ begin
  create type ecom_order_status as enum (
    'pending', 'confirmed', 'processing', 'shipped', 'out_for_delivery',
    'delivered', 'cancelled', 'refunded'
  );
exception when duplicate_object then null;
end $$;

do $$ begin
  create type ecom_payment_status as enum (
    'pending', 'paid', 'failed', 'refunded'
  );
exception when duplicate_object then null;
end $$;

-- ----------------------------------------------------------------------------
-- USERS & DEVICES
-- ----------------------------------------------------------------------------
create table if not exists ecom_user_profiles (
  id                    uuid primary key default gen_random_uuid(),
  user_id               uuid unique not null,
  name                  varchar(150),
  first_name            varchar(80),
  phone                 varchar(20),
  country_code          varchar(10),
  complete_mobile_number varchar(20),
  photo_url             text,
  gender                varchar(20),
  date_of_birth         date,
  bio                   text,
  is_email_verified     boolean not null default false,
  is_mobile_verified    boolean not null default false,
  account_status        ecom_account_status not null default 'active',
  is_admin              boolean not null default false,
  is_blocked            boolean not null default false,
  block_reason          text,
  suspended_until       timestamptz,
  is_onboarding_done    boolean not null default false,
  is_profile_complete   boolean not null default false,
  default_address_id    uuid,
  preferred_language    varchar(10) not null default 'en',
  preferred_currency    varchar(3) not null default 'INR',
  referral_code         varchar(20) unique,
  referred_by_user_id   uuid,
  loyalty_points        int not null default 0,
  membership_tier       varchar(30) not null default 'free',
  total_orders_count    int not null default 0,
  total_spent           numeric(14,2) not null default 0,
  reports_filed_count   int not null default 0,
  reports_against_count int not null default 0,
  last_active_at        timestamptz,
  last_login_at         timestamptz,
  latitude              numeric(10,7),
  longitude             numeric(10,7),
  location_address      text,
  marketing_opt_in      boolean not null default true,
  additional_data       jsonb not null default '{}',
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),
  deleted_at            timestamptz
);

create index if not exists idx_ecom_user_profiles_user_id on ecom_user_profiles (user_id);
create index if not exists idx_ecom_user_profiles_status on ecom_user_profiles (account_status);

create table if not exists ecom_user_device_tokens (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null,
  token         text not null,
  platform      varchar(20) not null default 'android',
  device_id     varchar(100) not null,
  app_version   varchar(20),
  is_active     boolean not null default true,
  last_used_at  timestamptz,
  created_at    timestamptz not null default now(),
  unique (user_id, device_id)
);

create index if not exists idx_ecom_device_tokens_user on ecom_user_device_tokens (user_id);

create table if not exists ecom_membership_plans (
  id                    uuid primary key default gen_random_uuid(),
  plan_code             varchar(50) unique not null,
  plan_name             varchar(100) not null,
  plan_description      text,
  plan_duration         varchar(20) not null default 'monthly',
  amount                numeric(12,2) not null default 0,
  currency              varchar(3) not null default 'INR',
  features              jsonb not null default '[]',
  google_play_product_id varchar(100),
  razorpay_plan_id      varchar(100),
  sort_order            int not null default 0,
  is_active             boolean not null default true,
  created_at            timestamptz not null default now()
);

create table if not exists ecom_membership_subscriptions (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null,
  plan_id          uuid references ecom_membership_plans(id),
  subscription_id varchar(100) unique,
  plan_name        varchar(100),
  amount           numeric(12,2),
  currency         varchar(3) default 'INR',
  start_date       timestamptz,
  end_date         timestamptz,
  auto_renew       boolean not null default false,
  status           varchar(30) not null default 'pending',
  payment_method   varchar(30),
  transaction_id   varchar(100),
  gateway          varchar(30),
  features         jsonb default '[]',
  cancelled_at     timestamptz,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- CATALOG
-- ----------------------------------------------------------------------------
create table if not exists ecom_categories (
  id            uuid primary key default gen_random_uuid(),
  slug          varchar(100) unique not null,
  name          varchar(150) not null,
  image_url     text,
  icon_name     varchar(50),
  parent_id     uuid references ecom_categories(id),
  sort_order    int not null default 0,
  is_active     boolean not null default true,
  product_count int not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create table if not exists ecom_brands (
  id         uuid primary key default gen_random_uuid(),
  name       varchar(150) unique not null,
  logo_url   text,
  is_active  boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists ecom_products (
  id                uuid primary key default gen_random_uuid(),
  sku               varchar(50) unique not null,
  name              varchar(255) not null,
  slug              varchar(255) unique not null,
  description       text,
  short_description varchar(500),
  category_id       uuid references ecom_categories(id),
  brand_id          uuid references ecom_brands(id),
  price             numeric(12,2) not null default 0,
  mrp               numeric(12,2) not null default 0,
  discount_percent  int not null default 0,
  thumbnail_url     text,
  rating_avg        numeric(3,2) not null default 0,
  review_count      int not null default 0,
  stock_qty         int not null default 0,
  in_stock          boolean generated always as (stock_qty > 0) stored,
  sold_count        int not null default 0,
  view_count        int not null default 0,
  weight_grams      int,
  dimensions_cm     jsonb,
  hsn_code          varchar(20),
  gst_percent       numeric(5,2),
  is_featured       boolean not null default false,
  is_popular        boolean not null default false,
  is_new_arrival    boolean not null default false,
  is_active         boolean not null default true,
  is_deleted        boolean not null default false,
  deleted_at        timestamptz,
  deleted_by        uuid,
  moderation_status varchar(30) not null default 'approved',
  tags              text[] not null default '{}',
  meta_title        text,
  meta_description  text,
  vendor_id         uuid,
  additional_data   jsonb not null default '{}',
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index if not exists idx_ecom_products_category on ecom_products (category_id);
create index if not exists idx_ecom_products_featured on ecom_products (is_featured) where is_active and not is_deleted;
create index if not exists idx_ecom_products_tags on ecom_products using gin (tags);

create table if not exists ecom_product_images (
  id          uuid primary key default gen_random_uuid(),
  product_id  uuid not null references ecom_products(id) on delete cascade,
  image_url   text not null,
  alt_text    varchar(255),
  sort_order  int not null default 0,
  is_primary  boolean not null default false
);

create table if not exists ecom_product_variants (
  id             uuid primary key default gen_random_uuid(),
  product_id     uuid not null references ecom_products(id) on delete cascade,
  size           varchar(30) not null default '',
  color          varchar(50) not null default '',
  sku_suffix     varchar(30),
  price_override numeric(12,2),
  stock_qty      int not null default 0,
  is_active      boolean not null default true,
  unique (product_id, size, color)
);

create table if not exists ecom_product_specifications (
  id         uuid primary key default gen_random_uuid(),
  product_id uuid not null references ecom_products(id) on delete cascade,
  spec_key   varchar(100) not null,
  spec_value text not null,
  sort_order int not null default 0
);

create table if not exists ecom_banners (
  id           uuid primary key default gen_random_uuid(),
  title        varchar(200),
  subtitle     varchar(300),
  image_url    text not null,
  action_type  varchar(30) not null default 'none',
  action_value varchar(255),
  sort_order   int not null default 0,
  is_active    boolean not null default true,
  starts_at    timestamptz,
  ends_at      timestamptz,
  click_count  int not null default 0,
  created_by   uuid,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create table if not exists ecom_media_uploads (
  id                uuid primary key default gen_random_uuid(),
  uploaded_by       uuid,
  entity_type       varchar(30) not null,
  entity_id         uuid,
  storage_bucket    varchar(100),
  storage_path      text,
  public_url        text not null,
  mime_type         varchar(50),
  file_size_bytes   bigint,
  original_filename varchar(255),
  sort_order        int not null default 0,
  metadata          jsonb not null default '{}',
  is_deleted        boolean not null default false,
  created_at        timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- PROMOTIONS
-- ----------------------------------------------------------------------------
create table if not exists ecom_coupons (
  id                      uuid primary key default gen_random_uuid(),
  code                    varchar(50) unique not null,
  discount_type           varchar(20) not null default 'percent',
  discount_percent        int not null default 0,
  discount_amount         numeric(12,2) not null default 0,
  max_discount            numeric(12,2) not null default 0,
  min_order_amount        numeric(12,2) not null default 0,
  usage_limit             int,
  per_user_limit          int not null default 1,
  used_count              int not null default 0,
  applicable_category_ids uuid[],
  starts_at               timestamptz,
  expires_at              timestamptz,
  is_active               boolean not null default true,
  created_at              timestamptz not null default now()
);

create table if not exists ecom_coupon_redemptions (
  id               uuid primary key default gen_random_uuid(),
  coupon_id        uuid not null references ecom_coupons(id),
  user_id          uuid not null,
  order_id         uuid,
  discount_applied numeric(12,2) not null default 0,
  redeemed_at      timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- SHOPPING STATE
-- ----------------------------------------------------------------------------
create table if not exists ecom_addresses (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null,
  name            varchar(150),
  phone           varchar(20),
  address_line_1  text not null,
  address_line_2  text,
  city            varchar(100) not null,
  state           varchar(100) not null,
  pincode         varchar(10) not null,
  landmark        varchar(200),
  address_type    varchar(20) not null default 'home',
  is_default      boolean not null default false,
  latitude        numeric(10,7),
  longitude       numeric(10,7),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index if not exists idx_ecom_addresses_user on ecom_addresses (user_id);

alter table ecom_user_profiles
  drop constraint if exists ecom_user_profiles_default_address_fk;
alter table ecom_user_profiles
  add constraint ecom_user_profiles_default_address_fk
  foreign key (default_address_id) references ecom_addresses(id) on delete set null;

create table if not exists ecom_cart_items (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null,
  product_id     uuid not null references ecom_products(id) on delete cascade,
  variant_id     uuid references ecom_product_variants(id) on delete set null,
  quantity       int not null default 1 check (quantity > 0),
  selected_size  varchar(30) not null default '',
  selected_color varchar(50) not null default '',
  unit_price     numeric(12,2) not null default 0,
  unit_mrp       numeric(12,2) not null default 0,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  unique (user_id, product_id, variant_id)
);

create table if not exists ecom_wishlist_items (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null,
  product_id uuid not null references ecom_products(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, product_id)
);

-- ----------------------------------------------------------------------------
-- ORDERS & PAYMENTS
-- ----------------------------------------------------------------------------
create table if not exists ecom_orders (
  id                  uuid primary key default gen_random_uuid(),
  order_number        varchar(30) unique not null,
  user_id             uuid not null,
  status              ecom_order_status not null default 'pending',
  subtotal            numeric(12,2) not null default 0,
  delivery_fee        numeric(12,2) not null default 0,
  discount            numeric(12,2) not null default 0,
  tax_amount          numeric(12,2) not null default 0,
  total               numeric(12,2) not null default 0,
  coupon_id           uuid references ecom_coupons(id),
  coupon_code         varchar(50),
  payment_method      varchar(30),
  payment_status      ecom_payment_status not null default 'pending',
  source              varchar(20) not null default 'app',
  ip_address          inet,
  user_agent          text,
  razorpay_order_id   varchar(100),
  razorpay_payment_id varchar(100),
  razorpay_signature  varchar(255),
  invoice_number      varchar(50),
  invoice_url         text,
  estimated_delivery  date,
  delivered_at        timestamptz,
  cancelled_at        timestamptz,
  cancel_reason       text,
  refund_status       varchar(30) not null default 'none',
  refund_amount       numeric(12,2) not null default 0,
  notes               text,
  additional_data     jsonb not null default '{}',
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

create index if not exists idx_ecom_orders_user on ecom_orders (user_id);
create index if not exists idx_ecom_orders_status on ecom_orders (status);

alter table ecom_coupon_redemptions
  drop constraint if exists ecom_coupon_redemptions_order_fk;
alter table ecom_coupon_redemptions
  add constraint ecom_coupon_redemptions_order_fk
  foreign key (order_id) references ecom_orders(id) on delete set null;

create table if not exists ecom_order_items (
  id             uuid primary key default gen_random_uuid(),
  order_id       uuid not null references ecom_orders(id) on delete cascade,
  product_id     uuid references ecom_products(id),
  variant_id     uuid references ecom_product_variants(id),
  product_name   varchar(255) not null,
  product_image  text,
  selected_size  varchar(30) not null default '',
  selected_color varchar(50) not null default '',
  unit_price     numeric(12,2) not null default 0,
  unit_mrp       numeric(12,2) not null default 0,
  quantity       int not null default 1,
  line_total     numeric(12,2) not null default 0
);

create table if not exists ecom_order_delivery_addresses (
  id                uuid primary key default gen_random_uuid(),
  order_id          uuid unique not null references ecom_orders(id) on delete cascade,
  source_address_id uuid,
  name              varchar(150),
  phone             varchar(20),
  address_line_1    text,
  address_line_2    text,
  city              varchar(100),
  state             varchar(100),
  pincode           varchar(10),
  landmark          varchar(200),
  address_type      varchar(20) default 'home'
);

create table if not exists ecom_order_tracking_steps (
  id           uuid primary key default gen_random_uuid(),
  order_id     uuid not null references ecom_orders(id) on delete cascade,
  title        varchar(100) not null,
  description  text,
  event_at     timestamptz,
  is_completed boolean not null default false,
  is_current   boolean not null default false,
  sort_order   int not null default 0
);

create table if not exists ecom_payments (
  id                    uuid primary key default gen_random_uuid(),
  order_id              uuid references ecom_orders(id) on delete set null,
  subscription_id       uuid references ecom_membership_subscriptions(id) on delete set null,
  user_id               uuid not null,
  payment_ref           varchar(100),
  gateway               varchar(30) not null default 'cod',
  gateway_order_id      varchar(100),
  gateway_payment_id    varchar(100),
  gateway_signature     varchar(255),
  amount                numeric(12,2) not null default 0,
  currency              varchar(3) not null default 'INR',
  status                varchar(30) not null default 'pending',
  payment_method_detail varchar(100),
  failure_reason        text,
  retry_count           int not null default 0,
  gateway_response      jsonb,
  webhook_received_at   timestamptz,
  paid_at               timestamptz,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- REVIEWS & NOTIFICATIONS
-- ----------------------------------------------------------------------------
create table if not exists ecom_reviews (
  id                  uuid primary key default gen_random_uuid(),
  product_id          uuid not null references ecom_products(id) on delete cascade,
  user_id             uuid not null,
  order_id            uuid references ecom_orders(id) on delete set null,
  rating              numeric(2,1) not null check (rating >= 1 and rating <= 5),
  comment             text,
  images              text[] not null default '{}',
  is_verified_purchase boolean not null default false,
  helpful_count       int not null default 0,
  moderation_status   varchar(30) not null default 'approved',
  rejected_reason     text,
  is_visible          boolean not null default true,
  is_deleted          boolean not null default false,
  deleted_at          timestamptz,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  unique (product_id, user_id)
);

create table if not exists ecom_user_notifications (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null,
  title             varchar(200) not null,
  body              text,
  notification_type varchar(40) not null default 'system',
  action_type       varchar(30),
  action_value      varchar(255),
  deep_link_url     text,
  image_url         text,
  is_read           boolean not null default false,
  is_sent           boolean not null default false,
  sent_at           timestamptz,
  additional_data   jsonb not null default '{}',
  created_at        timestamptz not null default now()
);

create index if not exists idx_ecom_notifications_user on ecom_user_notifications (user_id);

create table if not exists ecom_push_notification_queue (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null,
  notification_id   uuid references ecom_user_notifications(id) on delete set null,
  title             varchar(200) not null,
  body              text,
  tokens            text[] not null default '{}',
  notification_type varchar(40),
  payload           jsonb not null default '{}',
  status            varchar(20) not null default 'pending',
  error_message     text,
  attempts          int not null default 0,
  scheduled_at      timestamptz,
  sent_at           timestamptz,
  created_at        timestamptz not null default now()
);

create table if not exists ecom_notification_broadcasts (
  id                uuid primary key default gen_random_uuid(),
  title             varchar(200) not null,
  body              text not null,
  image_url         text,
  target_audience   varchar(30) not null default 'all',
  segment_filter    jsonb not null default '{}',
  is_sent           boolean not null default false,
  sent_at           timestamptz,
  recipients_count  int not null default 0,
  created_by        uuid,
  created_at        timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- MODERATION & SUPPORT
-- ----------------------------------------------------------------------------
create table if not exists ecom_reports (
  id                 uuid primary key default gen_random_uuid(),
  reporter_user_id   uuid not null,
  report_type        varchar(30) not null,
  reported_entity_id uuid not null,
  reported_user_id   uuid,
  reason             varchar(50) not null,
  description        text,
  status             varchar(30) not null default 'reported',
  is_resolved        boolean not null default false,
  resolved_at        timestamptz,
  resolved_by        uuid,
  resolution_note    text,
  created_at         timestamptz not null default now(),
  unique (reporter_user_id, report_type, reported_entity_id)
);

create table if not exists ecom_admin_audit_logs (
  id            uuid primary key default gen_random_uuid(),
  actor_user_id uuid,
  action        varchar(50) not null,
  entity_type   varchar(30) not null,
  entity_id     uuid,
  before_data   jsonb,
  after_data    jsonb,
  ip_address    inet,
  created_at    timestamptz not null default now()
);

create table if not exists ecom_refunds (
  id                uuid primary key default gen_random_uuid(),
  order_id          uuid not null references ecom_orders(id) on delete cascade,
  payment_id        uuid references ecom_payments(id) on delete set null,
  user_id           uuid not null,
  amount            numeric(12,2) not null,
  reason            text,
  status            varchar(30) not null default 'requested',
  gateway_refund_id varchar(100),
  processed_by      uuid,
  processed_at      timestamptz,
  created_at        timestamptz not null default now()
);

create table if not exists ecom_referrals (
  id               uuid primary key default gen_random_uuid(),
  referrer_user_id uuid not null,
  referee_user_id  uuid not null,
  referral_code    varchar(20) not null,
  reward_type      varchar(30) not null default 'points',
  reward_amount    numeric(12,2) not null default 0,
  status           varchar(30) not null default 'pending',
  credited_at      timestamptz,
  created_at       timestamptz not null default now()
);

create table if not exists ecom_search_history (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid,
  query         varchar(255) not null,
  filters       jsonb not null default '{}',
  results_count int not null default 0,
  created_at    timestamptz not null default now()
);

create table if not exists ecom_inventory_logs (
  id            uuid primary key default gen_random_uuid(),
  product_id    uuid not null references ecom_products(id) on delete cascade,
  variant_id    uuid references ecom_product_variants(id) on delete set null,
  change_qty    int not null,
  stock_before  int not null,
  stock_after   int not null,
  reason        varchar(50) not null,
  reference_id  uuid,
  actor_user_id uuid,
  created_at    timestamptz not null default now()
);

create table if not exists ecom_support_tickets (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null,
  order_id    uuid references ecom_orders(id) on delete set null,
  subject     varchar(200) not null,
  message     text not null,
  category    varchar(30) not null default 'other',
  status      varchar(30) not null default 'open',
  priority    varchar(20) not null default 'normal',
  assigned_to uuid,
  resolved_at timestamptz,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table if not exists ecom_faqs (
  id         uuid primary key default gen_random_uuid(),
  question   text not null,
  answer     text not null,
  category   varchar(50) not null default 'general',
  sort_order int not null default 0,
  is_active  boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists ecom_app_settings (
  key        varchar(100) primary key,
  value      jsonb not null default '{}',
  updated_at timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- TRIGGERS: updated_at
-- ----------------------------------------------------------------------------
create or replace function ecom_set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

do $$ declare t text;
begin
  foreach t in array array[
    'ecom_user_profiles', 'ecom_membership_subscriptions', 'ecom_categories',
    'ecom_products', 'ecom_banners', 'ecom_addresses', 'ecom_cart_items',
    'ecom_orders', 'ecom_payments', 'ecom_reviews', 'ecom_support_tickets'
  ] loop
    execute format('drop trigger if exists trg_%s_updated on %s', t, t);
    execute format(
      'create trigger trg_%s_updated before update on %s for each row execute function ecom_set_updated_at()',
      t, t
    );
  end loop;
end $$;

-- Category product_count refresh
create or replace function ecom_refresh_category_product_count()
returns trigger language plpgsql as $$
begin
  if tg_op = 'DELETE' then
    update ecom_categories set product_count = (
      select count(*) from ecom_products
      where category_id = old.category_id and is_active and not is_deleted
    ) where id = old.category_id;
    return old;
  end if;
  if new.category_id is not null then
    update ecom_categories set product_count = (
      select count(*) from ecom_products
      where category_id = new.category_id and is_active and not is_deleted
    ) where id = new.category_id;
  end if;
  if tg_op = 'UPDATE' and old.category_id is distinct from new.category_id and old.category_id is not null then
    update ecom_categories set product_count = (
      select count(*) from ecom_products
      where category_id = old.category_id and is_active and not is_deleted
    ) where id = old.category_id;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_ecom_products_category_count on ecom_products;
create trigger trg_ecom_products_category_count
  after insert or update or delete on ecom_products
  for each row execute function ecom_refresh_category_product_count();

-- Review rating aggregate
create or replace function ecom_refresh_product_rating()
returns trigger language plpgsql as $$
declare pid uuid;
begin
  pid := coalesce(new.product_id, old.product_id);
  update ecom_products set
    rating_avg = coalesce((
      select round(avg(rating)::numeric, 2) from ecom_reviews
      where product_id = pid and is_visible and not is_deleted and moderation_status = 'approved'
    ), 0),
    review_count = (
      select count(*) from ecom_reviews
      where product_id = pid and is_visible and not is_deleted and moderation_status = 'approved'
    )
  where id = pid;
  return coalesce(new, old);
end;
$$;

drop trigger if exists trg_ecom_reviews_rating on ecom_reviews;
create trigger trg_ecom_reviews_rating
  after insert or update or delete on ecom_reviews
  for each row execute function ecom_refresh_product_rating();

-- ----------------------------------------------------------------------------
-- RLS (public read for catalog; user-scoped for private data)
-- ----------------------------------------------------------------------------
alter table ecom_categories enable row level security;
alter table ecom_products enable row level security;
alter table ecom_banners enable row level security;
alter table ecom_brands enable row level security;
alter table ecom_product_images enable row level security;
alter table ecom_reviews enable row level security;
alter table ecom_user_profiles enable row level security;
alter table ecom_cart_items enable row level security;
alter table ecom_wishlist_items enable row level security;
alter table ecom_addresses enable row level security;
alter table ecom_orders enable row level security;
alter table ecom_user_notifications enable row level security;
alter table ecom_faqs enable row level security;
alter table ecom_app_settings enable row level security;

drop policy if exists ecom_public_read_categories on ecom_categories;
create policy ecom_public_read_categories on ecom_categories for select using (is_active);

drop policy if exists ecom_public_read_products on ecom_products;
create policy ecom_public_read_products on ecom_products for select using (is_active and not is_deleted);

drop policy if exists ecom_public_read_banners on ecom_banners;
create policy ecom_public_read_banners on ecom_banners for select using (is_active);

drop policy if exists ecom_public_read_brands on ecom_brands;
create policy ecom_public_read_brands on ecom_brands for select using (is_active);

drop policy if exists ecom_public_read_images on ecom_product_images;
create policy ecom_public_read_images on ecom_product_images for select using (true);

drop policy if exists ecom_public_read_reviews on ecom_reviews;
create policy ecom_public_read_reviews on ecom_reviews for select
  using (is_visible and not is_deleted and moderation_status = 'approved');

drop policy if exists ecom_public_read_faqs on ecom_faqs;
create policy ecom_public_read_faqs on ecom_faqs for select using (is_active);

drop policy if exists ecom_public_read_settings on ecom_app_settings;
create policy ecom_public_read_settings on ecom_app_settings for select using (true);

drop policy if exists ecom_user_read_own_profile on ecom_user_profiles;
create policy ecom_user_read_own_profile on ecom_user_profiles for select
  using (auth.uid() = user_id);

drop policy if exists ecom_user_read_own_cart on ecom_cart_items;
create policy ecom_user_read_own_cart on ecom_cart_items for select
  using (auth.uid() = user_id);

drop policy if exists ecom_user_read_own_wishlist on ecom_wishlist_items;
create policy ecom_user_read_own_wishlist on ecom_wishlist_items for select
  using (auth.uid() = user_id);

drop policy if exists ecom_user_read_own_addresses on ecom_addresses;
create policy ecom_user_read_own_addresses on ecom_addresses for select
  using (auth.uid() = user_id);

drop policy if exists ecom_user_read_own_orders on ecom_orders;
create policy ecom_user_read_own_orders on ecom_orders for select
  using (auth.uid() = user_id);

drop policy if exists ecom_user_read_own_notifications on ecom_user_notifications;
create policy ecom_user_read_own_notifications on ecom_user_notifications for select
  using (auth.uid() = user_id);
