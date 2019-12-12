
---Load Members for each quater with other attributes
---Inserting into [ast].[ACE.QASSGNT1] from [adi].[ALR.QASSGNT1]
DECLARE @EffQtr VARCHAR(10) 
SET @EffQtr = CONCAT(YEAR(GETDATE()),'Q4')
INSERT INTO			[ast].[QASSGNT1] 
					(								 
					[MBI] , [HICN] , [FirstName] , [LastName] 
					, [Sex] , [DOB] , [DOD] , [CountyName] , [StateName] , [CountyNumber] , [VoluntaryFlag] , [CBFlag] , [CBStepFlag] , [PrevBenFlag]
					, [HCC1] , [HCC2] , [HCC6] , [HCC8] , [HCC9] , [HCC10], [HCC11], [HCC12], [HCC17 ], [HCC18 ], [HCC19 ], [HCC21 ], [HCC22 ]
					, [HCC23 ], [HCC27 ], [HCC28 ] , [HCC29 ], [HCC33 ], [HCC34 ], [HCC35 ], [HCC39 ], [HCC40 ], [HCC46 ], [HCC47 ], [HCC48 ]
					, [HCC54 ] , [HCC55 ], [HCC57 ], [HCC58 ], [HCC70 ], [HCC71 ], [HCC72 ], [HCC73 ], [HCC74 ], [HCC75 ], [HCC76 ], [HCC77 ]
					, [HCC78 ], [HCC79 ], [HCC80 ], [HCC82 ], [HCC83 ], [HCC84 ], [HCC85 ], [HCC86 ], [HCC87 ], [HCC88 ], [HCC96 ] , [HCC99 ]
					, [HCC100 ], [HCC103 ], [HCC104 ], [HCC106 ], [HCC107 ], [HCC108 ], [HCC110 ], [HCC111 ], [HCC112 ] , [HCC114 ], [HCC115 ]
					, [HCC122 ], [HCC124 ], [HCC134 ], [HCC135 ], [HCC136 ], [HCC137 ], [HCC157 ], [HCC158 ] , [HCC161 ], [HCC162 ], [HCC166 ]
					, [HCC167 ], [HCC169 ], [HCC170 ], [HCC173 ], [HCC176 ], [HCC186 ], [HCC188 ] , [HCC189 ], [PartDFlag]
					, [RS_ESRD], [RS_Disabled]
					, [RS_AgedDual], [RS_AgedNonDual], [Demo_RS_ESRD]
					, [Demo_RS_Disabled] , [Demo_RS_AgedDual], [Demo_RS_AgedNonDual]
					, [EffQtr], [LOAD_DATE], [LOAD_USER]
					, [EnrollFlag1], [EnrollFlag2], [EnrollFlag3], [EnrollFlag4], [EnrollFlag5], [EnrollFlag6], [EnrollFlag7], [EnrollFlag8]
					, [EnrollFlag9], [EnrollFlag10], [EnrollFlag11], [EnrollFlag12])
SELECT							 
					[MBI] , [HICN] , [FirstName] , [LastName]
					, [Sex], [DOB], [DOD], [CountyName], [StateName], [CountyNumber], [VoluntaryFlag], [CBFlag], [CBStepFlag], [PrevBenFlag]
					, [HCC1], [HCC2], [HCC6], [HCC8], [HCC9], [HCC10], [HCC11], [HCC12], [HCC17 ], [HCC18 ], [HCC19 ], [HCC21 ], [HCC22 ]
					, [HCC23 ], [HCC27 ], [HCC28 ], [HCC29 ], [HCC33 ], [HCC34 ], [HCC35 ], [HCC39 ], [HCC40 ], [HCC46 ], [HCC47 ], [HCC48 ]
					, [HCC54 ], [HCC55 ], [HCC57 ], [HCC58 ], [HCC70 ], [HCC71 ], [HCC72 ], [HCC73 ], [HCC74 ], [HCC75 ], [HCC76 ], [HCC77 ]
					, [HCC78 ], [HCC79 ], [HCC80 ], [HCC82 ], [HCC83 ], [HCC84 ], [HCC85 ], [HCC86 ], [HCC87 ], [HCC88 ], [HCC96 ], [HCC99 ]
					, [HCC100 ], [HCC103 ], [HCC104 ], [HCC106 ], [HCC107 ], [HCC108 ], [HCC110 ], [HCC111 ], [HCC112 ], [HCC114 ], [HCC115 ]
					, [HCC122 ], [HCC124 ], [HCC134 ], [HCC135 ], [HCC136 ], [HCC137 ], [HCC157 ], [HCC158 ], [HCC161 ], [HCC162 ], [HCC166 ]
					, [HCC167 ], [HCC169 ], [HCC170 ], [HCC173 ], [HCC176 ], [HCC186 ], [HCC188 ], [HCC189 ], [PartDFlag]
					, convert([decimal](5, 4),CASE WHEN ([RS_ESRD]			='') then '0' ELSE  [RS_ESRD]			  end )as [RS_ESRD]			 
					, convert([decimal](5, 4),  CASE WHEN ([RS_Disabled]		='') then '0' ELSE  [RS_Disabled]		  end )as [RS_Disabled]		 
					, convert([decimal](5, 4),  CASE WHEN ([RS_AgedDual]		='') then '0' ELSE  [RS_AgedDual]		  end )as [RS_AgedDual]		 
					, convert([decimal](5, 4),  CASE WHEN ([RS_AgedNonDual]		='') then '0' ELSE	[RS_AgedNonDual]	  end )as [RS_AgedNonDual]	 
					, convert([decimal](5, 4),  CASE WHEN ([Dem_RS_ESRD]		='') then '0' ELSE  [Dem_RS_ESRD]		  end )as [Dem_RS_ESRD]		 
					, convert([decimal](5, 4),  CASE WHEN ([Dem_RS_Disabled]	='') then '0' ELSE  [Dem_RS_Disabled]	  end )as [Dem_RS_Disabled]	 
					, convert([decimal](5, 4),  CASE WHEN ([Dem_RS_AgedDual]	='') then '0' ELSE  [Dem_RS_AgedDual]	  end )as [Dem_RS_AgedDual]	 
					, convert([decimal](5, 4),  CASE WHEN ([Dem_RS_AgedNonDual] ='') then '0' ELSE	[Dem_RS_AgedNonDual]  end )as [Dem_RS_AgedNonDual]
					, @EffQtr, GETDATE(),  SUSER_NAME()
					, [EnrollFlag1], [EnrollFlag2], [EnrollFlag3], [EnrollFlag4], [EnrollFlag5], [EnrollFlag6], [EnrollFlag7], [EnrollFlag8]
					, [EnrollFlag9], [EnrollFlag10], [EnrollFlag11], [EnrollFlag12]
FROM				[adi].[ALR.QASSGNT1]
WHERE				LOADDATE IN (SELECT MAX(LOADDATE) FROM [adi].[ALR.QASSGNT1] )


 --Insert into [ast].[ACE.QASSGNT2] from [adi].[ALR.QASSGNT2]
INSERT INTO			[ast].[ACE.QASSGNT2] 
					([MBI], [HICN], [FirstName], [LastName], [Sex], [DOB], [DOD], [TIN], [PCServices], [EffQtr], [LOAD_DATE], [LOAD_USER])

SELECT				[MBI], [HICN], [FirstName], [LastName], [Sex], [DOB], [DOD], [TIN], [PCServices], @EffQtr, GETDATE(), SUSER_NAME()
FROM				[adi].[ALR.QASSGNT2]
WHERE				LOADDATE IN (SELECT MAX(LOADDATE) FROM [adi].[ALR.QASSGNT2] )



----Insert into [ast].[ACE.QASSGNT4]  from [adi].[ALR.QASSGNT4]
INSERT INTO			[ast].[ACE.QASSGNT4] 
					([MBI], [HICN], [FirstName], [LastName], [Sex], [DOB], [DOD], [TIN], [NPI], [EffQtr], [LOAD_DATE], [LOAD_USER])
SELECT				[MBI], [HICN], [FirstName], [LastName], [Sex], [DOB], [DOD], [TIN], [NPI], @EffQtr, GETDATE(), SUSER_NAME()
FROM				[adi].[ALR.QASSGNT4]
WHERE				LOADDATE IN (SELECT MAX(LOADDATE) FROM [adi].[ALR.QASSGNT4] )




