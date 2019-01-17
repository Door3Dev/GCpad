USE [SNL]
GO

/****** Object:  View [GC-PAD].[vtCoreFinl2]    Script Date: 12/27/2018 5:54:46 PM ******/
DROP VIEW [GC-PAD].[vtCoreFinl2]
GO

/****** Object:  View [GC-PAD].[vtCoreFinl2]    Script Date: 12/27/2018 5:54:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE view[GC-PAD].[vtCoreFinl2]
as
SELECT 
	   CompanyList.NaicCode,
       CompanyList.[SnlID] ,
       CompanyList.name, 
       CompanyList.LongName,
	   CompanyList.Region,
	   CompanyList.[AM_BestFinancialStrength_Rating ],
       tCoreFinl2.[Year],
	   tCoreFinl2.SurplusAsRegardsToPolicyholders as PHS,
	   tCoreFinl2.[NetAdmittedPreferredStock],
	   tCoreFinl2.[NetAdmittedCommonStock] ,
	   tCoreFinl2.[NetAdmittedDerivatives],
	   tCoreFinl2.BorrowedMoneyAndInterestThereon,
	   tCoreFinl2.[NetAdmittedRecoverablesFromReinsurance],
	   tCoreFinl2.[UnpaidLosses] , 
	   tCoreFinl2.[UnpaidLossAdjustmentExpenses]
FROM  [dbo].[tCoreFinl2]  
inner join [GC-PAD].[vCompany_List] as [CompanyList]  ON CompanyList.NaicCode = tCoreFinl2.NaicCode
where tCoreFinl2.[Year] between 2007 and 2017 
GO


