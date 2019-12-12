

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[vw_Dashboard_QMDrillDown_QA]
AS
     SELECT a.[ClientMemberKey], 
            a.[QmMsrId], 
            a.[MsrDen], 
            a.[MsrNum], 
            a.MBR_TYPE, 
            a.QMDate, 
            a.[MsrCO], 
            b.NPI, 
            b.NPI_NAME, 
            c.AHR_QM_DESC AS QM_DESC,
            CASE
                WHEN a.QMDate =
     (
         SELECT MAX(z.QMDate)
         FROM adw.[vw_QM_MbrCareOp_Detail_CL_History] z
     )
                THEN 1
                ELSE 0
            END AS ACTIVE
     FROM
     (
         SELECT *
         FROM adw.[vw_QM_MbrCareOp_Detail_CL_History]
     ) a
     JOIN
     (
         SELECT DISTINCT 
                QM
         FROM lst.LIST_QM_Mapping
         WHERE ACTIVE = 'Y'
     ) z ON a.QmMsrId = z.QM
     LEFT JOIN
     (
         SELECT *
         FROM adw.[vw_member_demographics]
     ) b ON a.ClientMemberKey = b.HICN
     LEFT JOIN
     (
         SELECT [QM], 
                [QM_DESC], 
                [AHR_QM_DESC], 
                [ACTIVE]
         FROM lst.LIST_QM_Mapping
     ) c ON a.QmMsrId = c.QM;