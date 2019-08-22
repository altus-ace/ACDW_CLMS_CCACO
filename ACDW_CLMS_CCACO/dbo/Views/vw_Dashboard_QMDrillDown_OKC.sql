


/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[vw_Dashboard_QMDrillDown_OKC]
AS
     SELECT distinct a.[ClientMemberKey], 
            a.[QmMsrID], 
            a.[MsrDen], 
            a.[MsrNum], 
            a.[Mbr_Type], 
            a.QMDATE, 
            a.[MsrCO], 
            b.npi, 
            b.NPI_NAME, 
            c.AHR_QM_DESC AS QM_DESC,
            CASE
                WHEN a.QMDATE =
     (
         SELECT MAX(z.QMDATE)
         FROM adw.[vw_Dashboard_Sub_QM_MbrCareOp_Detail_CL_History] z
     )
                THEN 1
                ELSE 0
            END AS active
     FROM
     (
         SELECT *
         FROM adw.[vw_Dashboard_Sub_QM_MbrCareOp_Detail_CL_History]
     ) a
     JOIN
     (
         SELECT DISTINCT 
                QM
         FROM lst.LIST_QM_Mapping
         WHERE active = 'Y'
     ) z ON a.QmMsrID = z.QM
     LEFT JOIN
     (
         SELECT *
         FROM adw.tmp_Active_Members where exclusion = 'N' --and [Plan] <>''
     ) b ON a.clientMemberKey = b.hicn
     LEFT JOIN
     (
         SELECT [QM], 
                [QM_DESC], 
                [AHR_QM_DESC], 
                [ACTIVE]
         FROM lst.[LIST_QM_Mapping]
     ) c ON a.QmMsrID = c.QM;
