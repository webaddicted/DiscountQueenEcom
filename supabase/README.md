# Discount Queen — Supabase Database

PostgreSQL schema for the **aaqueen-ecom** Flutter app. All tables use the `ecom_` prefix (same Supabase project as aaipo).

## Apply migrations

1. Supabase Dashboard → SQL Editor
2. Run `migrations/0001_ecom_init.sql`
3. Run `migrations/0002_auth_credentials.sql`
4. Run `migrations/0002_ecom_realtime.sql`
5. Run `migrations/0003_supabase_auth_sync_rls.sql`
6. Run `seed/0001_ecom_seed.sql`

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
- Authenticated users can read/write their own rows on all user-scoped `ecom_*` tables
- `auth.users` signup auto-syncs into `ecom_user_profiles` via trigger
- All new tables **must** use the `ecom_` prefix
- Backend writes may use service role / DB password when JWT is not used
