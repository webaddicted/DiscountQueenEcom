-- Auth credentials + OTP verification tables

create table if not exists ecom_auth_accounts (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid unique not null,
  email         varchar(255) unique not null,
  phone         varchar(20) unique,
  password_hash text not null,
  is_verified   boolean not null default false,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index if not exists idx_ecom_auth_accounts_email on ecom_auth_accounts (lower(email));
create index if not exists idx_ecom_auth_accounts_phone on ecom_auth_accounts (phone);

create table if not exists ecom_otp_verifications (
  id         uuid primary key default gen_random_uuid(),
  email      varchar(255) not null,
  otp_code   varchar(6) not null,
  expires_at timestamptz not null,
  is_used    boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_ecom_otp_email on ecom_otp_verifications (lower(email));
