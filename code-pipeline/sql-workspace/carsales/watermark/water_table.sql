-- Create Water Mark Table 
CREATE TABLE water_table
(
	last_load VARCHAR(2000)
);

-- Insert Initialize Date to Water Mark  
INSERT INTO water_table VALUES('DT00000');

select count(*) from source_cars_data where DATE_ID > 'DT00000';


-- 	Create Procedure for exec
CREATE PROCEDURE UpdateWatermarkTable
	@lastload VARCHAR(200)
AS
BEGIN
	-- Start the transaction
	BEGIN TRANSACTION;

	-- Update the incremental column in the table
	UPDATE water_table
	SET last_load = @lastload
	COMMIT TRANSACTION;
	END;

