USE [SNL]
GO

/****** Object:  View [GC-PAD].[vcagr_Volatility]    Script Date: 12/27/2018 5:58:27 PM ******/
DROP VIEW [GC-PAD].[vcagr_Volatility]
GO

/****** Object:  View [GC-PAD].[vcagr_Volatility]    Script Date: 12/27/2018 5:58:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE view [GC-PAD].[vcagr_Volatility]
as
select
b.NaicCode, b.SnlID,b.LongName, b.Region,b.AVGPHS,b.PHS2017,b.PHS2016,b.PHS2015,b.PHS2014,b.[AM_BestFinancialStrength_Rating],
(SQRT((
POWER((RoSurplus_2017 - ((RoSurplus_2017+RoSurplus_2016+RoSurplus_2015)/3)), 2) + 
POWER( (RoSurplus_2016 - ((RoSurplus_2017+RoSurplus_2016+RoSurplus_2015)/3)), 2) + 
POWER( (RoSurplus_2015 - ((RoSurplus_2017+RoSurplus_2016+RoSurplus_2015)/3)), 2))/3)*100) as Volatility,
b.cagr

from
(
select --a.*,
a.NaicCode, a.LongName,a.SnlID, a.Region,AVGPHS,PHS2017,PHS2016,PHS2015,PHS2014, a.[AM_BestFinancialStrength_Rating],
(nullif(isnull(NI2017,0),0)/((nullif(isnull(PHS2017,0),0)+nullif(isnull(PHS2016,0),0))/2)) as RoSurplus_2017,
(nullif(isnull(NI2016,0),0)/((nullif(isnull(PHS2016,0),0)+ nullif(isnull(PHS2015,0),0))/2)) as RoSurplus_2016,
(nullif(isnull(NI2015,0),0)/ ((nullif(isnull(PHS2015,0),0)+ nullif(isnull(PHS2014,0),0))/2)) as RoSurplus_2015,
(power(nullif(isnull(case when PHS2017 < 1 then 0 else PHS2017 end,0),0) / nullif(isnull(case when PHS2014 < 1 then 0 else PHS2014 end ,0),0),(cast(1.0 as decimal(10,5)) / cast(3.0 as decimal(10,5)))) -1) as cagr
from 
(
SELECT sur.NaicCode, sur.LongName, sur.SnlID, sur.Region,sur.[AM_BestFinancialStrength_Rating],
max(case when sur.year = 2017 then sur.PHS end )as PHS2017,
max(case when sur.year = 2016 then sur.PHS end )as PHS2016,
max(case when sur.year = 2015 then sur.PHS end )as PHS2015,
max(case when sur.year = 2014 then sur.PHS end) as PHS2014,
max(case when inv.year = 2017 then inv.NetIncome end )as NI2017,
max(case when inv.year = 2016 then inv.NetIncome end )as NI2016,
max(case when inv.year = 2015 then inv.NetIncome end )as NI2015,
max(case when inv.year = 2014 then inv.NetIncome end) as NI2014,
AVG(sur.PHS) as AVGPHS
FROM [GC-PAD].[vtCoreFinl2] sur 
full join [GC-PAD].[vCoreFinl3] inv on inv.NaicCode = sur.NaicCode and  sur.year = inv.Year 
where (sur.Year between 2014 and 2017) and (inv.Year between 2014 and 2017)
group by sur.NaicCode, sur.LongName,sur.SnlID, sur.Region,sur.[AM_BestFinancialStrength_Rating]
) a
) b

GO


