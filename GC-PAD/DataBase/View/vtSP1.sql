USE [SNL]
GO

/****** Object:  View [GC-PAD].[vtSP1]    Script Date: 12/27/2018 5:55:41 PM ******/
DROP VIEW [GC-PAD].[vtSP1]
GO

/****** Object:  View [GC-PAD].[vtSP1]    Script Date: 12/27/2018 5:55:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE view [GC-PAD].[vtSP1]
as
select tScheduleP1.NaicCode,
       tScheduleP1.Year,
		tScheduleP1.NetPremiumsEarned ,
		tScheduleP1.GrossPremiumsEarned,
		tScheduleP1.GrossLossPaid , 
		tScheduleP1.CededLossPaid ,
        tScheduleP1.GrossDccPaid ,
        tScheduleP1.CededDccPaid,
        tScheduleP1.GrossAOPaid ,
        tScheduleP1.CededAOPaid

from  dbo.tScheduleP1
inner join [GC-PAD].[vCompany_List] as  CompanyList  ON CompanyList.NaicCode = tScheduleP1.NaicCode
where LOBID = 350 and
tScheduleP1.year between 2007 and 2017   and tScheduleP1.AYID = 0

GO


