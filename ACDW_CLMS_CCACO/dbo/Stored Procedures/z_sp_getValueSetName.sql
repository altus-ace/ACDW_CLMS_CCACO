
-- =============================================
-- Author:		Si Nguyen
-- Create date: 03/23/2017
-- Description:	Get all Value Set Names from Measure ID
-- =============================================
CREATE PROCEDURE [dbo].[z_sp_getValueSetName] @MeasureID varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT MEASURE_ID, MEASURE_NAME, VALUE_SET_NAME
	FROM LIST_HEDIS_MEASURE
	WHERE MEASURE_ID = @MeasureID
END
