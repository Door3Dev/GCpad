USE [SNL]
GO

/****** Object:  View [GC-PAD].[vtSP3]    Script Date: 12/27/2018 5:56:06 PM ******/
DROP VIEW [GC-PAD].[vtSP3]
GO

/****** Object:  View [GC-PAD].[vtSP3]    Script Date: 12/27/2018 5:56:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [GC-PAD].[vtSP3]
as
select tScheduleP3.NaicCode,
       tScheduleP3.Year,
	   tScheduleP3.NetLossDccPaid AS NLALAEP

from  dbo.tScheduleP3
inner join [GC-PAD].[vCompany_List] as  CompanyList  ON CompanyList.NaicCode = tScheduleP3.NaicCode
where LOBID = 350 and
tScheduleP3.year between 2007 and 2017   and tScheduleP3.AYID = 0

GO


