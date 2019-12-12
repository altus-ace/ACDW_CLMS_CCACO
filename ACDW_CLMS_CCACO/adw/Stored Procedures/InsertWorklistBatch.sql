
CREATE PROCEDURE [adw].[InsertWorklistBatch](
	@BatchDate date
	, @WorklistBatchID INT OUTPUT)
AS
  
  insert into adw.WorklistBatch 
  (BatchDate)
  values (@BatchDate);

  set @WorklistBatchID  = @@IDENTITY