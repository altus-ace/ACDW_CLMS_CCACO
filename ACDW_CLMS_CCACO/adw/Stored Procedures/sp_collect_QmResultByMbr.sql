CREATE PROCEDURE adw.[sp_collect_QmResultByMbr]
AS

/*
    1. Ensures all distinct working tables have current and corrcect values
	   a. truncate
	   b. insert
    2. Load the results from the working tables into the QMResultByMbr_CL
    3. Load the result into the acumulation table
    */
     /* Prep non-loaded working tables??? */

     TRUNCATE TABLE [dbo].[tmp_QM_CDC_9_DEN];
     INSERT INTO [dbo].[tmp_QM_CDC_9_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_CDC_8_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_CDC_BP_DEN];
     INSERT INTO [dbo].[tmp_QM_CDC_BP_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_CDC_8_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_CDC_E_DEN];
     INSERT INTO [dbo].[tmp_QM_CDC_E_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_CDC_8_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_CDC_HB_DEN];
     INSERT INTO [dbo].[tmp_QM_CDC_HB_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_CDC_8_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_CDC_N_DEN];
     INSERT INTO [dbo].[tmp_QM_CDC_N_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_CDC_8_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_PCE_S_DEN];
     INSERT INTO [dbo].[tmp_QM_PCE_S_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_PCE_B_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_WC1_DEN];
     INSERT INTO [dbo].[tmp_QM_WC1_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_WC0_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_WC2_DEN];
     INSERT INTO [dbo].[tmp_QM_WC2_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_WC0_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_WC3_DEN];
     INSERT INTO [dbo].[tmp_QM_WC3_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_WC0_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_WC4_DEN];
     INSERT INTO [dbo].[tmp_QM_WC4_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_WC0_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_WC5_DEN];
     INSERT INTO [dbo].[tmp_QM_WC5_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_WC0_DEN];
     TRUNCATE TABLE [dbo].[tmp_QM_WC6_DEN];
     INSERT INTO [dbo].[tmp_QM_WC6_DEN]
            SELECT *
            FROM [dbo].[tmp_QM_WC0_DEN];

     /* load results into adw.QM_ResultByMember */

     TRUNCATE TABLE adw.QM_ResultByMember_CL;
     INSERT INTO adw.QM_ResultByMember_CL
     (ClientMemberKey, 
      QmMsrId, 
      QmCntCat
     )
            SELECT *, 
                   'ABA' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_ABA_DEN
            UNION
            SELECT *, 
                   'ABA' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_ABA_NUM
            UNION
            SELECT *, 
                   'ART' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_ART_DEN
            UNION
            SELECT *, 
                   'ART' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_ART_NUM
            UNION
            SELECT *, 
                   'AWC' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_AWC_DEN
            UNION
            SELECT *, 
                   'AWC' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_AWC_NUM
            UNION
            SELECT *, 
                   'BCS' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_BCS_DEN
            UNION
            SELECT *, 
                   'BCS' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_BCS_NUM
            UNION
            SELECT *, 
                   'CCS' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_CCS_NUM
            UNION
            SELECT *, 
                   'CCS' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_CCS_DEN
            UNION
            SELECT *, 
                   'CDC_8' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_CDC_8_DEN
            UNION
            SELECT *, 
                   'CDC_8' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_CDC_8_NUM
            UNION
            SELECT *, 
                   'CDC_9' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_CDC_8_DEN
            UNION
            SELECT *, 
                   'CDC_9' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_CDC_9_NUM
            UNION
            SELECT *, 
                   'CDC_BP' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_CDC_8_DEN
            UNION
            SELECT *, 
                   'CDC_BP' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_CDC_BP_NUM
            UNION
            SELECT *, 
                   'CDC_E' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_CDC_8_DEN
            UNION
            SELECT *, 
                   'CDC_E' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_CDC_E_NUM
            UNION
            SELECT *, 
                   'CDC_HB' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_CDC_8_DEN
            UNION
            SELECT *, 
                   'CDC_HB' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_CDC_HB_NUM
            UNION
            SELECT *, 
                   'CDC_N' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_CDC_8_DEN
            UNION
            SELECT *, 
                   'CDC_N' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_CDC_N_NUM
            UNION
            SELECT *, 
                   'COL' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_COL_DEN
            UNION
            SELECT *, 
                   'COL' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_COL_NUM
            UNION
            SELECT *, 
                   'PCE_B' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_PCE_B_DEN
            UNION
            SELECT *, 
                   'PCE_B' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_PCE_B_NUM
            UNION
            SELECT *, 
                   'PCE_S' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_PCE_B_DEN
            UNION
            SELECT *, 
                   'PCE_S' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_PCE_S_NUM
            UNION
            SELECT *, 
                   'SPR' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_SPR_DEN
            UNION
            SELECT *, 
                   'SPR' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_SPR_NUM
            UNION
            SELECT *, 
                   'WC0' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_WC0_DEN
            UNION
            SELECT *, 
                   'WC0' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_WC0_NUM
            UNION
            SELECT *, 
                   'WC1' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_WC0_DEN
            UNION
            SELECT *, 
                   'WC1' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_WC1_NUM
            UNION
            SELECT *, 
                   'WC2' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_WC0_DEN
            UNION
            SELECT *, 
                   'WC2' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_WC2_NUM
            UNION
            SELECT *, 
                   'WC3' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_WC0_DEN
            UNION
            SELECT *, 
                   'WC3' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_WC3_NUM
            UNION
            SELECT *, 
                   'WC3' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_WC36_DEN
            UNION
            SELECT *, 
                   'WC3' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_WC36_NUM
            UNION
            SELECT *, 
                   'WC4' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_WC0_DEN
            UNION
            SELECT *, 
                   'WC4' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_WC4_NUM
            UNION
            SELECT *, 
                   'WC5' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_WC0_DEN
            UNION
            SELECT *, 
                   'WC5' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_WC5_NUM
            UNION
            SELECT *, 
                   'WC6' AS QmMsrId, 
                   'DEN' AS QmCntCat
            FROM tmp_QM_WC0_DEN
            UNION
            SELECT *, 
                   'WC6' AS QmMsrId, 
                   'NUM' AS QmCntCat
            FROM tmp_QM_WC6_NUM;

     /* INSERT INTO HISTORY */

     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate]
     )
            SELECT [ClientMemberKey], 
                   [QmMsrId], 
                   [QmCntCat], 
                   [QMDate]
            FROM adw.QM_ResultByMember_CL;
