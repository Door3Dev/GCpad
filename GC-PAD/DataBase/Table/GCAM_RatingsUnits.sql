USE [SNL]
GO

/****** Object:  Table [GC-PAD].[GCAM_RatingsUnits]    Script Date: 12/27/2018 5:50:30 PM ******/
DROP TABLE [GC-PAD].[GCAM_RatingsUnits]
GO

/****** Object:  Table [GC-PAD].[GCAM_RatingsUnits]    Script Date: 12/27/2018 5:50:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [GC-PAD].[GCAM_RatingsUnits](
	[Entity_Name ] [varchar](255) NULL,
	[SNL _Statutory_EntityKey ] [varchar](55) NULL,
	[NAIC_GroupNumber  ] [float] NULL,
	[NAICCode ] [int] NOT NULL,
	[AM_BestFinancialStrength_Rating ] [varchar](5) NULL,
 CONSTRAINT [PK_GCAM_RatingsUnits_NaicCode] PRIMARY KEY CLUSTERED 
(
	[NAICCode ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


