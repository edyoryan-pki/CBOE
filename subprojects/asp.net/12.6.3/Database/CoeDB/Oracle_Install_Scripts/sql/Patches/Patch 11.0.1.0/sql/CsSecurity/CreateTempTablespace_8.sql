--Copyright 1999-2010 CambridgeSoft Corporation. All rights reserved

-- Oracle 8i Temp Tablespace syntax

DECLARE
    LExist NUMBER;
BEGIN
    SELECT count(*) INTO LExist FROM DBA_Tablespaces WHERE Tablespace_Name = Upper('&&tempTableSpaceName');    

    IF LExist = 0 and '&&BypassTablespaceCreateAndDrop' = 'N' THEN
        EXECUTE IMMEDIATE 
            'CREATE TABLESPACE &&tempTableSpaceName 
				NOLOGGING
				DATAFILE &&tempTableSpaceFile SIZE &&tempTablespaceSize REUSE
				AUTOEXTEND ON MAXSIZE UNLIMITED
				DEFAULT STORAGE ( INITIAL 1M NEXT 1M MINEXTENTS 1 MAXEXTENTS 
				UNLIMITED PCTINCREASE 0 )TEMPORARY
				ONLINE';
    END IF;
END;
/