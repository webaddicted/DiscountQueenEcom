-- Enable Supabase Realtime on key ecom tables
alter publication supabase_realtime add table ecom_cart_items;
alter publication supabase_realtime add table ecom_orders;
alter publication supabase_realtime add table ecom_user_notifications;
alter publication supabase_realtime add table ecom_products;
