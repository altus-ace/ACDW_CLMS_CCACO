
CREATE VIEW [adw].[vw_Mbr_Assigned_TIN_NPI]
AS 

SELECT *
FROM (
	SELECT [HICN]
		,[FIRSTNAME]
		,[LASTNAME]
		,[SEX]
		,[DOB]
		,[TIN]
		,[TIN_NAME]
		,[NPI]
		,[NPI_NAME]
		,ROW_NUMBER() OVER (
			PARTITION BY HICN ORDER BY MBR_YEAR DESC
				,MBR_QTR
			) AS rank1
	FROM [adw].[vw_Mbr_Assigned_TIN_NPI_ALL]
	) a
WHERE a.rank1 = 1





     --if pcp exist use it , if there are multiple pcp then use max NPI 
     --if pcp doesn't exist use blank, if multiple blank then use max NPI 
     --if pcp doesn't exist and blank doesn't exist then use specialist, if multiple specialist then use max NPI

--     SELECT [HICN], 
--            [FIRSTNAME], 
--            [LASTNAME], 
--            [SEX], 
--            [DOB], 
--            [TIN], 
--            [TIN_NAME], 
--            [NPI], 
--            [NPI_NAME], 
--            [MBR_YEAR], 
--            [MBR_QTR], 
--            1 AS [match_npi], 
--            1 AS [rank], 
--            1 AS [ranks]
--     FROM
--     (
--         SELECT DISTINCT 
--                HICN, 
--                MBR_TYPE, 
--                DOB, 
--                SEX, 
--                LASTNAME, 
--                FIRSTNAME, 
--                MBR_QTR, 
--                MBR_YEAR,
--                CASE
--                    WHEN PCP_NPI IS NOT NULL
--                    THEN PCP_NPI
--                    WHEN BLANK_NPI IS NOT NULL
--                    THEN BLANK_NPI
--                    ELSE SPL_NPI
--                END AS NPI,
--                CASE
--                    WHEN PCP_NPI_NAME IS NOT NULL
--                    THEN PCP_NPI_NAME
--                    WHEN BLANK_NPI_NAME IS NOT NULL
--                    THEN BLANK_NPI_NAME
--                    ELSE SPL_NPI_NAME
--                END AS NPI_NAME,
--                CASE
--                    WHEN PCP_TIN IS NOT NULL
--                    THEN PCP_TIN
--                    WHEN BLANK_TIN IS NOT NULL
--                    THEN BLANK_TIN
--                    ELSE SPL_TIN
--                END AS TIN,
--                CASE
--                    WHEN PCP_TINNAME IS NOT NULL
--                    THEN PCP_TINNAME
--                    WHEN BLANK_TINNAME IS NOT NULL
--                    THEN BLANK_TINNAME
--                    ELSE SPL_TINNAME
--                END AS TIN_NAME
--         FROM adw.vw_ActiveMember_ProviderPracticeProfile
--         WHERE MBR_TYPE = 'A'
--     ) a;

--GO


