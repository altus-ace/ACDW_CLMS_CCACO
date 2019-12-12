-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ImportTmpPhysicianPhoneNum](
   @FirstName varchar(50),
	@LastName varchar(50) ,
	@CMS_LBN varchar(500),
	@NPIInd varchar(20) ,
	@PrimaryOfficePhone varchar(100) ,
	@CreateBy varchar(100),
	@SrcFileName varchar(100)
	--[CreatedDate] [datetime] NULL
  
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--UPDATE adi.MbrAetCom
--	SET MEMBER_ID  =  @MEMBER_ID 

--    WHERE  MEMBER_ID = @MEMBER_ID

	 
--	IF @@ROWCOUNT = 0

    -- Insert statements for procedure here
 INSERT INTO [dbo].[tmp_Physician_Phone_Numbers]
   (
     [FirstName]
      ,[LastName]
      ,[CMS_LBN]
      ,[NPIInd]
      ,[PrimaryOfficePhone]
      ,[CreateBy]
      ,[CreatedDate],
	  [SrcFileName]
	)
     VALUES
   (
        @FirstName,
	@LastName ,
	@CMS_LBN ,
	@NPIInd ,
	@PrimaryOfficePhone ,
	@CreateBy ,
    GETDATE(),
	@SrcFileName
   );
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ImportTmpPhysicianPhoneNum] TO [BoomiDbUser]
    AS [dbo];

