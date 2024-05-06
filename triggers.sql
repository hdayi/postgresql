--****************************************--
-----------------TRIGGERS-------------------
--****************************************--

--Triggers are used when you want an action to automatically occur when an event occurs. 
--Common events include the commands insert, update, delete and truncate. 
--Triggers can also be associated with tables, foreign tables or views. 
--Triggers can execute before or after an event executes. 
--Triggers also can execute instead of another event.
--You can put multiple triggers on a table and they execute in alphabetical order. 
--They can’t be triggered manually by a user. Triggers also can’t receive parameters.
--If a Trigger is Row Level the Trigger is called for each row that is modified. 
--If a Trigger is Statement level it will execute once regardless of the number of rows. 
--When can you perform certain actions with triggers SLIDE
--This table shows what triggers can execute based on when they are to execute. 
--For example if a trigger is to execute Before if an event is insert, update, or delete 
--it can perform actions on tables if row level and on tables or views if at statement level. 
--
--Pros of Triggers SLIDE
--* Can be used for auditing, so if something is deleted a trigger could save it in case it is needed later
--* They can be used to validate data
--* Make certain events always happen to maintain integrity of data
--* Insure integrity between different databases
--* They can call functions or procedures
--* Triggers are recursive so a trigger on a table can call another table with a trigger 
--Cons of Triggers SLIDE
--* Triggers add execution overhead
--* Nested / recursive trigger errors can be hard to debug
--* Invisible to the client which can cause confusion when actions aren’t allowed

-- Once bir function yazip sonra trigger'i olusturuyoruz
-- trigger icinden bu function'i cagiriyoruz
---- Create trigger function
--      CREATE FUNCTION trigger_function()
--        RETURNS TRIGGER
--        LANGUAGE PLPGSQL
--      AS
--      $body$
--      BEGIN
--      END;
--      $body$
--
--      -- Create trigger
--      CREATE TRIGGER trigger_name
--        {BEFORE | AFTER} {event} -- Event : insert, update, insert
--      ON table_name
--        [FOR [EACH] {ROW | STATEMENT}]
--          EXECUTE PROCEDURE trigger_function
--
--Ornek olarak bir  tablo olusturalim ve bu tabloda isim degistiginde calisan bir trigger yazalim

--Trigger Data Logging / Auditing
-- Log changes to distributor table
    --CREATE TABLE test.distributor(
    --	id SERIAL PRIMARY KEY,
    --	name VARCHAR(100));
    --	
    ---- Insert distributors
    --INSERT INTO test.distributor (name) VALUES
    --('Parawholesale'),
    --('J & B Sales'),
    --('Steel City Clothing');
    --
    --SELECT * FROM distributor;

--simdi de degisiklikleri kaydedecegimiz bir tablo olusturalim
-- Table that stores changes to distributor
    --CREATE TABLE test.distributor_audit(
    --	id SERIAL PRIMARY KEY,
    --	dist_id INT NOT NULL,
    --	name VARCHAR(100) NOT NULL,
    --	edit_date TIMESTAMP NOT NULL);


  --trigger icin function yazalim
  -- Create trigger function
--      CREATE OR REPLACE FUNCTION test.fn_log_dist_name_change()
--        RETURNS TRIGGER
--      AS
--      $body$
--      BEGIN
--        -- If name changes log the change
--        IF NEW.name <> OLD.name THEN
--          INSERT INTO test.distributor_audit
--          (dist_id, name, edit_date)
--          VALUES
--          (OLD.id, OLD.name, NOW());
--        END IF;
--        
--        -- Trigger information Variables
--        RAISE NOTICE 'Trigger Name : %', TG_NAME;
--        RAISE NOTICE 'Table Name : %', TG_TABLE_NAME;
--        RAISE NOTICE 'Operation : %', TG_OP;
--        RAISE NOTICE 'When Executed : %', TG_WHEN;
--        RAISE NOTICE 'Row or Statement : %', TG_LEVEL;
--        RAISE NOTICE 'Table Schema : %', TG_TABLE_SCHEMA;
--        
--        -- Return the updated new data
--        RETURN NEW;
--      END;
--      $body$
--        LANGUAGE PLPGSQL;



--trigger schema icinde degil db bazinda yaziliyor yani test.tr==== demeye gerek yok
--
    --    CREATE TRIGGER tr_dist_name_changed
    --      -- Call function before name is updated
    --      BEFORE UPDATE 
    --      ON test.distributor
    --      -- We want to run this on every row where an update occurs
    --      FOR EACH ROW
    --      EXECUTE PROCEDURE test.fn_log_dist_name_change();


-- Update distributor name and log changes
--        UPDATE test.distributor
--        SET name = 'Western Clothing'
--        WHERE id = 2;
--
--        -- Check the log
--        SELECT * FROM test.distributor_audit; 

--Conditional Triggers
--You can revoke delete on tables for some users, or you can use triggers.
-- Block insert, update and delete on the weekend
--  CREATE OR REPLACE FUNCTION test.fn_block_weekend_changes()
--    RETURNS TRIGGER
--    LANGUAGE PLPGSQL
--    AS
--    $body$
--    BEGIN
--      RAISE NOTICE 'No database changes allowed on the weekend';
--      RETURN NULL;
--    END;
--    $body$;

    -- Bind function to trigger
--  CREATE TRIGGER tr_block_weekend_changes
--    -- Call function before name is updated
--    BEFORE UPDATE OR INSERT OR DELETE OR TRUNCATE 
--    ON test.distributor
--    -- We want to run this on statement level
--    FOR EACH STATEMENT
--    -- Block if on weekend
--    WHEN(
--      EXTRACT('DOW' FROM CURRENT_TIMESTAMP) BETWEEN 6 AND 7
--    )
--    EXECUTE PROCEDURE test.fn_block_weekend_changes();


--UPDATE test.distributor
--SET name = 'Western Clothing'
--WHERE id = 2; 
--
---- Drop triggers
--DROP EVENT TRIGGER tr_block_weekend_changes;


