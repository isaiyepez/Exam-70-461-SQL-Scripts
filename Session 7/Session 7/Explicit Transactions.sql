
--NOTE: ALL data manipulation is working as transaction behind scenes.

BEGIN TRANSACTION

COMMIT TRANSACTION

ROLLBACK TRANSACTION

-- Keep in mind that if you forget to commit or rollback your transaction, you will lock 
-- the table forever, unless you have no rows matching the criteria of the transaction