CREATE PROCEDURE [adw].[InsertWorklistResponseBatch](
	@ResponseBatchDate date
	,@workListBatchKey int
	, @WorklistResponseBatchID INT OUTPUT)
AS
  
  insert into [adw].[WorklistResponseBatch]
  (ResponseBatchDate,workListBatchKey)
  values (@ResponseBatchDate,@workListBatchKey);

  set  @WorklistResponseBatchID  = @@IDENTITY