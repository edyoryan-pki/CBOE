
--ALTER SEQUENCE TABLE

ALTER TABLE "REGDB"."SEQUENCE" MODIFY("REG_DELIMITER" DEFAULT NULL, 
									"PREFIX_DELIMITER" DEFAULT NULL);
ALTER TABLE "REGDB"."SEQUENCE" DROP("DUP_CHECK_LOCAL");