USE [SNL]
GO

/****** Object:  View [GC-PAD].[vProfitability]    Script Date: 12/27/2018 5:57:38 PM ******/
DROP VIEW [GC-PAD].[vProfitability]
GO

/****** Object:  View [GC-PAD].[vProfitability]    Script Date: 12/27/2018 5:57:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











CREATE view [GC-PAD].[vProfitability]
as
with lossratio as
(
SELECT ti.[NaicCode]
     ,ti.[year]
      ,ti.[NetLossIncurred] as NLI 
      ,ti.[NetCommissionAndBrokerage] + [NetTaxLicenseFee]+[NetOtherAcquisition] AS NAcq
      ,ti.[NetPremiumsWritten] AS NPW
      ,ti.[NetGeneralExpense] AS NGE
      ,ti.[NetAOIncurred] AS NULAEI
      ,ti.[NetPremiumsEarned] AS NPE
	  ,ni.[NetInvestmentIncomeEarned] as NetInvestmentIncome
      ,ni.NetIncome as NetIncome
      ,ni.[NetPremiumsEarned]
      ,(ni.[GrossPremiumsWritten]/1000) as GPW
	  ,(ni.OtherUnderwritingExpenseIncurred/1000) as OtherUnderwritingExpenseIncurred
      ,ni.[LossAdjustedExpenseIncurred]/1000 as LAEI
	 ,((ni.[LossAdjustedExpenseIncurred]/1000) + cast(nullif(isnull(ti.[NetLossIncurred],0),0) as decimal(10,2)))/ nullif(isnull(ti.[NetPremiumsEarned],0),0) as lossRatio
	  ,((ni.OtherUnderwritingExpenseIncurred/1000)/nullif(isnull(ti.[NetPremiumsEarned],0),0)) as Expenseratio
  FROM [GC-PAD].[vtIEE23] ti
  full join [GC-PAD].[vCoreFinl3] ni on ti.[NaicCode] = ni.[NaicCode]
     and  ti.[Year] = ni.[Year]
  where ti.year = 2017 and  ni.year = 2017 
),OperatingRatio as
(
select [NaicCode], NLI, NAcq, NPW, NGE,NULAEI,NPE, lossRatio,Expenseratio,NetInvestmentIncome,NetIncome,NetPremiumsEarned,LAEI,GPW,OtherUnderwritingExpenseIncurred,
   (lossRatio + Expenseratio) as Combinedratio,
 ((lossRatio + Expenseratio) - ([NetInvestmentIncome]/nullif(isnull([NetPremiumsEarned],0),0))) as OperatingRatio,
  (1- (NPW /  nullif(isnull(case when [GPW] < 1 then 0 else [GPW] end ,0),0))) as  CededReinsuranceRatio
from lossratio 

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
	 ,lossRatio,Expenseratio,Combinedratio,CededReinsuranceRatio,NEPcagr,OperatingRatio
from GPE_NEPcagr g
full join   OperatingRatio o on g.NaicCode = o.NaicCode

GO


