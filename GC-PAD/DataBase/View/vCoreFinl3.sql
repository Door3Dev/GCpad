USE [SNL]
GO

/****** Object:  View [GC-PAD].[vCoreFinl3]    Script Date: 12/27/2018 5:54:18 PM ******/
DROP VIEW [GC-PAD].[vCoreFinl3]
GO

/****** Object:  View [GC-PAD].[vCoreFinl3]    Script Date: 12/27/2018 5:54:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











CREATE view [GC-PAD].[vCoreFinl3]
as
select   tCoreFinl3.NaicCode, 
         tCoreFinl3.Year, 
		 tCoreFinl3.NetInvestmentIncomeEarned, 
		 tCoreFinl3.NetIncome,
		 tCoreFinl3.NetCashFromOperations,
		 tCoreFinl3.NetPremiumsEarned ,
		 tCoreFinl3.GrossPremiumsWritten,
		 tCoreFinl3.[LossAdjustedExpenseIncurred],
		 tCoreFinl3.OtherUnderwritingExpenseIncurred,
		 CompanyList.[AM_BestFinancialStrength_Rating ],
         CompanyList.[LongName],
         CompanyList.[Region]

from tCoreFinl3
inner join [GC-PAD].[vCompany_List] CompanyList ON CompanyList.NaicCode = tCoreFinl3.NaicCode
where tCoreFinl3.[Year] between 2007 and 2017 
GO


