@@parameters.sql
@@prompts2.sql


prompt 'Creating chemical structure index ...'


Connect &&schemaName/&&schemaPass@&&serverName

DECLARE
	PROCEDURE createCartridgeIndex(iName IN varchar2, tName IN varchar2, fName IN varchar2) IS
			n NUMBER;
		BEGIN
			select count(*) into n from user_indexes where Upper(index_name) = iName AND Upper(table_owner)= '&&schemaName';
			if n = 1 then
				execute immediate 'DROP INDEX '||iName||' force';
			end if;
			execute immediate 'CREATE INDEX '||iName|| ' ON ' || tName || '('||fName||')
								indexType is cscartridge.moleculeindextype
								PARAMETERS(''TABLESPACE=&&cscartTableSpaceName'')';
		END createCartridgeIndex;
BEGIN
	createCartridgeIndex('MX', 'substance', 'base64_cdx');
END;
/

prompt 'Synchronizing the index'
ALTER INDEX MX PARAMETERS('SYNCHRONIZE');

prompt 'Computing Index statistics'
ANALYZE INDEX MX COMPUTE STATISTICS;
