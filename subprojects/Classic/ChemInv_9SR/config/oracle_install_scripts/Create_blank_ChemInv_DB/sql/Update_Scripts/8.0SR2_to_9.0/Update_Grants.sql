--Copyright Cambridgesoft Corp 2001-2005 all rights reserved

-- INV_BROWSER
GRANT SELECT ON inv_well_parent TO INV_BROWSER;
GRANT SELECT ON inv_plate_parent TO INV_BROWSER;
GRANT SELECT ON inv_REPORTPARAMS TO INV_BROWSER;
GRANT SELECT ON INV_CONTAINER_CHECKIN_DETAILS TO INV_BROWSER;
GRANT SELECT ON INV_WELL_COMPOUNDS TO INV_BROWSER;
GRANT SELECT ON INV_COUNTRY TO INV_BROWSER;
GRANT SELECT ON INV_STATES TO INV_BROWSER;
GRANT SELECT ON INV_ADDRESS TO INV_BROWSER;
GRANT SELECT ON INV_REQUEST_TYPES TO INV_BROWSER;
GRANT SELECT ON INV_REQUEST_STATUS TO INV_BROWSER;
GRANT SELECT ON INV_REQUEST_SAMPLES TO INV_BROWSER;
GRANT SELECT ON INV_ORDER_STATUS TO INV_BROWSER;
GRANT SELECT ON INV_ORDERS TO INV_BROWSER;
GRANT SELECT ON INV_ORDER_CONTAINERS TO INV_BROWSER;
GRANT SELECT ON INV_VW_WELL_FLAT TO INV_BROWSER;

GRANT EXECUTE ON LookUpValue TO INV_BROWSER;
GRANT EXECUTE ON InsertCheckInDetails TO INV_BROWSER;
GRANT EXECUTE ON Reservations TO INVBROWSER;

--INV_CHEMIST

-- INV_RECEIVING

-- INV_FINANCE

-- INV_REGRISTRAR

-- INV_ADMIN
GRANT INSERT,UPDATE,DELETE ON inv_well_parent TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON inv_plate_parent TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_COUNTRY TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_STATES TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_ADDRESS TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_REQUEST_TYPES TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_REQUEST_STATUS TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_REQUEST_SAMPLES TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_ORDER_STATUS TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_ORDERS TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_ORDER_CONTAINERS TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_CONTAINER_CHECKIN_DETAILS TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_SOLVENTS TO INV_ADMIN;
GRANT INSERT,UPDATE,DELETE ON INV_WELL_COMPOUNDS TO INV_ADMIN;
GRANT INSERT, UPDATE, DELETE ON INV_REPORTPARAMS TO INV_ADMIN;
GRANT INSERT, UPDATE, DELETE ON INV_OWNERS TO INV_ADMIN;
GRANT SELECT ON inv_VW_AUDIT_COLUMN_DISP TO INV_ADMIN;

GRANT EXECUTE ON DeleteTableRow TO INV_ADMIN;
GRANT EXECUTE ON reportparams TO inv_admin;
GRANT EXECUTE ON InsertCheckInDetails TO INV_ADMIN;
GRANT EXECUTE ON UpdateAddress TO INV_ADMIN;
GRANT EXECUTE ON CertifyContainer TO INV_ADMIN;
GRANT EXECUTE ON Approvals TO INV_ADMIN;



-- Grant to cs_security