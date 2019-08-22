CREATE VIEW adw.vw_ValueCode_ValueSetName_Crosswalk
AS
     SELECT replace(CAT.[VALUE_CODE], '.', '') AS [VALUE_CODE], 
            STUFF(
     (
         SELECT '|' + SUB.[VALUE_SET_NAME] AS [text()]
         FROM lst.[LIST_HEDIS_CODE] SUB
         WHERE SUB.[VALUE_CODE] = CAT.[VALUE_CODE] FOR XML PATH('')
     ), 1, 1, '') AS VALUE_CODE_SET_NAME
     FROM lst.[LIST_HEDIS_CODE] CAT
     WHERE VALUE_CODE_SYSTEM IN('ICD10CM', 'ICD9CM');
