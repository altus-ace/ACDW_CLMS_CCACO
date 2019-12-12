/*
Update Members to 'U' (Unassigned) in adw.[Assignable_Member_History]
who got services from PCP outside the primary network
*/
CREATE PROCEDURE adw.usp_UpdateAssignableMembersToU
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