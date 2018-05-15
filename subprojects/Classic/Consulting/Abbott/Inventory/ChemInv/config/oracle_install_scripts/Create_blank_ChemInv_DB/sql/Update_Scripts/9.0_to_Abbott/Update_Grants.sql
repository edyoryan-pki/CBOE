--Copyright Cambridgesoft Corp 2001-2005 all rights reserved


-- INV_BROWSER
GRANT SELECT ON INV_CONTAINER_BATCHES TO INV_BROWSER;
GRANT SELECT ON INV_UNIT_CONVERSION_FORMULA TO INV_BROWSER;
GRANT SELECT ON INV_GRAPHICS TO INV_BROWSER;
GRANT SELECT ON INV_GRAPHIC_TYPES TO INV_BROWSER;
GRANT SELECT ON INV_VW_GRID_LOCATION_LITE TO INV_BROWSER;
GRANT SELECT ON INV_DOCS TO INV_BROWSER;
GRANT SELECT ON INV_DOC_TYPES TO INV_BROWSER;
GRANT SELECT ON INV_ORG_UNIT TO INV_BROWSER;
GRANT SELECT ON INV_ORG_ROLES TO INV_BROWSER;
GRANT SELECT ON INV_ORG_USERS TO INV_BROWSER;
GRANT SELECT ON INV_DOC_TYPES TO INV_BROWSER;

--INV_CHEMIST

-- INV_RECEIVING

-- INV_FINANCE

-- INV_REGRISTRAR

-- INV_ADMIN
GRANT SELECT, INSERT, UPDATE, DELETE ON INV_CONTAINER_BATCHES TO INVADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON INV_GRAPHICS TO INVADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON INV_GRAPHIC_TYPES TO INVADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON INV_DOCS TO INVADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON INV_DOC_TYPES TO INVADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON INV_ORG_UNIT TO INVADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON INV_ORG_ROLES TO INVADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON INV_ORG_USERS TO INVADMIN;
GRANT SELECT ON INV_VW_GRID_LOCATION_LITE TO INVADMIN;

GRANT INSERT, UPDATE, DELETE ON INV_UNIT_CONVERSION_FORMULA TO INVADMIN;
