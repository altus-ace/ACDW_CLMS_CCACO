﻿
---Update PCPAddresses
UPDATE [ACDW_CLMS_CCACO].[lst].[LIST_PCP]
SET PCP__ADDRESS = b.PCP__ADDRESS
,	PCP__ADDRESS2 = b.PCP__ADDRESS2
FROM	[ACDW_CLMS_CCACO].[lst].[LIST_PCP] a
JOIN	[ACDW_CLMS_WLC_ECAP].[lst].[LIST_PCP] b
ON		a.PCP_NPI = b.PCP_NPI
GO

---Update PCPAddresses
UPDATE [ACDW_CLMS_CCACO].[lst].[LIST_PCP]
SET PCP__ADDRESS = b.PCP__ADDRESS
,	PCP__ADDRESS2 = b.PCP__ADDRESS2
FROM	[ACDW_CLMS_CCACO].[lst].[LIST_PCP] a
JOIN	[ACDW_CLMS_WLC_ECAP].[lst].[LIST_PCP] b
ON		a.PCP_NPI = b.PCP_NPI
GO

---Update PCPAddresses
UPDATE [ACDW_CLMS_CCACO].[lst].[LIST_PCP]
SET PCP__ADDRESS = b.PCP__ADDRESS
,	PCP__ADDRESS2 = b.PCP__ADDRESS2
FROM	[ACDW_CLMS_CCACO].[lst].[LIST_PCP] a
JOIN	[ACDW_CLMS_WLC_ECAP].[lst].[LIST_PCP] b
ON		a.PCP_NPI = b.PCP_NPI
GO
