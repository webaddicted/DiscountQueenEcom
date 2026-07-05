# Discount Queen — Supabase Database

PostgreSQL schema for the **aaqueen-ecom** Flutter app. All tables use the `ecom_` prefix (same Supabase project as aaipo).

## Apply migrations

1. Supabase Dashboard → SQL Editor
2. Run `migrations/0001_ecom_init.sql`
3. Run `migrations/0002_ecom_realtime.sql`
4. Run `seed/0001_ecom_seed.sql`

## Demo auth users (optional)

Seed references fixed UUIDs. Create matching users in Supabase Auth:

| UUID | Email |
|------|-------|
| `u1000001-0001-4001-8001-000000000001` | aisha@example.com |
| `u1000001-0001-4001-8001-000000000002` | admin@discountqueen.com |

## Tables (35 `ecom_*`)

Users, catalog, cart, orders, payments, reviews, notifications, moderation, support — see plan doc for full ERD.

## Security

- RLS enabled on catalog (public read) and user-private tables (own rows via `auth.uid()`)
- All writes go through FastAPI backend with service role / DB password
