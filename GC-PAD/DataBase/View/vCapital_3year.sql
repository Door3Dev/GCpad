USE [SNL]
GO

/****** Object:  View [GC-PAD].[vCapital_3year]    Script Date: 12/27/2018 5:57:16 PM ******/
DROP VIEW [GC-PAD].[vCapital_3year]
GO

/****** Object:  View [GC-PAD].[vCapital_3year]    Script Date: 12/27/2018 5:57:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE view [GC-PAD].[vCapital_3year]
as

with RiskAssets as
(
select Naiccode, 

 ( [NetAdmittedCommonStock] + [NetAdmittedDerivatives]) as RiskA,
  PHS2017, 
  PHS2016,
  PHS2015,
  AVGPHS, 
  [NetCashFromOperations],
  [BorrowedMoneyAndInterestThereon],
  ([NetAdmittedRecoverablesFromReinsurance]*10) as NetAdmittedRecoverablesFromReinsurance,
  ([UnpaidLosses]+[UnpaidLossAdjustmentExpenses]) as TotalReserves,
  ((PHS2017 + PHS2016)/2) as avgphs_1617,
  PHS
from
(
Select f2.[NaicCode], 
f2.[LongName],
f2.[Region],
AVG(f2.PHS) as AVGPHS,
sum(f2.PHS)  as PHS,
max(case when f2.year = 2017 then PHS end )as PHS2017,
max(case when f2.year = 2016 then PHS end )as PHS2016,
max(case when f2.year = 2015 then PHS end )as PHS2015,
sum(NetAdmittedPreferredStock) as [NetAdmittedPreferredStock], 
sum(NetAdmittedCommonStock ) as [NetAdmittedCommonStock] ,
sum(NetAdmittedDerivatives) as [NetAdmittedDerivatives],
sum( BorrowedMoneyAndInterestThereon ) as [BorrowedMoneyAndInterestThereon],
sum(NetAdmittedRecoverablesFromReinsurance ) as [NetAdmittedRecoverablesFromReinsurance],
sum(UnpaidLosses) as [UnpaidLosses] , 
sum( UnpaidLossAdjustmentExpenses ) as [UnpaidLossAdjustmentExpenses],
sum( f3.NetCashFromOperations) as [NetCashFromOperations]

from [GC-PAD].[vtCoreFinl2] f2
full join [GC-PAD].[vCoreFinl3] f3 on f2.NaicCode = f3.NaicCode and f2.Year = f3.Year
where f2.Year between 2015 and 2017 and f3.year between 2015 and 2017
Group by f2.[NaicCode], f2.[LongName],f2.[Region]
)a
)
,dp as
(

select ti.NaicCode, 
sum(ti.[DirectPremiumsWritten]) * 1000 AS DPW,
sum(ti.[NetPremiumsWritten]) * 1000 AS NPW
from [GC-PAD].[vtIEE23] ti
where ti.Year between 2015 and 2017
group by ti.NaicCode
) 
, nep as
(
select sp1.NaicCode,
sum( sp1.[NetPremiumsEarned]) AS NEP,
sum(sp3.[NLALAEP]) * 1000 AS NLAAEP

From [GC-PAD].[vtSP1]  sp1
full join [GC-PAD].[vtSP3] sp3 on sp1.NaicCode = sp3.NaicCode and sp1.Year = sp3.year
where sp1.Year between 2015 and 2017 and sp3.year between 2015 and 2017
Group by sp1.[NaicCode]
)
select isnull(ra.NaicCode,nep.NaicCode) as NaicCode,
	   ra.RiskA,
	   ra.PHS2017,
	   ra.PHS2016,
	   ra.PHS2015,
	   ra.avgphs_1617,	   
	   ra.PHS,
	   ra.AVGPHS,  
	   ra.NetCashFromOperations,
	   ra.[BorrowedMoneyAndInterestThereon],
	   ra.[NetAdmittedRecoverablesFromReinsurance],
	   ra.TotalReserves,
	   dp.DPW,	   
       nep.NEP,  
	   nep.NLAAEP,
	   dp.NPW,
	   ((ra.RiskA)/ nullif(isnull(ra.phs,0),0)) as RiskAssets,
	    (dp.NPW/nullif(isnull(ra.phs,0),0)) as NetPrem,
		(ra.NetCashFromOperations /nullif(isnull(nep.NLAAEP,0),0)) as OperatingCashPaidClaims,
       (ra.[BorrowedMoneyAndInterestThereon]/nullif(isnull(ra.[BorrowedMoneyAndInterestThereon],0)+ isnull(ra.PHS2017,0),0)) as DebttoCapital,
      ([NetAdmittedRecoverablesFromReinsurance]/nullif(isnull(ra.PHS,0),0)) as ReinsuranceRecoverable,
      ((ra.TotalReserves) / nullif(isnull(ra.PHS,0),0)) as Reserves,  
	   (dp.DPW/nullif(isnull(ra.PHS,0),0)) as CatRisk
	  
from RiskAssets ra
inner join  dp on ra.NaicCode = dp.NaicCode
full join nep on ra.NaicCode = nep.NaicCode
GO


