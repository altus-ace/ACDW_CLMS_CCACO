

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<List Members that have a MSDRG code within a ValueSetName>
-- =============================================
CREATE PROCEDURE [dbo].[z_sp_getValueCodeByMSDRG] @ValueSetName varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT VALUE_CODE, VALUE_CODE_NAME
	FROM LIST_HEDIS_CODE
	WHERE VALUE_SET_NAME = @ValueSetName AND VALUE_CODE_SYSTEM = 'MSDRG'
END
