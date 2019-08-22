

CREATE PROCEDURE [adw].[sp_mst_Create_tmp_AHR_HL7_Tables]
AS 
    
	EXEC adw.sp_Ahr_Load_tmpAhrHL7ReportHeader;
	EXEC adw.sp_Ahr_Load_tmpAhrHL7ReportDetailCG;
	EXEC adw.sp_Ahr_Load_tmpAhrHL7ReportDetailDx;
	EXEC adw.sp_Ahr_Load_tmpAhrHL7ReportDetailIP;
	EXEC adw.sp_Ahr_Load_tmpAhrHL7ReportDetailER;
