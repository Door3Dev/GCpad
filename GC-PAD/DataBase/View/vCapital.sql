USE [SNL]
GO

/****** Object:  View [GC-PAD].[vCapital]    Script Date: 12/27/2018 5:56:52 PM ******/
DROP VIEW [GC-PAD].[vCapital]
GO

/****** Object:  View [GC-PAD].[vCapital]    Script Date: 12/27/2018 5:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [GC-PAD].[vCapital]
as

with RiskAssets as
(
select Naiccode, 

 ( [NetAdmittedCommonStock2017] + [NetAdmittedDerivatives2017]) as RiskA,
  PHS2017, 
  PHS2016,
  AVGPHS, 
  [NetCashFromOperations2017],
  [BorrowedMoneyAndInterestThereon2017],
  ([NetAdmittedRecoverablesFromReinsurance2017]*10) as NetAdmittedRecoverablesFromReinsurance2017,
  ([UnpaidLosses2017]+[UnpaidLossAdjustmentExpenses2017]) as TotalReserves,
  ((PHS2017 + PHS2016)/2) as avgphs_1617
from
(
Select f2.[NaicCode], 
f2.[LongName],
f2.[Region],
AVG(f2.PHS) as AVGPHS,
max(case when f2.year = 2017 then PHS end )as PHS2017,
max(case when f2.year = 2016 then PHS end )as PHS2016,
max(case when f2.year = 2017 then NetAdmittedPreferredStock end ) as [NetAdmittedPreferredStock2017], 
max(case when f2.year = 2017 then NetAdmittedCommonStock end ) as [NetAdmittedCommonStock2017] ,
max(case when f2.year = 2017 then NetAdmittedDerivatives end ) as [NetAdmittedDerivatives2017],
max(case when f2.year = 2017 then BorrowedMoneyAndInterestThereon end ) as [BorrowedMoneyAndInterestThereon2017],
max(case when f2.year = 2017 then NetAdmittedRecoverablesFromReinsurance end ) as [NetAdmittedRecoverablesFromReinsurance2017],
max(case when f2.year = 2017 then UnpaidLosses end ) as [UnpaidLosses2017] , 
max(case when f2.year = 2017 then UnpaidLossAdjustmentExpenses end ) as [UnpaidLossAdjustmentExpenses2017],
max(case when f3.year = 2017 then f3.NetCashFromOperations end ) as [NetCashFromOperations2017]

from [GC-PAD].[vtCoreFinl2] f2
full join [GC-PAD].[vCoreFinl3] f3 on f2.NaicCode = f3.NaicCode and f2.Year = f3.Year
where f2.Year between 2015 and 2017 and f3.year between 2015 and 2017
Group by f2.[NaicCode], f2.[LongName],f2.[Region]
)a
)
,dp as
(

select ti.NaicCode, 
max(case when ti.year = 2017 then ti.[DirectPremiumsWritten] end) * 1000 AS DPW2017,
max(case when ti.year = 2017 then ti.[NetPremiumsWritten] end) * 1000 AS NPW2017
from [GC-PAD].[vtIEE23] ti
where ti.Year between 2015 and 2017
group by ti.NaicCode
) 
, nep as
(
select sp1.NaicCode,
max(case when sp1.year = 2017 then sp1.[NetPremiumsEarned] end) AS NEP2017,
max(case when sp3.year = 2017 then sp3.[NLALAEP] end) * 1000 AS NLAAEP2017

From [GC-PAD].[vtSP1]  sp1
full join [GC-PAD].[vtSP3] sp3 on sp1.NaicCode = sp3.NaicCode and sp1.Year = sp3.year
where sp1.Year between 2015 and 2017 and sp3.year between 2015 and 2017
Group by sp1.[NaicCode]
)
select isnull(ra.NaicCode,nep.NaicCode) as NaicCode,
	   ra.RiskA,
	   ra.PHS2017,
	   ra.PHS2016,
	   ra.AVGPHS,
	   ra.avgphs_1617,
	   ra.NetCashFromOperations2017,
	   ra.[BorrowedMoneyAndInterestThereon2017],
	   ra.[NetAdmittedRecoverablesFromReinsurance2017],
	   ra.TotalReserves,
	   dp.DPW2017,	   
       nep.NEP2017,  
	   nep.NLAAEP2017,
	   dp.NPW2017,
	   ((ra.RiskA)/ nullif(isnull(ra.avgphs_1617,0),0)) as RiskAssets,
	    (dp.NPW2017/nullif(isnull(ra.avgphs_1617,0),0)) as NetPrem,
		(ra.NetCashFromOperations2017 /nullif(isnull(nep.NLAAEP2017,0),0)) as OperatingCashPaidClaims,
       (ra.[BorrowedMoneyAndInterestThereon2017]/nullif(isnull(ra.[BorrowedMoneyAndInterestThereon2017],0)+ isnull(ra.PHS2017,0),0)) as DebttoCapital,
      ([NetAdmittedRecoverablesFromReinsurance2017]/nullif(isnull(AVGPHS,0),0)) as ReinsuranceRecoverable,
      ((ra.TotalReserves) / nullif(isnull(PHS2017,0),0)) as Reserves,  
	   (dp.DPW2017/nullif(isnull(ra.PHS2017,0),0)) as CatRisk
	  
from RiskAssets ra
inner join  dp on ra.NaicCode = dp.NaicCode
full join nep on ra.NaicCode = nep.NaicCode
GO


