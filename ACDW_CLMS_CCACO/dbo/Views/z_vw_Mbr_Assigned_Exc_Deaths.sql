
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW dbo.z_vw_Mbr_Assigned_Exc_Deaths
AS
     SELECT MBI, 
            HICN, 
            FNAME, 
            LNAME, 
            SEX, 
            DOB, 
            DOD, 
            CM_Flg, 
            MBR_TYPE
     FROM dbo.z_Active_Members
     WHERE(DOD = '')
          AND (MBR_TYPE = 'A');
