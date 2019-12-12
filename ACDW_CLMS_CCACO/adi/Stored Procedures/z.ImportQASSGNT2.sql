-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[z.ImportQASSGNT2](
    @OriginalFileName varchar(100),
	@SrcFileName varchar(100) ,
	--@LoadDate date ,
	--CreatedDate date ,
	@CreatedBy varchar(50) ,
	--LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50) ,
	@MBI varchar(50),
	@HICN varchar(50) ,
	@FirstName varchar(50),
	@LastName varchar(50),
	@Sex varchar(50),
	@DOB varchar(50) ,
	@DOD varchar(50),
	@TIN varchar(50) ,
	@PCServices varchar(50),
	@EffQtr varchar(50)
  
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
 INSERT INTO [adi].[ALR.QASSGNT2]
   (
    OriginalFileName ,
	SrcFileName  ,
	LoadDate  ,
	CreatedDate  ,
	CreatedBy  ,
	LastUpdatedDate  ,
	LastUpdatedBy  ,

	[MBI],
	[HICN] ,
	[FirstName] ,
	[LastName],
	[Sex] ,
	[DOB] ,
	[DOD],
	[TIN],
	[PCServices],
	[EffQtr] 

            )
     VALUES
   (
       @OriginalFileName ,
	@SrcFileName  ,
	GETDATE(),
	--@LoadDate date ,
	--CreatedDate date ,
	GETDATE(),
	@CreatedBy  ,
	GETDATE(),
	--LastUpdatedDate datetime ,
	@LastUpdatedBy  ,
	@MBI ,
	@HICN ,
	@FirstName ,
	@LastName ,
	@Sex ,
	@DOB  ,
	@DOD ,
	@TIN ,
	@PCServices ,
	@EffQtr 
   );
END
GO
GRANT EXECUTE
    ON OBJECT::[adi].[z.ImportQASSGNT2] TO [BoomiDbUser]
    AS [dbo];

