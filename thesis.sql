/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  Database [Thesis]    Script Date: 3/15/2018 11:46:43 PM ******/
CREATE DATABASE [Thesis]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Thesis', FILENAME = N'D:\SQL\MSSQL13.MSSQLSERVER\MSSQL\DATA\Thesis.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Thesis_log', FILENAME = N'D:\SQL\MSSQL13.MSSQLSERVER\MSSQL\DATA\Thesis_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

ALTER DATABASE [Thesis] SET COMPATIBILITY_LEVEL = 130
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Thesis].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Thesis] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [Thesis] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [Thesis] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [Thesis] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [Thesis] SET ARITHABORT OFF 
GO

ALTER DATABASE [Thesis] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [Thesis] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [Thesis] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [Thesis] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [Thesis] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [Thesis] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [Thesis] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [Thesis] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [Thesis] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [Thesis] SET  DISABLE_BROKER 
GO

ALTER DATABASE [Thesis] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [Thesis] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [Thesis] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [Thesis] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [Thesis] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [Thesis] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [Thesis] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [Thesis] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [Thesis] SET  MULTI_USER 
GO

ALTER DATABASE [Thesis] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [Thesis] SET DB_CHAINING OFF 
GO

ALTER DATABASE [Thesis] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [Thesis] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [Thesis] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [Thesis] SET QUERY_STORE = OFF
GO

USE [Thesis]
GO

ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO

ALTER DATABASE [Thesis] SET  READ_WRITE 
GO

