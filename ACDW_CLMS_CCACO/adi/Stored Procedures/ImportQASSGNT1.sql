﻿CREATE PROCEDURE [adi].[ImportQASSGNT1](
     @OriginalFileName varchar(100),
	@SrcFileName varchar(100) ,
	--@LoadDate date ,
	--CreatedDate date ,
	@CreatedBy varchar(50) ,
	--LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50) ,
	@MBI varchar(50) ,
	@HICN varchar(50) ,
	@FirstName varchar(50) ,
	@LastName varchar(50) ,
	@Sex varchar(50) ,
	@DOB varchar(50) ,
	@DOD varchar(50) ,
	@CountyName varchar(50) ,
	@StateName varchar(50) ,
	@CountyNumber varchar(50) ,
	@VoluntaryFlag varchar(50) ,
	@CBFlag varchar(50) ,
	@CBStepFlag varchar(50) ,
	@PrevBenFlag varchar(50) ,
	@HCC1 varchar(50) ,
	@HCC2 varchar(50) ,
	@HCC6 varchar(50) ,
	@HCC8 varchar(50) ,
	@HCC9 varchar(50) ,
	@HCC10 varchar(50) ,
	@HCC11 varchar(50) ,
	@HCC12 varchar(50) , 
    @HCC17  varchar(50) ,
	@HCC18  varchar(50) ,
	@HCC19  varchar(50) ,
	@HCC21  varchar(50) ,
	@HCC22  varchar(50) ,
	@HCC23  varchar(50) ,
	@HCC27  varchar(50) ,
	@HCC28  varchar(50) ,
	@HCC29  varchar(50) ,
	@HCC33  varchar(50) ,
	@HCC34  varchar(50) ,
	@HCC35  varchar(50) ,
	@HCC39  varchar(50) ,
	@HCC40  varchar(50) ,
	@HCC46  varchar(50) ,
	@HCC47  varchar(50) ,
	@HCC48  varchar(50) ,
	@HCC54  varchar(50) ,
	@HCC55  varchar(50) ,
	@HCC57  varchar(50) ,
	@HCC58  varchar(50) ,
	@HCC70  varchar(50) ,
	@HCC71  varchar(50) ,
	@HCC72  varchar(50) ,
	@HCC73  varchar(50) ,
	@HCC74  varchar(50) ,
	@HCC75  varchar(50) ,
	@HCC76  varchar(50) ,
	@HCC77  varchar(50) ,
	@HCC78  varchar(50) ,
	@HCC79  varchar(50) ,
	@HCC80  varchar(50) ,
	@HCC82  varchar(50) ,
	@HCC83  varchar(50) ,
	@HCC84  varchar(50) ,
	@HCC85  varchar(50) ,
	@HCC86  varchar(50) ,
	@HCC87  varchar(50) ,
	@HCC88  varchar(50) ,
	@HCC96  varchar(50) ,
	@HCC99  varchar(50) ,
	@HCC100  varchar(50) ,
	@HCC103  varchar(50) ,
	@HCC104  varchar(50) ,
	@HCC106  varchar(50) ,
	@HCC107  varchar(50) ,
	@HCC108  varchar(50) ,
	@HCC110  varchar(50) ,
	@HCC111  varchar(50) ,
	@HCC112  varchar(50) ,
	@HCC114  varchar(50) ,
	@HCC115  varchar(50) ,
	@HCC122  varchar(50) ,
	@HCC124  varchar(50) ,
	@HCC134  varchar(50) ,
	@HCC135  varchar(50) ,
	@HCC136  varchar(50) ,
	@HCC137  varchar(50) ,
	@HCC157  varchar(50) ,
	@HCC158  varchar(50) ,
	@HCC161  varchar(50) ,
	@HCC162  varchar(50) ,
	@HCC166  varchar(50) ,
	@HCC167  varchar(50) ,
	@HCC169  varchar(50) ,
	@HCC170  varchar(50) ,
	@HCC173  varchar(50) ,
	@HCC176  varchar(50) ,
	@HCC186  varchar(50) ,
	@HCC188  varchar(50) ,
	@HCC189  varchar(50) ,
	@PartDFlag varchar(50) ,
	@RS_ESRD varchar(50) ,
	@RS_Disabled varchar(50) ,
	@RS_AgedDual varchar(50) ,
	@RS_AgedNonDual varchar(50) ,
	@Dem_RS_ESRD varchar(50) ,
	@Dem_RS_Disabled varchar(50) ,
	@Dem_RS_AgedDual varchar(50) ,
	@Dem_RS_AgedNonDual varchar(50) ,
	@EnrollFlag1 varchar(8),
	@EnrollFlag2 varchar(8),
    @EnrollFlag3 varchar(8),
	@EnrollFlag4 varchar(8),
	@EnrollFlag5 varchar(8),
	@EnrollFlag6 varchar(8),
    @EnrollFlag7 varchar(8),
	@EnrollFlag8 varchar(8),
	@EnrollFlag9 varchar(8),
	@EnrollFlag10 varchar(8),
    @EnrollFlag11 varchar(8),
	@EnrollFlag12 varchar(8)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET ansi_warnings OFF 
	--UPDATE adi.MbrAetCom
--	SET MEMBER_ID  =  @MEMBER_ID 

--    WHERE  MEMBER_ID = @MEMBER_ID

	 
--	IF @@ROWCOUNT = 0

    -- Insert statements for procedure here
 INSERT INTO [adi].[ALR.QASSGNT1]
   (
   OriginalFileName ,
	SrcFileName  ,
	LoadDate  ,
	CreatedDate  ,
	CreatedBy  ,
	LastUpdatedDate  ,
	LastUpdatedBy  ,
	MBI  ,
	HICN  ,
	FirstName  ,
	LastName  ,
	Sex  ,
	DOB  ,
	DOD  ,
	CountyName  ,
	StateName  ,
	CountyNumber  ,
	VoluntaryFlag  ,
	CBFlag  ,
	CBStepFlag  ,
	PrevBenFlag  ,
	HCC1  ,
	HCC2  ,
	HCC6  ,
	HCC8  ,
	HCC9  ,
	HCC10  ,
	HCC11  ,
	HCC12  ,
	HCC17   ,
	HCC18   ,
	HCC19   ,
	HCC21   ,
	HCC22   ,
	HCC23   ,
	HCC27   ,
	HCC28   ,
	HCC29   ,
	HCC33   ,
	HCC34   ,
	HCC35   ,
	HCC39   ,
	HCC40   ,
	HCC46   ,
	HCC47   ,
	HCC48   ,
	HCC54   ,
	HCC55   ,
	HCC57   ,
	HCC58   ,
	HCC70   ,
	HCC71   ,
	HCC72   ,
	HCC73   ,
	HCC74   ,
	HCC75   ,
	HCC76   ,
	HCC77   ,
	HCC78   ,
	HCC79   ,
	HCC80   ,
	HCC82   ,
	HCC83   ,
	HCC84   ,
	HCC85   ,
	HCC86   ,
	HCC87   ,
	HCC88   ,
	HCC96   ,
	HCC99   ,
	HCC100   ,
	HCC103   ,
	HCC104   ,
	HCC106   ,
	HCC107   ,
	HCC108   ,
	HCC110   ,
	HCC111   ,
	HCC112   ,
	HCC114   ,
	HCC115   ,
	HCC122   ,
	HCC124   ,
	HCC134   ,
	HCC135   ,
	HCC136   ,
	HCC137   ,
	HCC157   ,
	HCC158   ,
	HCC161   ,
	HCC162   ,
	HCC166   ,
	HCC167   ,
	HCC169   ,
	HCC170   ,
	HCC173   ,
	HCC176   ,
	HCC186   ,
	HCC188   ,
	HCC189   ,
	PartDFlag  ,
	RS_ESRD  ,
	RS_Disabled  ,
	RS_AgedDual  ,
	RS_AgedNonDual  ,
	Dem_RS_ESRD  ,
	Dem_RS_Disabled  ,
	Dem_RS_AgedDual  ,
	Dem_RS_AgedNonDual,  
	EnrollFlag1 ,
	EnrollFlag2,
    EnrollFlag3 ,
	EnrollFlag4 ,
	EnrollFlag5 ,
	EnrollFlag6,
    EnrollFlag7 ,
	EnrollFlag8 ,
	EnrollFlag9 ,
	EnrollFlag10 ,
    EnrollFlag11 ,
	EnrollFlag12
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
	@MBI  ,
	@HICN  ,
	@FirstName  ,
	@LastName ,
	@Sex ,
	@DOB  ,
	@DOD  ,
	@CountyName  ,
	@StateName  ,
	@CountyNumber  ,
	@VoluntaryFlag  ,
	@CBFlag  ,
	@CBStepFlag  ,
	@PrevBenFlag ,
	@HCC1  ,
	@HCC2  ,
	@HCC6  ,
	@HCC8 ,
	@HCC9  ,
	@HCC10  ,
	@HCC11  ,
	@HCC12  , 
    @HCC17  ,
	@HCC18  ,
	@HCC19   ,
	@HCC21   ,
	@HCC22  ,
	@HCC23   ,
	@HCC27   ,
	@HCC28  ,
	@HCC29   ,
	@HCC33   ,
	@HCC34   ,
	@HCC35   ,
	@HCC39   ,
	@HCC40   ,
	@HCC46   ,
	@HCC47   ,
	@HCC48   ,
	@HCC54   ,
	@HCC55   ,
	@HCC57   ,
	@HCC58   ,
	@HCC70   ,
	@HCC71   ,
	@HCC72  ,
	@HCC73   ,
	@HCC74   ,
	@HCC75   ,
	@HCC76   ,
	@HCC77   ,
	@HCC78   ,
	@HCC79   ,
	@HCC80   ,
	@HCC82   ,
	@HCC83   ,
	@HCC84   ,
	@HCC85   ,
	@HCC86   ,
	@HCC87 ,
	@HCC88  ,
	@HCC96 ,
	@HCC99   ,
	@HCC100  ,
	@HCC103  ,
	@HCC104   ,
	@HCC106   ,
	@HCC107  ,
	@HCC108  ,
	@HCC110  ,
	@HCC111   ,
	@HCC112  ,
	@HCC114 ,
	@HCC115   ,
	@HCC122   ,
	@HCC124  ,
	@HCC134   ,
	@HCC135   ,
	@HCC136   ,
	@HCC137  ,
	@HCC157   ,
	@HCC158   ,
	@HCC161   ,
	@HCC162   ,
	@HCC166  ,
	@HCC167   ,
	@HCC169   ,
	@HCC170   ,
	@HCC173  ,
	@HCC176  ,
	@HCC186   ,
	@HCC188  ,
	@HCC189   ,
	@PartDFlag  ,
	@RS_ESRD  ,
	@RS_Disabled ,
	@RS_AgedDual  ,
	@RS_AgedNonDual  ,
	@Dem_RS_ESRD ,
	@Dem_RS_Disabled  ,
	@Dem_RS_AgedDual ,
	@Dem_RS_AgedNonDual,  
    @EnrollFlag1 ,
	@EnrollFlag2 ,
    @EnrollFlag3 ,
	@EnrollFlag4 ,
	@EnrollFlag5 ,
	@EnrollFlag6 ,
    @EnrollFlag7 ,
	@EnrollFlag8 ,
	@EnrollFlag9 ,
	@EnrollFlag10 ,
    @EnrollFlag11 ,
	@EnrollFlag12 
   );
END

GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportQASSGNT1] TO [BoomiDbUser]
    AS [dbo];

