-- TRANSACTION

-- Series of statements, treated as group, with the posibility of being commited
-- or undone (rolled back), in case of failure or for specific purposes.

-- Properties of a transaction: ACID
-- Atomic, atomicity means that it is a single unit of work.
-- Consistent, takes care of data integrity, every rule or contraint must be completed.
-- Isolated, each transaction uses only the specific part of the data that will need.
-- Durable, after it is completed, its effects are permanent.

