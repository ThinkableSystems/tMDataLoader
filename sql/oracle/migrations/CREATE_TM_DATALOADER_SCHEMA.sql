-- --------------------------------
-- CREATE_TM_DATALOADER_SCHEMA.sql
-- Run as dba
-- --------------------------------
SET SERVEROUTPUT ON SIZE 99999
SET HEAD OFF

DECLARE
	counts number;
	create_str VARCHAR2(500);
BEGIN
	SELECT count(*) 
	INTO counts
	FROM dba_users
	where username='TM_DATALOADER';

	IF counts > 0
	THEN
		dbms_output.put_line('TM_DATALOADER already exists.');
	ELSE
		dbms_output.put_line('Creating user TM_DATALOADER');

		create_str := 	'CREATE USER TM_DATALOADER identified by tm_dataloader' ||
			   		' DEFAULT TABLESPACE "TRANSMART" TEMPORARY TABLESPACE "TEMP"' ||
					' QUOTA UNLIMITED ON "TRANSMART"' ||
					' QUOTA UNLIMITED ON "INDX"';
		   
		EXECUTE IMMEDIATE create_str;
	END IF;
END;
/
GRANT CREATE SESSION TO TM_DATALOADER;
GRANT RESOURCE TO TM_DATALOADER;
GRANT CREATE TABLE TO TM_DATALOADER;
GRANT CREATE VIEW TO TM_DATALOADER;
GRANT CREATE SYNONYM TO TM_DATALOADER;
GRANT CREATE SEQUENCE TO TM_DATALOADER;
