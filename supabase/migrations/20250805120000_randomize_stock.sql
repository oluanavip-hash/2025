/*
# [Operation Name]
Randomize and Ensure Stock for All Products

## Query Description: [This operation updates the stock for all products and sizes. It assigns a random stock quantity between 10 and 100 to each size ('P', 'M', 'G', 'GG', 'XG') for every product in the store. If a stock record doesn't exist for a specific product/size combination, it will be created. This ensures no product is out of stock and introduces variability. Existing stock levels will be overwritten.]

## Metadata:
- Schema-Category: ["Data"]
- Impact-Level: ["Medium"]
- Requires-Backup: true
- Reversible: false

## Structure Details:
- Table Affected: public.product_stock
- Columns Affected: stock_quantity, updated_at

## Security Implications:
- RLS Status: Enabled
- Policy Changes: No
- Auth Requirements: Admin privileges required to run this migration.

## Performance Impact:
- Indexes: Uses the primary key or unique constraint on (team_id, size) for the upsert operation.
- Triggers: May fire update/insert triggers on the product_stock table.
- Estimated Impact: Medium load during execution, as it iterates through all products and sizes. Should be run during off-peak hours if the product catalog is very large.
*/

DO $$
DECLARE
    team_record RECORD;
    size_item TEXT;
    sizes TEXT[] := ARRAY['P', 'M', 'G', 'GG', 'XG'];
    random_stock_quantity INT;
BEGIN
    -- Loop through each team in the 'teams' table
    FOR team_record IN SELECT id FROM public.teams LOOP
        -- Loop through each size in the predefined array
        FOREACH size_item IN ARRAY sizes
        LOOP
            -- Generate a random stock quantity between 10 and 100 (inclusive)
            random_stock_quantity := floor(random() * 91) + 10;

            -- Use an UPSERT operation to either insert a new stock record or update an existing one.
            -- This ensures that every product has a stock entry for every size.
            INSERT INTO public.product_stock (team_id, size, stock_quantity, created_at, updated_at)
            VALUES (team_record.id, size_item, random_stock_quantity, now(), now())
            ON CONFLICT (team_id, size)
            DO UPDATE SET
                stock_quantity = random_stock_quantity,
                updated_at = now();
        END LOOP;
    END LOOP;
END $$;
