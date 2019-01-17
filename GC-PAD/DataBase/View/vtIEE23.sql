USE [SNL]
GO

/****** Object:  View [GC-PAD].[vtIEE23]    Script Date: 12/27/2018 5:55:15 PM ******/
DROP VIEW [GC-PAD].[vtIEE23]
GO

/****** Object:  View [GC-PAD].[vtIEE23]    Script Date: 12/27/2018 5:55:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE View [GC-PAD].[vtIEE23]
as

with all_others 
as
(
select   tIEE23.NaicCode
         ,tIEE23.year 
		 ,tIEE23.LOBID 
		 ,tIEE23.NetLossIncurred
		 ,tIEE23.NetCommissionAndBrokerage
		 ,tIEE23.NetTaxLicenseFee 
		 ,tIEE23.NetOtherAcquisition 
		 ,tIEE23.NetPremiumsWritten 
		 ,tIEE23.NetGeneralExpense 
		 ,tIEE23.NetAOIncurred 
		 ,tIEE23.NetPremiumsEarned
         --,[LOB].LOB
		 --,[CompanyList].OperatingStatus

from dbo.tIEE23 
inner join [dbo].[LOB]  on tIEE23.LOBID = [LOB].LOBID
inner join [GC-PAD].[vCompany_List] as [CompanyList]  ON CompanyList.NaicCode = tIEE23.NaicCode
where [LOB].LOBID = 350 and 
tIEE23.year between 2007 and 2017 
)
,dpw as
(
 select   tIEE23.NaicCode
         ,tIEE23.year 
		 ,tIEE23.LOBID  as DPWLOBId
		 ,tIEE23.DirectPremiumsWritten
         --,[LOB].LOB
		 --,[CompanyList].OperatingStatus

from dbo.tIEE23 
inner join [dbo].[LOB]  on tIEE23.LOBID = [LOB].LOBID
inner join [GC-PAD].[vCompany_List] as [CompanyList]  ON CompanyList.NaicCode = tIEE23.NaicCode
where [LOB].LOBID = 403 and 
tIEE23.year between 2007 and 2017   

)

select 
          isnull( a.NaicCode,d.naiccode) as NaicCode
         ,isnull(a.year , d.year) as year
		 ,a.LOBID 
		 ,a.NetLossIncurred
		 ,a.NetCommissionAndBrokerage
		 ,a.NetTaxLicenseFee 
		 ,a.NetOtherAcquisition 
		 ,a.NetPremiumsWritten 
		 ,a.NetGeneralExpense 
		 ,a.NetAOIncurred 
		 ,a.NetPremiumsEarned 
		 ,d.DPWLOBId
		 ,d.DirectPremiumsWritten

from all_others a
full  join dpw  d on  a.NaicCode = d.NaicCode and a.Year = d.year


GO


