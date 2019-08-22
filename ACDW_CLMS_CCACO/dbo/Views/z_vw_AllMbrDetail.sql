CREATE VIEW dbo.z_vw_AllMbrDetail
AS
     SELECT DISTINCT 
            SUBSCRIBER_ID, 
            M_First_Name, 
            M_Last_Name, 
            M_Gender, 
            M_Date_Of_Birth, 
            b.NPI, 
            b.NPI_NAME, 
            b.TIN, 
            b.TIN_NAME
     FROM adw.M_MEMBER_ENR a
          LEFT JOIN adw.vw_Mbr_Assigned_TIN_NPI b ON a.SUBSCRIBER_ID = b.HICN;
