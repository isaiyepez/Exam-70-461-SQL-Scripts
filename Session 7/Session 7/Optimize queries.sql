
-- HASH JOIN

-- Different join types
-- 1. Hash match
-- 2. Nested loop match (one small table, one large table). If the bigger table is indexed, it's quite
--    efficient.
-- 3. Merge match (larger tables, sorted on join)
-- *Unique clustered indexes are better than clustered indexes

-- Merge match is the most efficient, then Nested loop match and last Hash match.

-- SARG -Search ARGuments

-- SARG can use indexes.

-- Try to avoid sorting