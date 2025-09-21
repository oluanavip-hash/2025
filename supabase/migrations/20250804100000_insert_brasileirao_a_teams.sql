/*
  # [Data Insertion] Add/Update Brasileirão A 25/26 Teams
  [This script inserts or updates the team data for the 25/26 season of Brasileirão A, including new names and image URLs.]

  ## Query Description: [This operation will add 15 new team records to the 'teams' table for the 'Brasileirão A' league. If teams with the new names (e.g., 'São Paulo 25/26 Tailandesa') already exist, their image URLs and price will be updated. This is a safe operation as it does not delete any data and is designed to be run multiple times without causing errors.]

  ## Metadata:
  - Schema-Category: ["Data"]
  - Impact-Level: ["Low"]
  - Requires-Backup: [false]
  - Reversible: [true]

  ## Structure Details:
  - Tables affected: "teams"
  - Columns affected: "name", "league_id", "image1", "image2", "price"

  ## Security Implications:
  - RLS Status: [Assumed Enabled on 'teams']
  - Policy Changes: [No]
  - Auth Requirements: [Requires appropriate permissions to INSERT/UPDATE on 'teams' table.]

  ## Performance Impact:
  - Indexes: [Utilizes the primary key or unique constraint on the 'name' column for conflict resolution.]
  - Triggers: [No new triggers added.]
  - Estimated Impact: [Low. A small batch of inserts/updates.]
*/

-- Insert or Update teams for Brasileirão A 25/26 Season
INSERT INTO teams (name, league_id, image1, image2, price)
VALUES
  ('São Paulo 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/5W43HjpV/img-0289-360c67fa5dc9a83e8117423248016363-1024-1024.webp', 'https://i.ibb.co/xSztSNmc/img-0290-798d34f5574af944c417423248013035-1024-1024.webp', 150.00),
  ('Corinthians 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/9HYQ3JvN/img-1949-1c113f60ac01e9e1fc17479708214901-1024-1024.webp', 'https://i.ibb.co/1JYN6cVD/img-1950-36e6480a02ab36c57617479708214916-1024-1024.webp', 150.00),
  ('Palmeiras 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/r2GB69zC/img-0287-c32dc285d7606c340017423247337855-1024-1024.webp', 'https://i.ibb.co/bqnT3mH/img-0288-10db9efc6aead8e87f17423247338209-1024-1024.webp', 150.00),
  ('Flamengo 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/0VJvrLnt/camisa-flamengo-home1-7d48f68bc5a146987917422432415116-1024-1024.webp', 'https://i.ibb.co/wZ21TWYs/camisa-flamengo-home2-bdfced7d35517379a317422432415703-1024-1024.webp', 150.00),
  ('Athletico Paranaense 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/Y4mrv5pJ/img-1423-978381a44ed8dd49e617460551899878-1024-1024.webp', 'https://i.ibb.co/909JVjc/img-1424-bd946ed14b6f61d6a617460551900104-1024-1024.webp', 150.00),
  ('Atlético-MG 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/tTCFMR4C/img-0263-e61d0bb84493be013517423227209377-1024-1024.webp', 'https://i.ibb.co/h1KHmzj4/img-0264-60cfdf8a3916ce227c17423227208492-1024-1024.webp', 150.00),
  ('Bahia 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/ZzHYjpy5/img-6791-6ab6955f80eb0536fe17151881137818-1024-1024.webp', 'https://i.ibb.co/pBqz238K/img-6792-aa119a11b83fff138a17151881137735-1024-1024.webp', 150.00),
  ('Botafogo 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/SwLR4wrZ/img-1603-ac7f13b1c851ef6d0d17470820582715-1024-1024.webp', 'https://i.ibb.co/4w4F5SdX/img-1604-127d03f1bdff60e75617470820584807-1024-1024.webp', 150.00),
  ('Cruzeiro 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/V0CzyHSj/camisa-cruzeiro-home1-5f4b731da7440803de17449300753667-1024-1024.webp', 'https://i.ibb.co/BVpM53Dm/camisa-cruzeiro-home4-543d0db81cd7de189e17449300741149-1024-1024.webp', 150.00),
  ('Fluminense 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/RksQzqxG/img-6815-712d751e015d2271c417152018447814-1024-1024.webp', 'https://i.ibb.co/nNmfbYj6/img-6816-b74fe67fc472dfd48217152018449033-1024-1024.webp', 150.00),
  ('Fortaleza 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/LfVB2gK/img-0351-3da98ceb5f3d0334d517283383608281-1024-1024.webp', 'https://i.ibb.co/rG2qfwt1/img-0352-052964f58aa54fb80d17283383611957-1024-1024.webp', 150.00),
  ('Grêmio 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/Q7vrjhgb/img-4979-7915b2d3d5f73b834a17113768160452-1024-1024.webp', 'https://i.ibb.co/v4H6LQJh/img-4980-4129760757a6bef51e17113768161843-1024-1024.webp', 150.00),
  ('Internacional 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/Zz5Jrt1g/img-6452-233b9a634224ea4a7f17140785079463-1024-1024.webp', 'https://i.ibb.co/Xf4pFQxh/img-6453-0e61803208ab8e092817140785074121-1024-1024.webp', 150.00),
  ('Santos 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/MxSb3Mqg/img-1438-15ad798b66a1b33b1017460564582168-1024-1024.webp', 'https://i.ibb.co/mVHwmg4S/img-1439-2799464cef620a334d17460564585256-1024-1024.webp', 150.00),
  ('Vasco da Gama 25/26 Tailandesa', (SELECT id from leagues WHERE name = 'Brasileirão A'), 'https://i.ibb.co/qM9MtYGK/img-1651-17d6179e4441a4fc9917476885139359-1024-1024.webp', 'https://i.ibb.co/23757Ffz/img-1652-41ae95e881f5b5e32c17476885137489-1024-1024.webp', 150.00)
ON CONFLICT (name) DO UPDATE SET
  image1 = EXCLUDED.image1,
  image2 = EXCLUDED.image2,
  price = EXCLUDED.price,
  league_id = EXCLUDED.league_id;
