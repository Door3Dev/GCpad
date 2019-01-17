USE [SNL]
GO

/****** Object:  View [GC-PAD].[vProfitability_3year]    Script Date: 12/27/2018 5:58:03 PM ******/
DROP VIEW [GC-PAD].[vProfitability_3year]
GO

/****** Object:  View [GC-PAD].[vProfitability_3year]    Script Date: 12/27/2018 5:58:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [GC-PAD].[vProfitability_3year]
as
with tiee as
(
SELECT ti.[NaicCode]
      ,sum(ti.[NetLossIncurred]) as NLI 
      ,sum(ti.[NetCommissionAndBrokerage]) + sum([NetTaxLicenseFee]) + sum([NetOtherAcquisition]) AS NAcq
      ,sum(ti.[NetPremiumsWritten]) AS NPW
      ,sum(ti.[NetGeneralExpense]) AS NGE
      ,sum(ti.[NetAOIncurred]) AS NULAEI
      ,sum(ti.[NetPremiumsEarned]) AS NPE

FROM [GC-PAD].[vtIEE23] ti   where ti.year in(2015,2016,2017)
group by NaicCode
),cfinl3 as
	  (
	 select ni.NaicCode
	  ,sum(ni.[NetInvestmentIncomeEarned]) as NetInvestmentIncome
      ,sum(ni.NetIncome) as NetIncome
      ,sum(ni.[NetPremiumsEarned]) as NetPremiumsEarned
      ,sum(ni.[GrossPremiumsWritten]/1000) as GPW
	  ,sum(ni.OtherUnderwritingExpenseIncurred/1000) as OtherUnderwritingExpenseIncurred
      ,sum(ni.[LossAdjustedExpenseIncurred]/1000) as LAEI
	
  FROM [GC-PAD].[vCoreFinl3] ni 
  where  ni.year in (2015, 2016,2017 )
  group by NaicCode
),OperatingRatio as
(
select isnull(ti.[NaicCode], ni.NaicCode) as NaicCode,
        ti.NLI,
	    ti.NAcq,
	    ti.NPW, 
		ti.NGE,
		ti.NULAEI,
		ti.NPE, 
		ni.NetInvestmentIncome,
		ni.NetIncome,
		ni.NetPremiumsEarned,
		ni.LAEI,
		ni.GPW,
		ni.OtherUnderwritingExpenseIncurred,
		((nullif(isnull(ni.[LAEI],0),0)) + (nullif(isnull(ti.[NLI],0),0)))/ nullif(isnull(ti.[NPE],0),0) as lossRatio,
	   ((ni.OtherUnderwritingExpenseIncurred)/nullif(isnull(ti.[NPE],0),0)) as Expenseratio,
	   (1- (NPW /  nullif(isnull(case when [GPW] < 1 then 0 else [GPW] end ,0),0))) as  CededReinsuranceRatio
from tiee ti
full join cfinl3 ni on  ti.naiccode = ni.NaicCode

)--select * from OperatingRatio order by NAICCODE
,GPE_NEPcagr
as
(
select a.*
,(power(nullif(isnull(case when NEP2017 < 1 then 0 else NEP2017 end,0),0) / nullif(isnull(case when NEP2015 < 1 then 0 else NEP2015 end ,0),0),(cast(1.0 as decimal(10,5)) / cast(3.0 as decimal(10,5)))) -1) as NEPcagr
from (
select [NaicCode],
max(case when year = 2017 then [NetPremiumsEarned] end) AS NEP2017,
max(case when year = 2015 then [NetPremiumsEarned] end) AS NEP2015,
max(case when year = 2017 then [GrossPremiumsEarned] end )AS GPE2017
from [GC-PAD].[vtSP1]
where year between 2015 and 2017 
group by NAICCODE
) a
) 

select g.[NaicCode] NC
     ,NEP2017
	 ,GPE2017	 
     ,o.[NaicCode],NLI, NAcq, NPW, NGE,NULAEI,NPE, LAEI, NetIncome,o.NetInvestmentIncome,[NetPremiumsEarned],GPW,OtherUnderwritingExpenseIncurred
	 ,lossRatio,Expenseratio,
	  (lossRatio + Expenseratio) as Combinedratio,
	  CededReinsuranceRatio,NEPcagr,
	 ((lossRatio + Expenseratio) - ([NetInvestmentIncome]/nullif(isnull([NetPremiumsEarned],0),0))) as OperatingRatio
from GPE_NEPcagr g
full join   OperatingRatio o on g.NaicCode = o.NaicCode

GO


