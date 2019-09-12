/*
Update Members to 'U' (Unassigned) in adw.[Assignable_Member_History]
who got services from PCP outside the primary network
*/
ALTER PROCEDURE adw.usp_UpdateAssignableMembersToU
AS

BEGIN

UPDATE adw.[Assignable_Member_History]
SET Mbr_Type = 'U'
WHERE HICN IN
(
SELECT			DISTINCT HICN FROM adw.Member_Provider_History
WHERE			MBR_YEAR = (SELECT MAX(MBR_YEAR) FROM adw.Member_Provider_History)
AND				MBR_QTR = (
							SELECT	MAX(MBR_QTR) 
							FROM adw.Member_Provider_History 
							WHERE MBR_YEAR = (SELECT MAX(MBR_YEAR) FROM adw.Member_Provider_History)
							)
AND				NPI_NAME IS NULL
)

END

SELECT * FROM adw.[Assignable_Member_History]
WHERE Mbr_Type = 'U'

AND MBR_YEAR = 2019
AND MBR_QTR = 3


SELECT *  FROM adw.AHR_Population_History
WHERE RUN_MTH= 9
AND RUN_YEAR = 2019

SELECT * FROM DBO.vw_tmp_AHR_Population
WHERE RUN_MTH = 8

SELECT * FROM adw.AHR_Population_History
WHERE LOAD_DATE = '2019-09-12'

SELECT DISTINCT RUN_MTH , RUN_YEAR
FROM adw.AHR_Population_History
ORDER BY RUN_MTH ASC, RUN_YEAR DESC

USE [ACDW_CLMS_CCACO_PriorBA]

GO

SELECT * FROM adw.AHR_Population_History
WHERE LOAD_DATE = (SELECT MAX(LOAD_DATE) FROM adw.AHR_Population_History)
AND ToSend ='Y'

SELECT * FROM DBO.vw_tmp_AHR_Population

SELECT DISTINCT RUN_DATE, RUN_YEAR, RUN_MTH FROM adw.AHR_Population_History
WHERE RUN_YEAR = 2019
ORDER BY RUN_MTH ASC



SELECT COUNT(*)TotalCNT,RUN_DATE, RUN_YEAR, RUN_MTH FROM adw.AHR_Population_History
WHERE RUN_YEAR = 2019 AND RUN_MTH = 6
GROUP BY RUN_DATE, RUN_YEAR, RUN_MTH 
ORDER BY RUN_MTH ASC


USE [ACDW_CLMS_CCACO_PriorBA]
GO
SELECT COUNT(*)TotalCNT,RUN_DATE, RUN_YEAR, RUN_MTH FROM adw.AHR_Population_History
WHERE RUN_YEAR = 2019
GROUP BY RUN_DATE, RUN_YEAR, RUN_MTH 
ORDER BY RUN_MTH ASC

USE [ACDW_CLMS_CCACO]
GO
SELECT COUNT(*)TotalCNT,RUN_DATE, RUN_MTH FROM adw.AHR_Population_History
WHERE RUN_YEAR = 2019
--AND RUN_MTH = 9
GROUP BY RUN_DATE, RUN_MTH
ORDER BY RUN_DATE ASC

UPDATE [ACDW_CLMS_CCACO].adw.AHR_Population_History
SET RUN_MTH = 6
WHERE RUN_DATE = '2019-06-05'
AND RUN_YEAR = 2019

SELECT *  FROM [ACDW_CLMS_CCACO].adw.AHR_Population_History
WHERE LOAD_DATE = '2019-09-12'
AND ToSend = 'Y'

SELECT * FROM [ACDW_CLMS_CCACO].adw.AHR_Population_History
WHERE LOAD_DATE = '2019-09-12'
select * from dbo.vw_tmp_AHR_Population