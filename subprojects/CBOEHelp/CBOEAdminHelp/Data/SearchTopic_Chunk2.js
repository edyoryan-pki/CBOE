define({"143":{i:0.00123380719032761,u:"../Content/COEWebserver/data_ini_settings/CONNECTION_PASSWORD.htm",a:"   CONNECTION_PASSWORD  Example: CONNECTION_PASSWORD= \"\"               \n              \n            Description: Contains \nthe password for the connection.  If there is a password and you are using a DBQ or DSN \nthen see the  See Connection Passwords Tables section under \" Connection Options in ...",t:"CONNECTION_PASSWORD"},"144":{i:0.00179669165509867,u:"../Content/COEWebserver/BASE_CFW_FORM.htm",a:"   [BASE_CFW_FORM]      \n              \n     Description: ChemFinder connection names specified \nin \n \n the chem_connections section of the globals section reference connection \nsections elsewhere in the ini file. If a table contains chemical information \nstored by ChemFinder then the ...",t:"BASE_CFW_FORM"},"145":{i:0.00135298164782437,u:"../Content/COEWebserver/STRUC_ENGINE.htm",a:"   STRUC_ENGINE   Example: STRUC_ENGINE = MOLSERVER                \n              \n            Description: Specifies what chemical \nsearch engine is used. The only current option is MOLSERVER, soon to be \nexpanded to include the Oracle Cartridge.       \n         \n  Default: MOLSERVER     \n      \n   ...",t:"STRUC_ENGINE"},"146":{i:0.00135298164782437,u:"../Content/COEWebserver/STRUC_FORM_NAME.htm",a:"   STRUC_FORM_NAME   Example: STRUC_FORM_NAME = sample                \n              \n            Description: The unique portion of \nthe ChemFinder form found in the app/dataview/cfwforms directory. There is both a \nshort and long form. The long form is used for searches the short form is used \nfor ...",t:"STRUC_FORM_NAME"},"147":{i:0.00135298164782437,u:"../Content/COEWebserver/data_ini_settings/STRUC_DB_PATH.htm",a:"   STRUC_DB_PATH   Example: STRUC_DB_PATH = C:\\Inetpub\\wwwroot\\ChemOffice\\sample\\database\\sample.mst                 \n              \n            Description: The path to the mdb \nfile that ChemFinder uses. Even if you are storing all data in Oracle or \nSQLServer, ChemFinder still uses an MDB file to ...",t:"STRUC_DB_PATH"},"148":{i:0.00135298164782437,u:"../Content/COEWebserver/STRUC_TABLE_NAME.htm",a:"   STRUC_TABLE_NAME   Example: STRUC_TABLE_NAME = MolTable                 \n              \n            Description: The name of the table \nthat the STRUC_FORM_NAME opens. This is often MOLTABLE, but may differ depending \non how the original database structure was created.    \n            \n           ...",t:"STRUC_TABLE_NAME"},"149":{i:0.00185380614968844,u:"../Content/COEWebserver/BASE_TABLE_GROUP.htm",a:"   [BASE_TABLE_GROUP]      \n              \n     Description: As with other items in the globals \nsection the TABLE_GROUP key specifies individual table groups else where in the \nini file. Table Groups specify information about what table is the base table \nfor searching, and what table holds the ...",t:"BASE_TABLE_GROUP"},"150":{i:0.00149642977139988,u:"../Content/COEWebserver/BASE_TABLE.htm",a:"   BASE_TABLE   Example: BASE_TABLE = MolTable                 \n              \n            Description: The name of \nthe table whose ids are returned in a search. This is the base table for \nthe dataview.    \n            \n            \n         \n  Default: MolTable    \n      \n       \n      \n         ...",t:"BASE_TABLE"},"151":{i:0.00149642977139988,u:"../Content/COEWebserver/MOLECULE_TABLE.htm",a:"   MOLECULE_TABLE   Example: MOLECULE_TABLE = MolTable                 \n              \n            Description: The name of \nthe table that is searched for checmical data. This may or may not be the \nbase table.    \n            \n            \n         \n  Default: MolTable    \n      \n       \n      \n   ...",t:"MOLECULE_TABLE"},"152":{i:0.00149642977139988,u:"../Content/COEWebserver/TABLE_SQL_ORDER.htm",a:"   TABLE_SQL_ORDER   Example: TABLE_SQL_ORDER = MolTable,Synonyms_r                 \n              \n            Description: The order in which the \ntables are added to a JOIN clause.    \n            \n            \n         \n  Default: MolTable,Synonyms_r    \n      \n       \n      \n         \n    \n     ...",t:"TABLE_SQL_ORDER"},"153":{i:0.00141249537947188,u:"../Content/COEWebserver/MOLTABLE.htm",a:"   [MOLTABLE]      \n              \n     Description: As with other items in the globals \nsection the TABLE_GROUP key specifies individual table groups else where in the \nini file. Table Groups specify information about what table is the base table \nfor searching, and what table holds the structures. ...",t:"MOLTABLE"},"154":{i:0.00141249537947188,u:"../Content/COEWebserver/SYNONYMS_R.htm",a:"   [SYNONYMS_R]      \n              \n     Description: As with other items in the globals \nsection the TABLE_GROUP key specifies individual table groups else where in the \nini file. Table Groups specify information about what table is the base table \nfor searching, and what table holds the ...",t:"SYNONYMS_R"},"155":{i:0.0012653917893997,u:"../Content/COEWebserver/BASE_FORM_GROUP.htm",a:"   [BASE_FORM_GROUP]      \n              \n     Description: The form groups specified in the key, \nreferences individual form group sections elsewhere in the ini file. Form groups \nare a way for ChemOffice Webserver to specify different input and result forms \nand functionality via \n \n \n \n \n \n \n \n ...",t:"BASE_FORM_GROUP"},"156":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/INPUT_FORM_PATH.htm",a:"   INPUT_FORM_PATH   Example: INPUT_FORM_PATH = sample_input_form.asp                \n              \n                  \nDescription: Name of the search input form.    \n            \n            \n         \n  Default: sample_input_form.asp    \n      \n       \n      \n         \n    \n      \n       \n      \n ...",t:"INPUT_FORM_PATH"},"157":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/INPUT_FORM_MODE.htm",a:"   INPUT_FORM_MODE   Example: INPUT_FORM_MODE = search                \n              \n                Description: Mode \nthat is set for the input form.    \n            \n            \n         \n  Default: search    \n      \n       \n      \n         \n    \n      \n       \n      \n   Options: search | \n \n \n ...",t:"INPUT_FORM_MODE"},"158":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/RESULT_FORM_PATH.htm",a:"   RESULT_FORM_PATH   Example: RESULT_FORM_PATH = sample_result_list.asp                \n              \n            Description: Path to the result \nform. If you use standard ChemOffice Webserver terminology dataview_name \u0026 \n\"_result_list.asp\", the single record view is automatically determined as ...",t:"RESULT_FORM_PATH"},"159":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/RESULT_FORM_MODE.htm",a:"   RESULT_FORM_MODE   Example: RESULT_FORM_MODE = list                \n              \n            Description: The view that defaults \nwhen returning results. Options are list or edit. Edit is a historical name and \nmeans the single record view.     \n          \n         \n       \n          \n          ...",t:"RESULT_FORM_MODE"},"160":{i:0.00120166672197821,u:"../Content/COEWebserver/PLUGIN_VALUE.htm",a:"   PLUGIN_VALUE   Example: PLUGIN_VALUE = True                \n              \n            Description: If there are structure, \nmolecular weight or formula fields then this must be TRUE indicating that the \nChemDraw applet should be written into the html output for the form. If \nspecifying FALSE ...",t:"PLUGIN_VALUE"},"161":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/STRUCTURE_FIELDS.htm",a:"Example: STRUCTURE_FIELDS = MolTable.Structure \n\n Description: Name of the table and field for the structure field in ChemFinder. For example, this is often MolTable.Structure. This is case sensitive relative to what is put into the input and result form. If no structure is present then enter NULL. ...",t:"STRUCTURE_FIELDS"},"162":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/FORM_GROUP_FLAG.htm",a:"   FORM_GROUP_FLAG   Example: FORM_GROUP_FLAG = SINGLE_SEARCH                \n              \n            Description: Use SINGLE_SEARCH for standard searching form groups; use \n\"GLOBAL_SEARCH\" when the form group is involved in global search \nfunctionality.      \n            \n            \n           ...",t:"FORM_GROUP_FLAG"},"163":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/MW_FIELDS.htm",a:"   MW_FIELDS   Example: MW_FIELDS = MolTable.MolWeight                \n              \n            Description: Name of the table and \nfield for the molecular weight field in ChemFinder. This is often \nMolTable.MolWeight. This is case sensitive relative to what is put into the \ninput and result form. ...",t:"MW_FIELDS"},"164":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/FORMULA_FIELDS.htm",a:"   FORMULA_FIELDS   Example: FORMULA_FIELDS = MolTable.Formula                \n              \n            Description: Name of the table and \nfield for the formula field in ChemFinder. This is often MolTable.FORMULA. This \nis case sensitive relative to what is put into the input and result form. If ...",t:"FORMULA_FIELDS"},"165":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/SEARCHABLE_ADO_FIELDS.htm",a:"   SEARCHABLE_ADO_FIELDS   Example: SEARCHABLE_ADO_FIELDS = MolTable.MOL_ID;1,MolTable.Molname;0,Synonyms_r.SYN_ID;1,Synonyms_r.Synonym_r;0                 \n              \n            Description: List of fields and \ntheir datatypes that are in the input form. This list is used by JavaScript to ...",t:"SEARCHABLE_ADO_FIELDS"},"166":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/REQUIRED_FIELDS.htm",a:"   REQUIRED_FIELDS   Example: REQUIRED_FIELDS =  NULL                 \n              \n            Description: Comma delimited list of required \nfields in the \n \n \n \n \n \n \n \n \nform.        \n            \n            \n               \n             \n             \n                \n              \n         ...",t:"REQUIRED_FIELDS"},"167":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/SDFILE_FIELDS.htm",a:"   SDFILE_FIELDS   Example: SDFILE_FIELDS = TABLES:MOLTABLE,SYNONYMS_R                 \n              \n            Description: Internal \n \n \n \n \n \n \n \n \nsetting.        \n            \n            \n               \n             \n             \n                \n              \n         \n          \n       ...",t:"SDFILE_FIELDS"},"168":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/TABLE_GROUP.htm",a:"   TABLE_GROUP   Example: TABLE_GROUP = base_table_group                \n              \n            Description: Name of the table \ngroup that this form_group references. \n \n \n \n \n \n \n \n \n        \n            \n            \n               \n             \n             \n                \n              \n  ...",t:"TABLE_GROUP"},"169":{i:0.00120166672197821,u:"../Content/COEWebserver/data_ini_settings/NUM_LIST_VIEW.htm",a:"   NUM_LIST_VIEW   Example: NUM_LIST_VIEW =  5                \n              \n            Description: Number of records \ndisplayed in list view by default. Making this value higher then 20 makes output \nin list view that has structure, mw or formula fields very \nslow. \n \n \n \n \n \n \n \n \n \n        \n   ...",t:"NUM_LIST_VIEW"},"170":{i:0.0012653917893997,u:"../Content/COEWebserver/BASENP_FORM_GROUP.htm",a:"   [BASENP_FORM_GROUP]      \n              \n     Description: The form groups specified in the key, \nreferences individual form group sections elsewhere in the ini file. Form groups \nare a way for ChemOffice Webserver to specify different input and result forms \nand functionality via \n \n \n \n \n \n \n \n ...",t:"BASENP_FORM_GROUP"},"171":{i:0.0012653917893997,u:"../Content/COEWebserver/ADD_RECORD_FORM_GROUP.htm",a:"   [ADD_RECORD_FORM_GROUP]      \n              \n     Description: The form groups specified in the key, \nreferences individual form group sections elsewhere in the ini file. Form groups \nare a way for ChemOffice Webserver to specify different input and result forms \nand functionality via \n \n \n \n \n \n ...",t:"ADD_RECORD_FORM_GROUP"},"172":{i:0.000948614137963353,u:"../Content/COEWebserver/SHOWBUTTONS (for ChemIndex.ini).htm",a:"This section of the guide shows the button\u0027s management for the ChemIndex.ini. Please refer to the following topics for more information: CHEMACX_BUTTON CHEMACX_LINK CHEMACX_SERVER NCI_BUTTON NCI_LINK NCI_SERVER THEMERCKINDEX_BUTTON THEMERCKINDEX_LINK THEMERCKINDEX_SERVER",t:"SHOWBUTTONS (for ChemIndex.ini)"},"173":{i:0.0019624356635807,u:"../Content/COEWebserver/CHEMACX_BUTTON.htm",a:"   CHEMACX_BUTTON Example: CHEMACX_BUTTON= \n \n OFF   \n   \n                           \n              \n           Description: Indicates if the ChemACX button should \nshow up in the ChemIndex \n \n \n \n application.               \n              \n                   \n                        \n              ...",t:"CHEMACX_BUTTON"},"174":{i:0.00106077595828434,u:"../Content/COEWebserver/CHEMACX_LINK.htm",a:"   CHEMACX_LINK Example: CHEMACX_LINK= \n/chemacx/default.asp?formgroup=basenp_form_group\u0026dbname=chemacx\u0026dataaction=query_string\u0026field_type=TEXT\u0026field_criteria=IN\u0026full_field_name=Substance.ACX_ID\u0026field_value=              \n              \n            Description: Internal settings for ChemACX          ...",t:"CHEMACX_LINK"},"175":{i:0.00106077595828434,u:"../Content/COEWebserver/CHEMACX_SERVER.htm",a:"   CHEMACX_SERVER Example: CHEMACX_SERVER= http://chemacx.cambridgesoft.com              \n              \n              \n   \n                           \n              \n           Description: Points the application to the target \nURL for the ChemACX button.  If it is the local server then leave ...",t:"CHEMACX_SERVER"},"176":{i:0.0019624356635807,u:"../Content/COEWebserver/NCI_BUTTON.htm",a:"   NCI_BUTTON Example: NCI_BUTTON= \n \n OFF   \n   \n                           \n              \n           Description: Indicates if the NCI button should \nshow up in the ChemIndex \n \n \n \n application.               \n              \n                   \n                        \n              \n           ...",t:"NCI_BUTTON"},"177":{i:0.00106077595828434,u:"../Content/COEWebserver/NCI_LINK.htm",a:"   NCI_LINK Example: NCI_LINK= \n/nci2002/default.asp?formgroup=basenp_form_group\u0026dbname=nci\u0026dataaction=query_string\u0026field_type=TEXT\u0026full_field_name=MolTable.CASRN\u0026f ield_value=              \n              \n            Description: Internal settings for The NCI.              \n              \n          ...",t:"NCI_LINK"},"178":{i:0.00106077595828434,u:"../Content/COEWebserver/NCI_SERVER.htm",a:"   NCI_SERVER Example: NCI_SERVER= \n \n http://nci.cambridgesoft.com   \n   \n                           \n              \n           Description: Points the application to the target \nURL for the NCI button.  If it is the local server then leave blank. If it \nis a different internal server, ...",t:"NCI_SERVER"},"179":{i:0.0019624356635807,u:"../Content/COEWebserver/THEMERCKINDEX_BUTTON.htm",a:"   THEMERCKINDEX_BUTTON Example: THEMERCKINDEX_BUTTON= \n \n OFF   \n   \n                           \n              \n           Description: Indicates if The Merck Index button \nshould show up in the ChemIndex \n \n \n \n application.               \n              \n                   \n                        ...",t:"THEMERCKINDEX_BUTTON"},"180":{i:0.00106077595828434,u:"../Content/COEWebserver/THEMERCKINDEX_LINK.htm",a:"   THEMERCKINDEX_LINK Example: THEMERCKINDEX_LINK= \n/TheMerckIndex/default.asp?formgroup=basenp_form_group\u0026dbname=TheMerckIndex\u0026dataaction=query_string\u0026field_type=TEXT\u0026full_field_name=CASRNs.CASRN\u0026field_value=              \n              \n            Description: Internal settings for The Merck ...",t:"THEMERCKINDEX_LINK"},"181":{i:0.00106077595828434,u:"../Content/COEWebserver/THEMERCKINDEX_SERVER.htm",a:"   THEMERCKINDEX_SERVER Example: THEMERCKINDEX_SERVER= \n \n http://themerckindex.cambridgesoft.com   \n   \n                           \n              \n           Description: Points the application to the target \nURL for the The Merck Index button.  If it is the local server then \nleave blank. If it is ...",t:"THEMERCKINDEX_SERVER"},"182":{i:0.00116700749576577,u:"../Content/COEWebserver/menubar.ini Configuration File.htm",a:" Menubar.ini Configuration File The menubar.ini configuration file (found in the config folder of each \napplication\u0027s folder) controls how the menubar is displayed in the \napplication.  By default, the following menus are available to the \nuser: File\n   History\n   Queries\n   Hitlists\n   Marked Hits\n ...",t:"menubar.ini Configuration File"},"183":{i:0.000965426960450509,u:"../Content/COEWebserver/MENUBAR_ITEMS.htm",a:"   MENUBAR_ITEMS Example: \nMENUBAR_ITEMS=FILE,HISTORY,QUERIES,QUERIES_RESTORE,HITLISTS,HITLISTS_RESTORE,MARKED_HITS,HELP,LOGOFF,HOME Description: This is a list of menu names.  \nSubmenus are listed here as \u003cMENUNAME\u003e_\u003cSUBMENUNAME\u003e.  For \nexample, the Restore submenu found under the Queries menu is ...",t:"MENUBAR_ITEMS"},"184":{i:0.000948614137963353,u:"../Content/COEWebserver/MENU_BAR_DISPLAY_SETTINGS.htm",a:"This section of the guide provides the list of menu bar items settings. Please refer to the following topics for more details: ABSOLUTE_LEFT ABSOLUTE_TOP BACKGROUND_COLOR CLEAR_PIXEL_IMAGE DISABLED_TEXT_COLOR HOVER_COLOR HOVER_HIGHLIGHT_COLOR HOVER_SHADOW_COLOR HOVER_TEXT_COLOR INNER_HIGHLIGHT_COLOR ...",t:"MENU_BAR_DISPLAY_SETTINGS"},"185":{i:0.00098334523025631,u:"../Content/COEWebserver/ABSOLUTE_LEFT.htm",a:"   ABSOLUTE_LEFT Example: ABSOLUTE_LEFT= \n100           \n               \n       Description: The leftward position of the \nmenubar. The leftward pixel, \n \n relative to the \n \n browser window, where the menubar should start.               \n              \n                   \n                        \n  ...",t:"ABSOLUTE_LEFT"},"186":{i:0.00098334523025631,u:"../Content/COEWebserver/ABSOLUTE_TOP.htm",a:"   ABSOLUTE_TOP Example: ABSOLUTE_TOP= \n100           \n               \n       Description: The vertical position of the \nmenubar. The pixel, relative to the top of \n \n the browser window \n \n counting down, where the menubar should start.               \n              \n                   \n             ...",t:"ABSOLUTE_TOP"},"187":{i:0.00098334523025631,u:"../Content/COEWebserver/BACKGROUND_COLOR.htm",a:"   BACKGROUND_COLOR Example: BACKGROUND_COLOR= \n#CCCCCC Description: The menubar background color in HEX format.                 \n              \n                   \n                        \n              \n           Default: #CCCCCC Options: A color represented in HEX format.  It is important to ...",t:"BACKGROUND_COLOR"},"188":{i:0.00098334523025631,u:"../Content/COEWebserver/CLEAR_PIXEL_IMAGE.htm",a:"   CLEAR_PIXEL_IMAGE Example: CLEAR_PIXEL_IMAGE= \n/cfserverasp/source/graphics/navbuttons/clearpixel.gif           \n               \n                   \n               \n             Description:                \n              \n                   \n                        \n              \n           ...",t:"CLEAR_PIXEL_IMAGE"},"189":{i:0.00098334523025631,u:"../Content/COEWebserver/DISABLED_TEXT_COLOR.htm",a:"   DISABLED_TEXT_COLOR Example: DISABLED_TEXT_COLOR= \n#a5a6a6 Description: The color of the text if a menu item is \ndisabled (can not be selected). Note: this is only valid when  SHOW_ON_MOUSEOVER  = \n \n 1. Default: #a5a6a6 Options: A color in HEX format  It is important to note that it is the ...",t:"DISABLED_TEXT_COLOR"},"190":{i:0.00098334523025631,u:"../Content/COEWebserver/HOVER_COLOR.htm",a:"   HOVER_COLOR Example: HOVER_COLOR= \n#d4d0c8 Description:  Note: this is only valid when  SHOW_ON_MOUSEOVER  = \n \n 0. Default: #d4d0c8 Options: A color in HEX format  It is important to note that it is the \nresponsibility of a site\u0027s administrator to propagate any changes made to \nChemOffice ...",t:"HOVER_COLOR"},"191":{i:0.00098334523025631,u:"../Content/COEWebserver/HOVER_HIGHLIGHT_COLOR.htm",a:"   HOVER_HIGHLIGHT_COLOR Example: HOVER_HIGHLIGHT_COLOR= \n#CCCCCC Description: The color for which the hover \nhighlight (area shown in red below) should be displayed in. Note: this is only valid when  SHOW_ON_MOUSEOVER  = 0.  Default: #CCCCCC Options: A color in HEX format  It is important to note ...",t:"HOVER_HIGHLIGHT_COLOR"},"192":{i:0.00098334523025631,u:"../Content/COEWebserver/HOVER_SHADOW_COLOR.htm",a:"   HOVER_SHADOW_COLOR Example: HOVER_SHADOW_COLOR= \n#808080 Description: The color for which the \nhover shadow (area shown in red below) should be displayed in. Note: this is only valid when  SHOW_ON_MOUSEOVER  = \n \n 0. Default: #808080 Options: A color in HEX format  It is important to note that it ...",t:"HOVER_SHADOW_COLOR"},"193":{i:0.00098334523025631,u:"../Content/COEWebserver/HOVER_TEXT_COLOR.htm",a:"   HOVER_TEXT_COLOR Example: HOVER_TEXT_COLOR= \n#000000 Description: The color for which the \nhover text (area shown in red below) should be displayed in. Note: this is only valid when  SHOW_ON_MOUSEOVER  = \n \n 0. Default: #000000 Options: A color in HEX format  It is important to note that it is ...",t:"HOVER_TEXT_COLOR"},"194":{i:0.00098334523025631,u:"../Content/COEWebserver/INNER_HIGHLIGHT_COLOR.htm",a:"   INNER_HIGHLIGHT_COLOR Example: INNER_HIGHLIGHT_COLOR= \n#F9F8F7 Description: The color for which the inner \nhighlight color (area shown in red below) should be displayed in. Note: this is only valid when  SHOW_ON_MOUSEOVER  = \n \n 1. Default: #F9F8F7 Options: A color in HEX format  It is important ...",t:"INNER_HIGHLIGHT_COLOR"},"195":{i:0.00098334523025631,u:"../Content/COEWebserver/INNER_SHADOW_COLOR.htm",a:"   INNER_SHADOW_COLOR Example: INNER_SHADOW_COLOR= \n#F9F8F7 Description: The color for which the \ninner shadow color (area shown in red below) should be displayed \nin. Note: this is only valid when  SHOW_ON_MOUSEOVER  = \n \n 1. Default: #F9F8F7 Options: A color in HEX format  It is important to note ...",t:"INNER_SHADOW_COLOR"},"196":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_COLOR.htm",a:"   ITEM_FONT_COLOR Example: ITEM_FONT_COLOR= \n#000000           \n               \n       Description: The color of \n \n font in the text for menu items.               \n              \n                   \n                        \n              \n           Default: #000000 Options: A color in HEX format  ...",t:"ITEM_FONT_COLOR"},"197":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_FAMILY.htm",a:"   ITEM_FONT_FAMILY Example: ITEM_FONT_FAMILY= \"MS Sans Serif\", Arial, \nHelvetica, \nTahoma,sans-serif           \n               \n        Description: The font \n \n for the text for menu items.               \n              \n                   \n                        \n              \n           ...",t:"ITEM_FONT_FAMILY"},"198":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_PADDING_BOTTOM.htm",a:"   ITEM_FONT_PADDING_BOTTOM Example: ITEM_FONT_PADDING_BOTTOM= \n3           \n               \n        Description: The \n \n amount of padding at the bottom \n \n of the text in menu items.               \n              \n                   \n                        \n              \n           Default: 3     ...",t:"ITEM_FONT_PADDING_BOTTOM"},"199":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_PADDING_LEFT.htm",a:"   ITEM_FONT_PADDING_LEFT Example: ITEM_FONT_PADDING_LEFT= \n7           \n               \n        Description: The \n \n amount of padding to the left \n \n of the text in menu items.               \n              \n                   \n                        \n              \n           Default: 7     ...",t:"ITEM_FONT_PADDING_LEFT"},"200":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_PADDING_RIGHT.htm",a:"   ITEM_FONT_PADDING_RIGHT Example: ITEM_FONT_PADDING_RIGHT= \n7           \n               \n        Description: The \n \n amount of padding to the right \n \n of the text in menu itmes.               \n              \n                   \n                        \n              \n           Default: 7     ...",t:"ITEM_FONT_PADDING_RIGHT"},"201":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_PADDING_TOP.htm",a:"   ITEM_FONT_PADDING_TOP Example: ITEM_FONT_PADDING_TOP= \n3           \n               \n        Description: The \n \n amount of padding at the top \n \n of the text in menu items.               \n              \n                   \n                        \n              \n           Default: 3     ...",t:"ITEM_FONT_PADDING_TOP"},"202":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_SIZE.htm",a:"   ITEM_FONT_SIZE Example: ITEM_FONT_SIZE= \n8           \n               \n       Description: The font size for the \n \n text for menu items (not menu names).               \n              \n                   \n                        \n              \n           Default: 8 Options: Integer  It is ...",t:"ITEM_FONT_SIZE"},"203":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_STYLE.htm",a:"   ITEM_FONT_STYLE Example: ITEM_FONT_STYLE= \nnormal           \n               \n        Description: The font style for the text \n \n in menu items (not menu names).               \n              \n                   \n                        \n              \n           Default: normal Options: NORMAL | ...",t:"ITEM_FONT_STYLE"},"204":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_TEXT_DECORATION.htm",a:"   ITEM_FONT_TEXT_DECORATION Example: \nITEM_FONT_TEXT_DECORATION=none           \n               \n             Description:                \n              \n                   \n                        \n              \n           Default: none   Options:  It is important to note that it is the ...",t:"ITEM_FONT_TEXT_DECORATION"},"205":{i:0.00098334523025631,u:"../Content/COEWebserver/ITEM_FONT_WEIGHT.htm",a:"   ITEM_FONT_WEIGHT Example: ITEM_FONT_WEIGHT= \nnormal           \n               \n        Description: The font weight for the text \n \n in menu items (not menu names).               \n              \n                   \n                        \n              \n           Default: normal Options: NORMAL ...",t:"ITEM_FONT_WEIGHT"},"206":{i:0.00098334523025631,u:"../Content/COEWebserver/MENU_FONT_COLOR.htm",a:"   MENU_FONT_COLOR Example: MENU_FONT_COLOR= \n#000000           \n               \n       Description: The color of font in the menus.               \n              \n                   \n                        \n              \n           Default: #000000 Options: A color in HEX format  It is important ...",t:"MENU_FONT_COLOR"},"207":{i:0.00098334523025631,u:"../Content/COEWebserver/MENU_FONT_FAMILY.htm",a:"   MENU_FONT_FAMILY Example: MENU_FONT_FAMILY= \"MS Sans Serif\", Arial, \nHelvetica, \nTahoma,sans-serif           \n               \n        Description: The font for the menu text.               \n              \n                   \n                        \n              \n           Default: \"MS Sans ...",t:"MENU_FONT_FAMILY"},"208":{i:0.00098334523025631,u:"../Content/COEWebserver/MENU_FONT_PADDING_BOTTOM.htm",a:"   MENU_FONT_PADDING_BOTTOM Example: MENU_FONT_PADDING_BOTTOM= \n4           \n               \n        Description: The amount of padding at the \n \n bottom of the text in menus.               \n              \n                   \n                        \n              \n           Default: 4     ...",t:"MENU_FONT_PADDING_BOTTOM"},"209":{i:0.00098334523025631,u:"../Content/COEWebserver/MENU_FONT_PADDING_LEFT.htm",a:"   MENU_FONT_PADDING_LEFT Example: MENU_FONT_PADDING_LEFT= \n6           \n               \n        Description: The amount of padding to the \n \n left of the text in menus.               \n              \n                   \n                        \n              \n           Default: 6     ...",t:"MENU_FONT_PADDING_LEFT"},"210":{i:0.00098334523025631,u:"../Content/COEWebserver/MENU_FONT_PADDING_RIGHT.htm",a:"   MENU_FONT_PADDING_RIGHT Example: MENU_FONT_PADDING_RIGHT= \n6           \n               \n        Description: The amount of padding to the \n \n right of the text in menus.               \n              \n                   \n                        \n              \n           Default: 6     ...",t:"MENU_FONT_PADDING_RIGHT"},"211":{i:0.00098334523025631,u:"../Content/COEWebserver/MENU_FONT_PADDING_TOP.htm",a:"   MENU_FONT_PADDING_TOP Example: MENU_FONT_PADDING_TOP= \n4           \n               \n        Description: The amount of padding at \n \n the top of the text in menus.               \n              \n                   \n                        \n              \n           Default: 4     Options: Integer  ...",t:"MENU_FONT_PADDING_TOP"},"212":{i:0.00098334523025631,u:"../Content/COEWebserver/MENU_FONT_SIZE.htm",a:"   MENU_FONT_SIZE Example: MENU_FONT_SIZE= \n8           \n               \n       Description: The font size for the menu text.               \n              \n                   \n                        \n              \n           Default: 8 Options: Integer  It is important to note that it is the ...",t:"MENU_FONT_SIZE"},"213":{i:0.00098334523025631,u:"../Content/COEWebserver/MENU_FONT_STYLE.htm",a:"   MENU_FONT_STYLE Example: MENU_FONT_STYLE= \nnormal           \n               \n        Description: The font style for the menu text.               \n              \n                   \n                        \n              \n           Default: normal Options: NORMAL | BOLD | ITALIC  It is important ...",t:"MENU_FONT_STYLE"},});