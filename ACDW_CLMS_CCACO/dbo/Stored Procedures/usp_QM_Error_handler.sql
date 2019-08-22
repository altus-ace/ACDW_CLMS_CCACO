CREATE PROCEDURE [dbo].[usp_QM_Error_handler]

as
BEGIN
    DECLARE @errnum INT,
            @severity INT,
            @errstate INT,
            @proc NVARCHAR(126),
            @line INT,
            @message NVARCHAR(4000)
    -- capture the error information that caused the CATCH block to be invoked
    SELECT @errnum = ERROR_NUMBER(),
           @severity = ERROR_SEVERITY(),
           @errstate = ERROR_STATE(),
           @proc = ERROR_PROCEDURE(),
           @line = ERROR_LINE(),
           @message = ERROR_MESSAGE()
	SELECT @errnum AS ERROR_NUMBER, @severity AS ERROR_SEVERITY, @errstate AS ERROR_STATE, @proc AS ERROR_PROCEDURE,
           @line AS ERROR_LINE, @message AS ERROR_MESSAGE
END