USE [SNL]
GO

/****** Object:  View [GC-PAD].[vCompany_Slicer]    Script Date: 12/27/2018 5:53:40 PM ******/
DROP VIEW [GC-PAD].[vCompany_Slicer]
GO

/****** Object:  View [GC-PAD].[vCompany_Slicer]    Script Date: 12/27/2018 5:53:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [GC-PAD].[vCompany_Slicer]
AS
Select NaicCode ,[LongName] from [GC-PAD].[vCompany_List]

GO


