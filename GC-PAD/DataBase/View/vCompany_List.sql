USE [SNL]
GO

/****** Object:  View [GC-PAD].[vCompany_List]    Script Date: 12/27/2018 5:52:39 PM ******/
DROP VIEW [GC-PAD].[vCompany_List]
GO

/****** Object:  View [GC-PAD].[vCompany_List]    Script Date: 12/27/2018 5:52:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE view [GC-PAD].[vCompany_List]
as
select 
      cl.NaicCode,
      cl.Name, 
	  cl.LongName,
	  cl.NaicGroupName, 
	  cl.NaicGroupNumber,
	  cl.Region,
	  cl.SnlID,
	  ra.[AM_BestFinancialStrength_Rating],
	  'Ratings Units' as Type
from 
[GC-PAD].[GCAM_RatingsUnits] ra
Inner Join [dbo].[CompanyList] CL on ra.[NAICCode ] = CL.NaicCode

union all

select 
      cl.NaicCode,
      cl.Name, 
	  cl.LongName,
	  cl.NaicGroupName, 
	  cl.NaicGroupNumber,
	  cl.Region,
	  cl.SnlID,
	  null as [AM_BestFinancialStrength_Rating],
	  'Groups' as Type

 from [GC-PAD].[Groups] gr 
Inner Join [dbo].[CompanyList] CL on gr.naiccode = CL.NaicCode


GO


