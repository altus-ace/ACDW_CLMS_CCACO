/****** Script for SelectTopNRows command from SSMS  ******/
USE ACDW_CLMS_CCACO
GO


-- Update TIN from latest Member NPI list
UPDATE lst.LIST_PCP 
	SET 
	[PCP_PRACTICE_TIN] = b.LstTIN
	FROM lst.LIST_PCP a
, (SELECT DISTINCT NPI, (SELECT TOP 1 TIN FROM adw.Member_Provider_History b WHERE a.NPI = b.NPI ORDER BY NPI, LOAD_DATE) LstTIN 
   FROM adw.Member_Provider_History a) b
WHERE [PCP_NPI] = b.NPI
GO


/*
SELECT *
FROM LIST_PCP
--WHERE PCP_PRACTICE_TIN IS NULL
*/
