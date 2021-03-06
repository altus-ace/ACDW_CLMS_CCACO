﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportQASSGNT5](
    @OriginalFileName varchar(100),
	@SrcFileName varchar(100) ,
	--@LoadDate date ,
	--CreatedDate date ,
	@CreatedBy varchar(50) ,
	--LastUpdatedDate datetime ,
    @LastUpdatedBy varchar(50),
    @MBI varchar(50),
	@HICN varchar(50),
	@FirstName varchar(50),
	@LastName varchar(50) ,
	@Sex varchar(50) ,
	@DOB varchar(50),
	@DOD varchar(50),
	@Plurality varchar(50),
	@1MthCoverage varchar(50),
	@1MthHealthPlan varchar(50),
	@NotUSResident varchar(50),
	@InOtherSSInitiatives varchar(50),
	@NoPCPVisit varchar(50) ,
	@EffQtr varchar(50)
	--@OriginalFileName varchar(100),
	--@SrcFileName varchar(100),
	----@LoadDate  NOT NULL,
 -- --	[CreatedDate] [date] NOT NULL,
 -- GETDATE(),
	--[CreatedBy] [varchar](50) NOT NULL,
	--[LastUpdatedDate] [datetime] NOT NULL,
	--[LastUpdatedBy] [varchar](50) NOT NULL,

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
 INSERT INTO adi.ACE.QASSGNT5
   (
    OriginalFileName ,
	SrcFileName  ,
	LoadDate  ,
	CreatedDate  ,
	CreatedBy  ,
	LastUpdatedDate  ,
	LastUpdatedBy  ,
	[MBI],
	[HICN],
	[FirstName],
	[LastName] ,
	[Sex],
	[DOB],
	[DOD],
	[Plurality] ,
	[1MthCoverage] ,
	[1MthHealthPlan] ,
	[NotUSResident],
	[InOtherSSInitiatives],
	[NoPCPVisit] ,
	[EffQtr] ,
	[OriginalFileName],
	[SrcFileName] ,
	[LoadDate],
	[CreatedDate] ,
	[CreatedBy],
	[LastUpdatedDate] ,
	[LastUpdatedBy] 
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
	--LastUpdatedDate datetime ,
	@LastUpdatedBy,  
	@MBI ,
	@HICN ,
	@FirstName ,
	@LastName ,
	@Sex ,
	@DOB ,
	@DOD,
	@Plurality ,
	@1MthCoverage ,
	@1MthHealthPlan,
	@NotUSResident ,
	@InOtherSSInitiatives ,
	@NoPCPVisit  ,
	@EffQtr 
	
   );
END
