-- Discount Queen — demo seed (matches AdminRepository seeds)
-- Run after 0001_ecom_init.sql

-- App settings
insert into ecom_app_settings (key, value) values
  ('free_delivery_threshold', '499'),
  ('delivery_charge', '49'),
  ('support_email', '"support@discountqueen.app"'),
  ('website_url', '"https://discountqueen.app"'),
  ('currency', '"INR"'),
  ('app_name', '"Discount Queen"')
on conflict (key) do update set value = excluded.value, updated_at = now();

-- Categories
insert into ecom_categories (id, slug, name, sort_order, is_active, product_count) values
  ('a1000001-0001-4001-8001-000000000001', 'fashion', 'Fashion', 1, true, 0),
  ('a1000001-0001-4001-8001-000000000002', 'home', 'Home', 2, true, 0),
  ('a1000001-0001-4001-8001-000000000003', 'beauty', 'Beauty', 3, true, 0)
on conflict (id) do nothing;

-- Brands
insert into ecom_brands (id, name, is_active) values
  ('b1000001-0001-4001-8001-000000000001', 'DQ', true),
  ('b1000001-0001-4001-8001-000000000002', 'DQ Home', true)
on conflict (id) do nothing;

-- Products
insert into ecom_products (
  id, sku, name, slug, description, short_description,
  category_id, brand_id, price, mrp, discount_percent, thumbnail_url,
  stock_qty, is_featured, is_popular, is_new_arrival, tags
) values
  (
    'p1000001-0001-4001-8001-000000000001',
    'DQ-TEE-001', 'Everyday Tee', 'everyday-tee',
    'Soft cotton tee for daily wear.', 'Breathable cotton',
    'a1000001-0001-4001-8001-000000000001',
    'b1000001-0001-4001-8001-000000000001',
    599, 999, 40, 'https://picsum.photos/seed/dq1/400/400',
    42, true, false, false, array['tee','basics']
  ),
  (
    'p1000001-0001-4001-8001-000000000002',
    'DQ-MUG-001', 'Ceramic Mug Set', 'ceramic-mug-set',
    'Set of 2 minimalist mugs.', 'Minimalist mugs',
    'a1000001-0001-4001-8001-000000000002',
    'b1000001-0001-4001-8001-000000000002',
    449, 699, 36, 'https://picsum.photos/seed/dq2/400/400',
    18, false, true, false, array['mug','home']
  ),
  (
    'p1000001-0001-4001-8001-000000000003',
    'DQ-BABY-001', 'Organic Cotton Baby Onesie', 'baby-onesie',
    'Premium cotton onesie for your little one.', 'Soft baby onesie',
    'a1000001-0001-4001-8001-000000000001',
    'b1000001-0001-4001-8001-000000000001',
    899, 1299, 31, 'https://picsum.photos/400/400?random=1',
    50, true, true, true, array['baby','clothing']
  )
on conflict (id) do nothing;

insert into ecom_product_images (product_id, image_url, sort_order, is_primary) values
  ('p1000001-0001-4001-8001-000000000001', 'https://picsum.photos/seed/dq1/400/400', 0, true),
  ('p1000001-0001-4001-8001-000000000002', 'https://picsum.photos/seed/dq2/400/400', 0, true),
  ('p1000001-0001-4001-8001-000000000003', 'https://picsum.photos/400/400?random=1', 0, true)
on conflict do nothing;

insert into ecom_product_variants (product_id, size, color, stock_qty) values
  ('p1000001-0001-4001-8001-000000000001', 'S', 'Black', 10),
  ('p1000001-0001-4001-8001-000000000001', 'M', 'White', 15),
  ('p1000001-0001-4001-8001-000000000001', 'L', 'Black', 17),
  ('p1000001-0001-4001-8001-000000000003', '0-3M', 'Red', 20)
on conflict do nothing;

-- Banners
insert into ecom_banners (title, subtitle, image_url, action_type, action_value, sort_order, is_active) values
  ('Baby Essentials Sale', 'Up to 40% off on diapers & wipes', 'https://picsum.photos/seed/baby1/800/400', 'category', 'fashion', 1, true),
  ('New Arrivals', 'Fresh collection for your little one', 'https://picsum.photos/seed/baby2/800/400', 'collection', 'new', 2, true),
  ('Feeding & Nursing', 'Premium bottles & accessories', 'https://picsum.photos/seed/baby3/800/400', 'category', 'home', 3, true);

-- Coupons
insert into ecom_coupons (code, discount_type, discount_percent, max_discount, min_order_amount, is_active, expires_at) values
  ('SAVE20', 'percent', 20, 200, 299, true, now() + interval '90 days'),
  ('FLAT100', 'flat', 0, 0, 499, true, now() + interval '60 days')
on conflict (code) do nothing;

update ecom_coupons set discount_amount = 100 where code = 'FLAT100';

-- FAQs
insert into ecom_faqs (question, answer, category, sort_order) values
  ('What is the delivery charge?', 'Delivery is ₹49 for orders below ₹499. Free delivery above ₹499.', 'orders', 1),
  ('How do I track my order?', 'Go to My Orders and tap on your order to see tracking steps.', 'orders', 2),
  ('What payment methods are accepted?', 'We accept Cash on Delivery, UPI, Cards, and Wallets via Razorpay.', 'payments', 3);

-- Membership plan (Queen Plus — future)
insert into ecom_membership_plans (plan_code, plan_name, plan_description, plan_duration, amount, features, sort_order) values
  ('queen_plus_monthly', 'Queen Plus', 'Free delivery + early access to sales', 'monthly', 299,
   '["free_delivery","early_access","exclusive_coupons"]', 1)
on conflict (plan_code) do nothing;

-- Demo user profiles (requires matching auth.users — use fixed UUIDs for dev)
-- NOTE: Create these users in Supabase Auth dashboard or via API, then run profile insert.
insert into ecom_user_profiles (user_id, name, phone, is_admin, referral_code, account_status) values
  ('u1000001-0001-4001-8001-000000000001', 'Aisha Khan', '+919876543210', false, 'AISHA01', 'active'),
  ('u1000001-0001-4001-8001-000000000002', 'Store Admin', null, true, 'ADMIN01', 'active')
on conflict (user_id) do nothing;

-- Demo address for Aisha
insert into ecom_addresses (id, user_id, name, phone, address_line_1, city, state, pincode, address_type, is_default) values
  ('d1000001-0001-4001-8001-000000000001',
   'u1000001-0001-4001-8001-000000000001',
   'Aisha Khan', '+919876543210', '12 MG Road', 'Mumbai', 'Maharashtra', '400001', 'home', true)
on conflict (id) do nothing;

update ecom_user_profiles set default_address_id = 'd1000001-0001-4001-8001-000000000001'
where user_id = 'u1000001-0001-4001-8001-000000000001';

-- Demo orders
insert into ecom_orders (
  id, order_number, user_id, status, subtotal, delivery_fee, discount, total,
  payment_method, payment_status, estimated_delivery
) values
  (
    'o1000001-0001-4001-8001-000000000001', 'DQ-24001',
    'u1000001-0001-4001-8001-000000000001', 'confirmed',
    599, 49, 0, 648, 'UPI', 'paid', current_date + 3
  ),
  (
    'o1000001-0001-4001-8001-000000000002', 'DQ-24002',
    'u1000001-0001-4001-8001-000000000001', 'shipped',
    898, 0, 100, 798, 'Card', 'paid', current_date + 2
  )
on conflict (id) do nothing;

insert into ecom_order_items (order_id, product_id, product_name, product_image, unit_price, unit_mrp, quantity, line_total) values
  ('o1000001-0001-4001-8001-000000000001', 'p1000001-0001-4001-8001-000000000001',
   'Everyday Tee', 'https://picsum.photos/seed/dq1/200/200', 599, 999, 1, 599),
  ('o1000001-0001-4001-8001-000000000002', 'p1000001-0001-4001-8001-000000000002',
   'Ceramic Mug Set', 'https://picsum.photos/seed/dq2/200/200', 449, 699, 2, 898)
on conflict do nothing;

insert into ecom_order_delivery_addresses (order_id, source_address_id, name, phone, address_line_1, city, state, pincode, address_type) values
  ('o1000001-0001-4001-8001-000000000001', 'd1000001-0001-4001-8001-000000000001',
   'Aisha Khan', '+919876543210', '12 MG Road', 'Mumbai', 'Maharashtra', '400001', 'home'),
  ('o1000001-0001-4001-8001-000000000002', 'd1000001-0001-4001-8001-000000000001',
   'Aisha Khan', '+919876543210', '12 MG Road', 'Mumbai', 'Maharashtra', '400001', 'home')
on conflict (order_id) do nothing;

insert into ecom_order_tracking_steps (order_id, title, description, event_at, is_completed, is_current, sort_order) values
  ('o1000001-0001-4001-8001-000000000001', 'Order Placed', 'Your order has been placed', now() - interval '1 day', true, false, 1),
  ('o1000001-0001-4001-8001-000000000001', 'Confirmed', 'Order confirmed by store', now() - interval '20 hours', true, true, 2),
  ('o1000001-0001-4001-8001-000000000002', 'Order Placed', 'Your order has been placed', now() - interval '6 hours', true, false, 1),
  ('o1000001-0001-4001-8001-000000000002', 'Shipped', 'Package handed to courier', now() - interval '2 hours', true, true, 2)
on conflict do nothing;

insert into ecom_payments (order_id, user_id, payment_ref, gateway, amount, status, paid_at) values
  ('o1000001-0001-4001-8001-000000000001', 'u1000001-0001-4001-8001-000000000001', 'pay_rzp_demo_001', 'razorpay', 648, 'success', now() - interval '1 day'),
  ('o1000001-0001-4001-8001-000000000002', 'u1000001-0001-4001-8001-000000000001', 'pay_rzp_demo_002', 'razorpay', 798, 'success', now() - interval '6 hours')
on conflict do nothing;

insert into ecom_reviews (product_id, user_id, rating, comment, is_verified_purchase) values
  ('p1000001-0001-4001-8001-000000000001', 'u1000001-0001-4001-8001-000000000001', 5,
   'Love the fabric — fits perfectly.', true)
on conflict (product_id, user_id) do nothing;
