
-- CREATE THE BIOSARDB SCHEMA AND BIOSAR BROWSER TABLES 
-- ASSUMES YOU HAVE ALREADY RUN THE CS_SECURITY SCRIPT

--#########################################################
-- TABLES
--######################################################### 

@@globals.sql

GRANT select on  BIOSARDB.GLOBALS to PUBLIC;

CREATE TABLE DB_HTTP_CONTENT_TYPE (
	CONTENT_TYPE_ID NUMBER(10) NOT NULL, 
	MIME_TYPE VARCHAR2(30), 
	DESCRIPTION VARCHAR2(250), 
	INDEX_TYPE NUMBER(10) DEFAULT 1 NOT NULL,
    CONSTRAINT CONTENTTYPE_PK PRIMARY KEY(CONTENT_TYPE_ID) 
   	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName) 
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_INDEX_TYPE(
	INDEX_TYPE_ID NUMBER(10) NOT NULL, 
   	INDEX_TYPE VARCHAR2(50) DEFAULT 1, 
	DATA_TYPE VARCHAR2(50),
    CONSTRAINT INDEX_TYPE_PK PRIMARY KEY(INDEX_TYPE_ID)
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName) 
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_XML_TEMPL_DEF(	
	FORMGROUP_ID NUMBER(8,0) NULL,
	TEMPLATE_ID NUMBER(8,0) NULL,
	TEMPLATE_DESC VARCHAR2(500) NULL, 
	TEMPLATE_DEF CLOB NULL,
	CONSTRAINT PK_XML_FGRP_ID 
	PRIMARY KEY (FORMGROUP_ID, TEMPLATE_ID)
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0); 

CREATE TABLE DB_COLUMN (
	COLUMN_ID NUMBER(8,0) NOT NULL,
	TABLE_ID NUMBER(8,0) NOT NULL,
	COLUMN_NAME	VARCHAR2(50) NOT NULL,
	DISPLAY_NAME VARCHAR2(50),
	DESCRIPTION VARCHAR2(100),
	IS_VISIBLE VARCHAR(1) NOT NULL,
	DATATYPE VARCHAR2(20) NOT NULL,
	LOOKUP_TABLE_ID NUMBER(8,0),
	LOOKUP_COLUMN_ID NUMBER(8,0),
	LOOKUP_COLUMN_DISPLAY NUMBER(8,0),
	LOOKUP_JOIN_TYPE VARCHAR2(50),
	LOOKUP_SORT_DIRECT VARCHAR2(10),
	MST_FILE_PATH VARCHAR2(254),
	"LENGTH" NUMBER(8,0),
	"SCALE" NUMBER(8,0),
	"PRECISION" NUMBER(8,0),
	DEFAULT_COLUMN_ORDER NUMBER(4,0),
	NULLABLE VARCHAR2(1), 
	CONSTRAINT PK_COLUMN PRIMARY KEY (COLUMN_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0); 

CREATE TABLE DB_SCHEMA (
	OWNER VARCHAR2(50) NOT NULL,
	DISPLAY_NAME VARCHAR2(100) NOT NULL, 
	SCHEMA_PASSWORD VARCHAR2(100), 
	CONSTRAINT PK_SCHEMA PRIMARY KEY (OWNER) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_TABLE (
	TABLE_ID NUMBER(8,0) NOT NULL,
	OWNER VARCHAR2(50) NOT NULL,
	TABLE_NAME VARCHAR2(50) NOT NULL,
	TABLE_SHORT_NAME VARCHAR2(50) NOT NULL,
	DISPLAY_NAME VARCHAR2(50) NOT NULL,
	BASE_COLUMN_ID NUMBER(8,0),
	DESCRIPTION VARCHAR2(254),
	IS_EXPOSED VARCHAR2(1) DEFAULT 'Y' NOT NULL,
	IS_VIEW VARCHAR2(1) NOT NULL, 
	CONSTRAINT PK_TABLE PRIMARY KEY (TABLE_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0); 

CREATE TABLE DB_RELATIONSHIP (
	COLUMN_ID NUMBER(8,0) NOT NULL,
	TABLE_ID NUMBER(8,0) NOT NULL,
	CHILD_COLUMN_ID NUMBER(8,0) NOT NULL, 
	CHILD_TABLE_ID NUMBER(8,0) NOT NULL, 
	JOIN_TYPE VARCHAR2(50),
	CONSTRAINT PK_DB_RELATIONSHIP PRIMARY KEY (COLUMN_ID, CHILD_COLUMN_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0); 

CREATE TABLE DB_FORMTYPE (
	FORMTYPE_ID NUMBER(8,0) NOT NULL,
	FORMTYPE_NAME VARCHAR2(50) NOT NULL,
	DESCRIPTION VARCHAR2(254) NULL, 
	CONSTRAINT PK_FORMTYPE PRIMARY KEY (FORMTYPE_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0); 

CREATE TABLE DB_FORM_ITEM (
	FORM_ITEM_ID NUMBER(8,0) NOT NULL,
	FORM_ID NUMBER(8,0) NOT NULL,
	TABLE_ID NUMBER(8,0) NOT NULL,
	COLUMN_ID NUMBER(8,0),
	DISP_TYP_ID NUMBER(8,0) NOT NULL,
	DISP_OPT_ID NUMBER(8,0),
	WIDTH NUMBER(8,0),
	HEIGHT NUMBER(8,0),
	COLUMN_ORDER NUMBER(8,0) NOT NULL, 
	CONSTRAINT PK_FORM_ITEM PRIMARY KEY (FORM_ITEM_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0); 

CREATE TABLE DB_DISPLAY_TYPE (
	DISP_TYP_ID NUMBER(8,0) NOT NULL,
	DISP_TYP_NAME VARCHAR2(50) NOT NULL, 
	DEFAULT_WIDTH NUMBER(8,0) NOT NULL,
	DEFAULT_HEIGHT NUMBER(8,0) NOT NULL, 
	CONSTRAINT PK_DISPLAY_TYPE PRIMARY KEY (DISP_TYP_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_DISPLAY_OPTION (
	DISP_OPT_ID NUMBER(8,0) NOT NULL,
	DISP_OPT_NAME VARCHAR2(50) NOT NULL, 
	DISPLAY_NAME VARCHAR2(100), 
	CONSTRAINT PK_DISPLAY_OPTION PRIMARY KEY (DISP_OPT_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_DATATYPE_DISPLAY_TYPE (
	DATATYPE VARCHAR2(50) NOT NULL,
	DISP_TYP_ID NUMBER(8,0) NOT NULL, 
	CONSTRAINT PK_DATYP_DITYP PRIMARY KEY (DATATYPE, DISP_TYP_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_DTYP_DOPT (
	DISP_TYP_ID NUMBER(8,0) NOT NULL,
	DISP_OPT_ID NUMBER(8,0) NOT NULL, 
	CONSTRAINT PK_DTYP_DOPT PRIMARY KEY (DISP_TYP_ID, DISP_OPT_ID)
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_FORMTYPE_DOPT (
	FORMTYPE_ID NUMBER(8,0) NOT NULL,
	DISP_OPT_ID NUMBER(8,0) NOT NULL, 
	CONSTRAINT PK_FORMTYPE_DOPT PRIMARY KEY (FORMTYPE_ID, DISP_OPT_ID)
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_FORMGROUP (
	FORMGROUP_ID NUMBER(8,0) NOT NULL,
	FORMGROUP_NAME VARCHAR2(50) NOT NULL,
	USER_ID VARCHAR2(100), 
	IS_PUBLIC VARCHAR2(1) NOT NULL,
	DESCRIPTION VARCHAR2(254),
	BASE_TABLE_ID NUMBER(8,0),
	CREATED_DATE DATE NOT NULL, 
	CONSTRAINT PK_FORMGROUP PRIMARY KEY (FORMGROUP_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);

CREATE TABLE DB_FORM (
	FORM_ID NUMBER(8,0) NOT NULL,
	FORM_NAME VARCHAR(50) NOT NULL,
	FORMGROUP_ID NUMBER(8,0) NOT NULL,
	FORMTYPE_ID NUMBER(8,0) NOT NULL,
	URL VARCHAR2(254) NULL, 
	CONSTRAINT PK_FORM PRIMARY KEY (FORM_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0); 

CREATE TABLE DB_FORMGROUP_TABLES (
	FORMGROUP_ID NUMBER(8,0) NOT NULL,
	TABLE_ID NUMBER(8,0) NOT NULL,
	TABLE_ORDER NUMBER(8,0),
	TABLE_REL_ORDER NUMBER(8,0),
	DISPLAY_SQL_LIST CLOB, 
	DISPLAY_SQL_DETAIL CLOB, 
	LIST_ALIASES CLOB,
	DETAIL_ALIASES CLOB,
	QUERY_ALIASES CLOB,
	LINKS VARCHAR2(200),
	TABLE_NAME VARCHAR2(200),
	TABLE_DISPLAY_NAME VARCHAR2(200),
	CONSTRAINT PK_FORMGROUP_TABLES PRIMARY KEY (FORMGROUP_ID, TABLE_ID) 
	USING INDEX PCTFREE 0
	TABLESPACE &&indexTableSpaceName
)
TABLESPACE &&tableSpaceName
STORAGE (PCTINCREASE 0);






--#########################################################
-- CREATE FOREIGN KEY CONSTRAINTS
--#########################################################

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_COLUMN.
ALTER TABLE DB_COLUMN
	ADD CONSTRAINT FK_COLUMN_TABLE FOREIGN KEY (
		TABLE_ID)
	 REFERENCES DB_TABLE (
		TABLE_ID); 

ALTER TABLE DB_COLUMN
    ADD(INDEX_TYPE_ID NUMBER(10), CONTENT_TYPE_ID NUMBER(10), 
    CONSTRAINT FK_INDEX_TYPE FOREIGN KEY(INDEX_TYPE_ID) 
    REFERENCES BIOSARDB.DB_INDEX_TYPE(INDEX_TYPE_ID), 
    CONSTRAINT FK_CONTENT_TYPE FOREIGN KEY(CONTENT_TYPE_ID) 
    REFERENCES BIOSARDB.DB_HTTP_CONTENT_TYPE(CONTENT_TYPE_ID));

ALTER TABLE BIOSARDB.DB_FORM_ITEM 
    ADD(V_COLUMN_ID NUMBER(8));

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_RELATIONSHIP.
ALTER TABLE DB_RELATIONSHIP
	ADD CONSTRAINT FK_REL_COLUMN FOREIGN KEY (
		COLUMN_ID)
	 REFERENCES DB_COLUMN (
		COLUMN_ID); 

--ALTER TABLE DB_RELATIONSHIP
ALTER TABLE DB_RELATIONSHIP
	ADD CONSTRAINT FK_REL_CHILD_COLUMN FOREIGN KEY (
		CHILD_COLUMN_ID)
	 REFERENCES DB_COLUMN (
		COLUMN_ID); 

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_FORM_ITEM.
ALTER TABLE DB_FORM_ITEM
 ADD CONSTRAINT FK_FORM_ITEM_FORM
 FOREIGN KEY (FORM_ID)
 REFERENCES DB_FORM (FORM_ID)
 ON DELETE CASCADE;

ALTER TABLE DB_FORM_ITEM
	ADD CONSTRAINT FK_FORM_ITEM_TABLE FOREIGN KEY (
		TABLE_ID)
	 REFERENCES DB_TABLE (
		TABLE_ID); 

ALTER TABLE DB_FORM_ITEM
	ADD CONSTRAINT FK_FORM_ITEM_DISP FOREIGN KEY (
		DISP_TYP_ID)
	 REFERENCES DB_DISPLAY_TYPE (
		DISP_TYP_ID); 

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_DTYP_DOPT

ALTER TABLE DB_DTYP_DOPT
	ADD CONSTRAINT FK_DT_DO_DTYP FOREIGN KEY (
		DISP_TYP_ID)
	 REFERENCES DB_DISPLAY_TYPE (
		DISP_TYP_ID); 

ALTER TABLE DB_DTYP_DOPT
	ADD CONSTRAINT FK_DT_DO_DOPT FOREIGN KEY (
		DISP_OPT_ID)
	 REFERENCES DB_DISPLAY_OPTION (
		DISP_OPT_ID); 

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_DATATYPE_DISPLAY_TYPE

ALTER TABLE DB_DATATYPE_DISPLAY_TYPE
	ADD CONSTRAINT FK_DDT_DTYP FOREIGN KEY (
		DISP_TYP_ID)
	REFERENCES DB_DISPLAY_TYPE (
		DISP_TYP_ID);

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_FORMTYPE_DOPT

ALTER TABLE DB_FORMTYPE_DOPT
	ADD CONSTRAINT FK_FT_FT FOREIGN KEY (
		FORMTYPE_ID)
	 REFERENCES DB_FORMTYPE (
		FORMTYPE_ID); 

ALTER TABLE DB_FORMTYPE_DOPT
	ADD CONSTRAINT FK_FT_DO FOREIGN KEY (
		DISP_OPT_ID)
	 REFERENCES DB_DISPLAY_OPTION (
		DISP_OPT_ID); 

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_FORMGROUP.

ALTER TABLE DB_FORMGROUP
	ADD CONSTRAINT FK_FORMGROUP_COLUMN FOREIGN KEY (
		BASE_TABLE_ID)
	 REFERENCES DB_TABLE (
		TABLE_ID); 

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_FORM.
ALTER TABLE DB_FORM
	ADD CONSTRAINT FK_FORM_FORMTYPE FOREIGN KEY (
		FORMTYPE_ID)
	 REFERENCES DB_FORMTYPE (
		FORMTYPE_ID); 

ALTER TABLE DB_FORM
	ADD CONSTRAINT FK_FORM_FORMGROUP FOREIGN KEY (
		FORMGROUP_ID)
	 REFERENCES DB_FORMGROUP (
		FORMGROUP_ID); 	

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_FORMGROUP_TABLES
ALTER TABLE DB_FORMGROUP_TABLES
 ADD CONSTRAINT FK_FRMGRP_TABLES_FRMGRP
 FOREIGN KEY (FORMGROUP_ID)
 REFERENCES DB_FORMGROUP (FORMGROUP_ID)
 ON DELETE CASCADE;

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_FORMGROUP_TABLES
ALTER TABLE DB_XML_TEMPL_DEF
 ADD CONSTRAINT FK_FRMGRP_TABLE
 FOREIGN KEY (FORMGROUP_ID)
 REFERENCES DB_FORMGROUP (FORMGROUP_ID)
 ON DELETE CASCADE;

ALTER TABLE DB_FORMGROUP_TABLES
	ADD CONSTRAINT FK_FRM_FRMGRP_TABLES_TABLE FOREIGN KEY (
		TABLE_ID)
	REFERENCES DB_TABLE (
		TABLE_ID);

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_COLUMN
ALTER TABLE BIOSARDB.DB_COLUMN 
    ADD (CONSTRAINT FK_COL_ID FOREIGN KEY(LOOKUP_COLUMN_ID ) 
    REFERENCES BIOSARDB.DB_COLUMN(COLUMN_ID)) ;

-- ADD FOREIGN KEY CONSTRAINTS TO TABLE DB_TABLE
ALTER TABLE BIOSARDB.DB_COLUMN 
    ADD (CONSTRAINT FK_COL_DISPL_ID FOREIGN KEY(LOOKUP_COLUMN_DISPLAY ) 
    REFERENCES BIOSARDB.DB_COLUMN(COLUMN_ID)) ;

--#########################################################
--CREATE INDICES
--#########################################################

CREATE INDEX BIOSARDB.DBCOL_TABLE_ID 
    ON BIOSARDB.DB_COLUMN  (TABLE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DBCOL_LKUP_TAB_ID 
    ON BIOSARDB.DB_COLUMN  (LOOKUP_TABLE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DBCOL_LKUP_COL_ID 
    ON BIOSARDB.DB_COLUMN  (LOOKUP_COLUMN_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DBCOL_LKUP_COL_DISP 
    ON BIOSARDB.DB_COLUMN  (LOOKUP_COLUMN_DISPLAY) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255  ;

CREATE INDEX BIOSARDB.DB_FORM_FG_ID_INDX 
    ON BIOSARDB.DB_FORM (FORMGROUP_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_FORM_T_ID_INDX 
    ON BIOSARDB.DB_FORM (FORMTYPE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_FG_INDX 
    ON BIOSARDB.DB_FORMGROUP (BASE_TABLE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_FG_TAB_FG_ID_INDX 
    ON BIOSARDB.DB_FORMGROUP_TABLES (FORMGROUP_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_FG_TAB_T_ID_INDX 
    ON BIOSARDB.DB_FORMGROUP_TABLES (TABLE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_FT_DOPT_INDX 
    ON BIOSARDB.DB_FORMTYPE_DOPT (FORMTYPE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_DO_DOPT_INDX 
    ON BIOSARDB.DB_FORMTYPE_DOPT (DISP_OPT_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_FI_FORM_ID_INDX 
    ON BIOSARDB.DB_FORM_ITEM (FORM_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_FI_TBL_ID_INDX 
    ON BIOSARDB.DB_FORM_ITEM (TABLE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DB_FI_DISP_ID_INDX 
    ON BIOSARDB.DB_FORM_ITEM (DISP_OPT_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;


CREATE INDEX BIOSARDB.DB_FI_COL_ID_INDX 
    ON BIOSARDB.DB_FORM_ITEM (COLUMN_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DBREL_TAB_ID_INDX 
    ON BIOSARDB.DB_RELATIONSHIP (TABLE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DBREL_CHTAB_ID_INDX 
    ON BIOSARDB.DB_RELATIONSHIP (CHILD_TABLE_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DBREL_COL_ID_INDX 
    ON BIOSARDB.DB_RELATIONSHIP (COLUMN_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX BIOSARDB.DBREL_CHCOL_ID_INDX 
    ON BIOSARDB.DB_RELATIONSHIP (CHILD_COLUMN_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;


CREATE INDEX BIOSARDB.DB_TAB_BCI_INDX 
    ON BIOSARDB.DB_TABLE (BASE_COLUMN_ID) TABLESPACE &&indexTableSpaceName PCTFREE 0 INITRANS 2 MAXTRANS 
    255 ;

CREATE INDEX DBCOL_CONTENT_TYPE_ID_IDX
    ON DB_COLUMN  (CONTENT_TYPE_ID)
    TABLESPACE "&&indexTableSpaceName" PCTFREE 0;

CREATE INDEX DATYP_DISP_TYP_ID_IDX
    ON DB_DATATYPE_DISPLAY_TYPE  (DISP_TYP_ID)
    TABLESPACE "&&indexTableSpaceName" PCTFREE 0;

CREATE INDEX DTYP_DOPT_DISP_OPT_ID_IDX
    ON DB_DTYP_DOPT  (DISP_OPT_ID)
    TABLESPACE "&&indexTableSpaceName" PCTFREE 0;

CREATE INDEX DTYP_DOPT_DISP_TYP_ID_IDX
    ON DB_DTYP_DOPT  (DISP_TYP_ID)
    TABLESPACE "&&indexTableSpaceName" PCTFREE 0;

CREATE INDEX XML_TEMPL_DEF_FORMGROUP_ID_IDX
    ON DB_XML_TEMPL_DEF  (FORMGROUP_ID)
    TABLESPACE "&&indexTableSpaceName" PCTFREE 0;


--#########################################################
--CREATE SEQUENCES AND TRIGGERS
--#########################################################

CREATE SEQUENCE DB_FORM_ITEM_SEQ INCREMENT BY 1 START WITH 1000 nocycle;
CREATE SEQUENCE DB_TABLE_SEQ INCREMENT BY 1 START WITH 1000 nocycle;
CREATE SEQUENCE DB_FORM_SEQ INCREMENT BY 1 START WITH 1000 nocycle;
CREATE SEQUENCE DB_COLUMN_SEQ INCREMENT BY 1 START WITH 1000 nocycle;
CREATE SEQUENCE DB_FORMGROUP_SEQ INCREMENT BY 1 START WITH 1000 nocycle;


CREATE OR REPLACE TRIGGER DB_FORM_ITEM_TRIP
BEFORE INSERT ON DB_FORM_ITEM
FOR EACH ROW
BEGIN
SELECT DB_FORM_ITEM_SEQ.NEXTVAL
INTO :NEW.FORM_ITEM_ID
FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER DB_TABLE_TRIG
BEFORE INSERT ON DB_TABLE
FOR EACH ROW
BEGIN
SELECT DB_TABLE_SEQ.NEXTVAL
INTO :NEW.TABLE_ID
FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER DB_FORM_TRIG
BEFORE INSERT ON DB_FORM
FOR EACH ROW
BEGIN
SELECT DB_FORM_SEQ.NEXTVAL
INTO :NEW.FORM_ID
FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER DB_FORMGROUP_TRIG
BEFORE INSERT ON DB_FORMGROUP
FOR EACH ROW
BEGIN
SELECT DB_FORMGROUP_SEQ.NEXTVAL
INTO :NEW.FORMGROUP_ID
FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER DB_COLUMN_TRIG
BEFORE INSERT ON DB_COLUMN
FOR EACH ROW
BEGIN
SELECT DB_COLUMN_SEQ.NEXTVAL
INTO :NEW.COLUMN_ID
FROM DUAL;
END;
/




--#########################################################
--CREATE VIEWS
--#########################################################

--DGB removed because DB_VW_COL_CONSTRAINTS was being created in the system schema!
--Connect &&InstallUser/&&sysPass@&&serverName

CREATE OR REPLACE VIEW DB_VW_COL_CONSTRAINTS
	AS
	SELECT 
		ALL_CONS_COLUMNS.OWNER,ALL_CONS_COLUMNS.CONSTRAINT_NAME,ALL_CONS_COLUMNS.TABLE_NAME, 
   		ALL_CONS_COLUMNS.COLUMN_NAME, ALL_CONS_COLUMNS.POSITION, ALL_CONSTRAINTS.CONSTRAINT_TYPE, ALL_CONSTRAINTS.R_CONSTRAINT_NAME
	FROM ALL_CONS_COLUMNS, ALL_CONSTRAINTS
	WHERE ALL_CONS_COLUMNS.CONSTRAINT_NAME = ALL_CONSTRAINTS.CONSTRAINT_NAME;


Connect &&schemaName/&&schemaPass@&&serverName

CREATE OR REPLACE VIEW DB_VW_CHILD_TABLES 
	AS
   	SELECT 
		COLUMN_NAME AS CHILD_COLUMN_NAME, DATATYPE, PRECISION,
		TABLE_NAME AS CHILD_TABLE_NAME, OWNER, DB_RELATIONSHIP.COLUMN_ID,
		DB_RELATIONSHIP.TABLE_ID,DB_RELATIONSHIP.JOIN_TYPE
   	FROM 
		DB_TABLE, DB_RELATIONSHIP, DB_COLUMN
  	WHERE 
		DB_RELATIONSHIP.CHILD_TABLE_ID = DB_TABLE.TABLE_ID
		AND DB_RELATIONSHIP.CHILD_COLUMN_ID = DB_COLUMN.COLUMN_ID;

CREATE OR REPLACE VIEW DB_VW_TABLE_SCHEMA 
	AS
   	SELECT 
		DB_SCHEMA.DISPLAY_NAME AS SCHEMA_NAME,
		DB_TABLE.TABLE_ID,DB_TABLE.OWNER,DB_TABLE.TABLE_NAME,DB_TABLE.TABLE_SHORT_NAME,
  		DB_TABLE.DISPLAY_NAME,DB_TABLE.BASE_COLUMN_ID,DB_TABLE.DESCRIPTION,DB_TABLE.IS_EXPOSED,DB_TABLE.IS_VIEW
    	FROM 
		DB_SCHEMA, DB_TABLE
    	WHERE 
		DB_TABLE.OWNER = DB_SCHEMA.OWNER;

CREATE OR REPLACE VIEW DB_VW_PARENT_TABLES 
	AS
   	SELECT 
		COLUMN_NAME AS PARENT_COLUMN_NAME, DATATYPE, PRECISION,
          	TABLE_NAME AS PARENT_TABLE_NAME, OWNER,
         	 DB_RELATIONSHIP.CHILD_COLUMN_ID, DB_RELATIONSHIP.TABLE_ID,
          	DB_RELATIONSHIP.CHILD_TABLE_ID, DB_RELATIONSHIP.COLUMN_ID,DB_RELATIONSHIP.JOIN_TYPE
    	FROM 
		DB_TABLE, DB_RELATIONSHIP, DB_COLUMN
   	WHERE 
		DB_RELATIONSHIP.TABLE_ID = DB_TABLE.TABLE_ID
      		AND DB_COLUMN.COLUMN_ID = DB_RELATIONSHIP.COLUMN_ID;

CREATE OR REPLACE VIEW db_vw_formitems_compact 
	AS
	SELECT
		(select formgroup_id from biosardb.db_form where fi.form_id = db_form.form_id) as formgroup_id,
		(select formtype_id from biosardb.db_form where  fi.form_id=db_form.form_id) as formtype_id,
		(select distinct table_order from biosardb.db_formgroup_tables ft where ft.table_id=fi.table_id and ft.formgroup_id=(select formgroup_id from biosardb.db_form where fi.form_id = db_form.form_id)) as table_order,
		fi.column_order as column_order,
		(select table_name from biosardb.db_table bt where bt.table_id = fi.table_id) as table_name,table_id as table_id,
		(select display_name from biosardb.db_table bt where bt.table_id = fi.table_id) as table_display_name,
		(select column_name from biosardb.db_column where column_id = (select base_column_id from db_table where fi.table_id=db_table.table_id)) as base_column_name ,
		(select column_name from biosardb.db_column ct where ct.column_id = fi.column_id) as column_name,
		(select display_name from biosardb.db_column ct where ct.column_id = fi.column_id) as display_name,
		fi.width as width, fi.height as height,
		(select datatype from biosardb.db_column ct where ct.column_id = fi.column_id) as data_type,
		(select disp_opt_name from biosardb.db_display_option where  biosardb.db_display_option.disp_opt_id= fi.disp_opt_id)as display_option,
		(select disp_typ_name from biosardb.db_display_type where  biosardb.db_display_type.disp_typ_id= fi.disp_typ_id)as display_type_name,
		(select column_id from biosardb.db_column ct where ct.column_id = fi.column_id)  as column_id,
		(select lookup_column_display from biosardb.db_column ct where ct.column_id = fi.column_id)  as lookup_display_column__id,
		(select table_name from biosardb.db_table,biosardb.db_column where fi.column_id=db_column.column_id and db_column.lookup_table_id = db_table.table_id) as lookup_table_name ,
		(select biosardb.db_table.table_id  from biosardb.db_table,biosardb.db_column where fi.column_id=db_column.column_id and db_column.lookup_table_id = db_table.table_id) as lookup_table_id ,
		(select ct2.column_name from biosardb.db_column ct2, biosardb.db_column ct1 where ct1.lookup_column_id = ct2.column_id and fi.column_id = ct1.column_id) as lookup_column_name,
		(select ct2.column_name from biosardb.db_column ct2, biosardb.db_column ct1 where ct1.lookup_column_display = ct2.column_id and fi.column_id = ct1.column_id) as lookup_display_column,
		(select ct2.display_name from biosardb.db_column ct2, biosardb.db_column ct1 where ct1.lookup_column_display = ct2.column_id and fi.column_id = ct1.column_id) as lookup_display_name,
		(select lookup_join_type from biosardb.db_column ct where ct.column_id = fi.column_id) as lookup_join_type,
		(select lookup_sort_direct from biosardb.db_column ct where ct.column_id = fi.column_id) as lookup_sort_direction,
		(select ct2.datatype from biosardb.db_column ct2, biosardb.db_column ct1 where ct1.lookup_column_display = ct2.column_id and fi.column_id = ct1.column_id) as lookup_display_datatype
	FROM 
		biosardb.db_form_item fi
	WHERE 
		fi.form_id >0
	ORDER BY 
		formtype_id,table_order,column_order asc;

CREATE OR REPLACE VIEW DB_VW_FORMITEMS_ALL 
	AS
   	SELECT 
		DB_FORM_ITEM.FORM_ITEM_ID, DB_FORM_ITEM.WIDTH, DB_FORM_ITEM.HEIGHT,
          	DB_FORM_ITEM.COLUMN_ORDER, DB_FORM_ITEM.TABLE_ID,
          	DB_FORM_ITEM.COLUMN_ID, DB_FORM.FORM_ID,DB_FORM.FORM_NAME,DB_FORM.FORMGROUP_ID,DB_FORM.FORMTYPE_ID,DB_FORM.URL,
	  	DB_DISPLAY_TYPE.DISP_TYP_ID,DB_DISPLAY_TYPE.DISP_TYP_NAME,DB_DISPLAY_TYPE.DEFAULT_WIDTH,DB_DISPLAY_TYPE.DEFAULT_HEIGHT, 
          	DB_DISPLAY_OPTION.DISP_OPT_ID, DB_DISPLAY_OPTION.DISP_OPT_NAME, DB_DISPLAY_OPTION.DISPLAY_NAME AS DISP_OPT_DISPLAY_NAME,
          	DB_TABLE.OWNER, DB_TABLE.TABLE_NAME, DB_TABLE.TABLE_SHORT_NAME,
          	DB_TABLE.DISPLAY_NAME AS TABLE_DISPLAY_NAME, DB_TABLE.BASE_COLUMN_ID,
          	DB_TABLE.DESCRIPTION AS TABLE_DESCRIPTION, DB_TABLE.IS_VIEW,
          	DB_COLUMN.COLUMN_NAME, DB_COLUMN.DISPLAY_NAME, DB_COLUMN.DESCRIPTION,
          	DB_COLUMN.IS_VISIBLE, DB_COLUMN.DATATYPE, DB_COLUMN.LOOKUP_TABLE_ID,
          	DB_COLUMN.LOOKUP_COLUMN_ID, DB_COLUMN.LOOKUP_COLUMN_DISPLAY,DB_COLUMN.LOOKUP_JOIN_TYPE,DB_COLUMN.LOOKUP_SORT_DIRECT,
          	DB_COLUMN.MST_FILE_PATH, DB_COLUMN.LENGTH, DB_COLUMN.SCALE,
          	DB_COLUMN.PRECISION, DB_COLUMN.NULLABLE, DB_FORM_ITEM.V_COLUMN_ID,DB_COLUMN.DEFAULT_COLUMN_ORDER,
          	DB_FORMGROUP_TABLES.TABLE_ORDER
     	FROM 
		DB_FORM_ITEM,
         	DB_FORM,
          	DB_COLUMN,
          	DB_TABLE,
          	DB_DISPLAY_TYPE,
         	DB_DISPLAY_OPTION,
          	DB_FORMGROUP_TABLES
    	WHERE 
		DB_FORM_ITEM.FORM_ID = DB_FORM.FORM_ID
      		AND DB_FORM_ITEM.COLUMN_ID = DB_COLUMN.COLUMN_ID(+)
     		AND DB_FORM_ITEM.TABLE_ID = DB_TABLE.TABLE_ID
      		AND DB_FORM_ITEM.DISP_TYP_ID = DB_DISPLAY_TYPE.DISP_TYP_ID(+)
      		AND DB_FORM_ITEM.DISP_OPT_ID = DB_DISPLAY_OPTION.DISP_OPT_ID(+)
      		AND DB_FORM.FORMGROUP_ID = DB_FORMGROUP_TABLES.FORMGROUP_ID
      		AND DB_FORM_ITEM.TABLE_ID  = DB_FORMGROUP_TABLES.TABLE_ID;




CREATE OR REPLACE VIEW DB_VW_COLUMN_TABLE 
	AS
	SELECT 
		DB_TABLE.TABLE_NAME, DB_TABLE.OWNER,
		DB_COLUMN.COLUMN_ID,DB_COLUMN.TABLE_ID,DB_COLUMN.COLUMN_NAME,DB_COLUMN.DISPLAY_NAME,
		DB_COLUMN.DESCRIPTION,DB_COLUMN.IS_VISIBLE,DB_COLUMN.DATATYPE,DB_COLUMN.LOOKUP_TABLE_ID,
		DB_COLUMN.LOOKUP_COLUMN_ID,DB_COLUMN.LOOKUP_COLUMN_DISPLAY,DB_COLUMN.LOOKUP_JOIN_TYPE,
		DB_COLUMN.LOOKUP_SORT_DIRECT,DB_COLUMN.MST_FILE_PATH,DB_COLUMN.LENGTH,DB_COLUMN.SCALE,
		DB_COLUMN.PRECISION,DB_COLUMN.DEFAULT_COLUMN_ORDER,DB_COLUMN.NULLABLE,DB_COLUMN.INDEX_TYPE_ID,
		DB_COLUMN.CONTENT_TYPE_ID,
        	DB_TABLE.TABLE_SHORT_NAME
	FROM 
		DB_COLUMN, DB_TABLE
	WHERE 
		DB_COLUMN.TABLE_ID = DB_TABLE.TABLE_ID;

CREATE OR REPLACE VIEW DB_VW_FORMGROUP_TABLES
	AS
	SELECT 
		DB_FORMGROUP_TABLES.FORMGROUP_ID, DB_FORMGROUP_TABLES.TABLE_ID,
   		DB_FORMGROUP_TABLES.TABLE_ORDER, DB_FORMGROUP_TABLES.TABLE_REL_ORDER, 
		DB_FORMGROUP_TABLES.DISPLAY_SQL_DETAIL, DB_FORMGROUP_TABLES.DISPLAY_SQL_LIST, 
		DB_FORMGROUP_TABLES.LIST_ALIASES,DB_FORMGROUP_TABLES.DETAIL_ALIASES,QUERY_ALIASES,
		DB_FORMGROUP_TABLES.LINKS,DB_FORMGROUP_TABLES.TABLE_NAME,DB_FORMGROUP_TABLES.TABLE_DISPLAY_NAME,
    		DB_TABLE.BASE_COLUMN_ID,(SELECT COLUMN_NAME FROM DB_COLUMN WHERE COLUMN_ID=BASE_COLUMN_ID) AS BASE_COLUMN_NAME
	FROM 
		DB_FORMGROUP_TABLES, DB_TABLE
	WHERE 
		DB_FORMGROUP_TABLES.TABLE_ID = DB_TABLE.TABLE_ID;

    
Connect &&schemaName/&&schemaPass@&&serverName

-- INSERT DATA 
--INDEX_TYPES

INSERT INTO DB_INDEX_TYPE  (INDEX_TYPE_ID ,INDEX_TYPE, DATA_TYPE ) VALUES ('0' ,'UNKNOWN','' );
INSERT INTO DB_INDEX_TYPE  (INDEX_TYPE_ID ,INDEX_TYPE, DATA_TYPE ) VALUES ('1' ,'NO_INDEX','BLOB');
INSERT INTO DB_INDEX_TYPE  (INDEX_TYPE_ID ,INDEX_TYPE, DATA_TYPE ) VALUES ('2' ,'CS_CARTRIDGE','CLOB');
INSERT INTO DB_INDEX_TYPE  (INDEX_TYPE_ID ,INDEX_TYPE, DATA_TYPE ) VALUES ('3' ,'NO_INDEX','CLOB');
INSERT INTO DB_INDEX_TYPE  (INDEX_TYPE_ID ,INDEX_TYPE, DATA_TYPE ) VALUES ('4' ,'CS_CARTRIDGE','BLOB');

--CONTENTTYPES
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('0' ,'UNKNOWN' ,'UNKNOWN' ,'0' );
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('1' ,'IMAGE/JPEG' ,'JPEG IMAGE','1');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('2' ,'IMAGE/GIF' ,'GIF IMAGE' ,'1');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('3' ,'IMAGE/PNG' ,'PNG IMAGE','1');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('4' ,'IMAGE/X-WMF' ,'WMF IMAGE','1');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('5' ,'CHEMICAL/X-CDX' ,'CHEMDRAW IMAGE' ,'2');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('6' ,'CHEMICAL/X-MDL-MOLFILE' ,'MOLFILE' ,'2');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('7' ,'CHEMICAL/X-CDX' ,'CHEMDRAW BINARY OBJECT' ,'4');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('8' ,'CHEMICAL/X-SMILES' ,'SMILES' ,'2');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('9' ,'TEXT/XML' ,'CHEMDRAW XML (CDXML)' ,'2');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('10' ,'TEXT/XML' ,'XML' ,'3');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('11' ,'TEXT/HTML' ,'HTML' ,'3');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('12' ,'TEXT/PLAIN' ,'PLAIN TEXTt' ,'3');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('13' ,'TEXT/RAW','RAW TEXT' ,'3');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('14' ,'Application/ms-excel','MS EXCEL document' ,'1');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('15' ,'Application/msword','MS WORD document' ,'1');
INSERT INTO DB_HTTP_CONTENT_TYPE (CONTENT_TYPE_ID ,MIME_TYPE ,DESCRIPTION ,INDEX_TYPE) VALUES ('16' ,'Application/pdf','ADOBE PDF document' ,'1');
-- FORMTYPE;

INSERT INTO DB_FORMTYPE ( FORMTYPE_ID, FORMTYPE_NAME, DESCRIPTION) VALUES ('1', 'QUERY', 'QUERY FORM'); 
INSERT INTO DB_FORMTYPE ( FORMTYPE_ID, FORMTYPE_NAME, DESCRIPTION ) VALUES ( '2', 'LIST', 'LIST FORM'); 
INSERT INTO DB_FORMTYPE ( FORMTYPE_ID, FORMTYPE_NAME, DESCRIPTION) VALUES ( '3', 'DETAIL', 'DETAIL FORM'); 

-- DISPLAY TYPE

INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'1', 'TEXTBOX', '70', '-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'2', 'TEXTAREA', '70', '4'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'3', 'CHECKBOX', '-1', '-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'4', 'SELECT', '50', '-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'5', 'DATE', '30', '-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'6', 'DATEPICKER', '-1','-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'7', 'STRUCTURE', '300', '200'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'9', 'FORMULA', '70', '-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'10', 'MOLWEIGHT', '70', '-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'11', 'HYPERLINK','100', '-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'12', 'TEXTBOXALLOWLIST', '45', '-1'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'13', 'Graphic-InLine', '50', '50'); 
INSERT INTO DB_DISPLAY_TYPE ( DISP_TYP_ID, DISP_TYP_NAME, DEFAULT_WIDTH, DEFAULT_HEIGHT ) VALUES ( 
'14', 'Graphic-PopUp', '50', '50');


-- DATATYPE - DISPLAY TYPE LINKER

INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'NUMBER', '1'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'NUMBER', '2'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR', '1'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR', '2'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR', '3'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR', '11'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'DATE', '6'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'DATE', '5'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR2', '1'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR2', '2'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR2', '3'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR2', '12'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'VARCHAR', '12'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'NUMBER', '12'); 
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'CLOB', '13');
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'CLOB', '14');
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'BLOB', '14');  
INSERT INTO DB_DATATYPE_DISPLAY_TYPE ( DATATYPE, DISP_TYP_ID ) VALUES ( 
'BLOB', '13'); 
 
-- DISPLAY OPTION

INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'1', 'GIF', 'STATIC GIF IMAGE'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'2', 'CDX', 'CHEMDRAW PLUGIN'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'3', 'FULL', 'FULL URL'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'4', 'LINK', 'SHORT NAME'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'5', 'BOOLEAN', 'TRUE/FALSE'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'6', 'YES_NO', 'YES/NO'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'7', 'RAW', '0 OR 1'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'8', 'GIF', 'CHECKBOX IMAGE'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'11', 'ALLOW_LIST', 'ALLOW LIST SEARCH'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'12', 'STANDARD', 'STANDARD TEXT BOX'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'13', 'IN_LINE', 'IN LINE'); 
INSERT INTO DB_DISPLAY_OPTION ( DISP_OPT_ID, DISP_OPT_NAME, DISPLAY_NAME ) VALUES ( 
'14', 'NEW_WINDOW', 'NEW WINDOW'); 

-- FORMTYPE - DISPLAY OPTION

INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '1'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '2'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '3'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '4'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '5'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '6'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '7'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '8'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '1'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '2'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '3'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '4'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '5'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '6'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '7'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '8'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '13'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'2', '14'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '13'); 
INSERT INTO DB_FORMTYPE_DOPT ( FORMTYPE_ID, DISP_OPT_ID ) VALUES ( 
'3', '14'); 

-- DISPLAY TYPE - DISPLAY OPTION

INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'3', '5'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'3', '6'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'3', '7'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'3', '8'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'7', '2'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'7', '1'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'11', '3'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'11', '4'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'13', '13'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'13', '14'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'14', '13'); 
INSERT INTO DB_DTYP_DOPT ( DISP_TYP_ID, DISP_OPT_ID ) VALUES ( 
'14', '14');
 
COMMIT;

@@pkg_ValidateAndRepairSchema_def.sql;
@@pkg_ValidateAndRepairSchema_body.sql;

@@FastIndexAccess.sql;

SHOW ERRORS;

		
		
		

	