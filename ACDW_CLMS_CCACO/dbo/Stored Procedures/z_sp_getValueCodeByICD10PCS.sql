﻿


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<List Members that have a ICD10PCS code within a ValueSetName>
-- =============================================
CREATE PROCEDURE [dbo].[z_sp_getValueCodeByICD10PCS] @ValueSetName varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT VALUE_CODE, VALUE_CODE_NAME
	FROM LIST_HEDIS_CODE
	WHERE VALUE_SET_NAME IN (SELECT VALUE_SET_NAME FROM tmp_ValueSetName) AND VALUE_CODE_SYSTEM = 'ICD10PCS'
END
