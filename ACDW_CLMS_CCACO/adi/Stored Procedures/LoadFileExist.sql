-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[LoadFileExist](
   	@SrcFileName varchar(100),
	@TableName VARCHAR(100), 
	@RecordExist INT output
	 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	DECLARE @sql_command NVARCHAR(MAX);
    DECLARE @ColumnName varchar(100) = '';
  

 SELECT @sql_command = 'Select COUNT(*) FROM  ' + 	@TableName   
 + ' WHERE SrcFileName =  ''' +  @SrcFileName + '''';

CREATE TABLE #tmpTable
(
    OutputValue VARCHAR(100)
)
INSERT INTO #tmpTable (OutputValue)
EXEC sp_executesql @sql_command

SELECT
    @RecordExist = Convert(int, OutputValue)
FROM 
    #tmpTable

DROP TABLE #tmpTable

END