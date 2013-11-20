USE hxdb
go

/*
   一.权限相关表(6 tables)
 
*/

-- 1. IAUDIT_PERMISSION
/*
   权限表
 
*/
drop table IAUDIT_PERMISSION
go

CREATE TABLE IAUDIT_PERMISSION
(
    PERM_ID        numeric(6,0)   NOT NULL,
    PERM_NAME      varchar(100)   NULL,
    PERM_DESC      varchar(200)   NULL,
    PERM_TYPE      numeric(2,0)   NOT NULL,
    PARENT_PERM_ID numeric(6,0)   NULL,
    URL            varchar(200)   NULL,
    ORDER_NO       numeric(3,0)   NULL,
    ISUSERED       numeric(1,0)   DEFAULT 1     NULL,
    CONSTRAINT PK_IAUDIT_PERMISSION
    PRIMARY KEY NONCLUSTERED (PERM_ID)
) on HXPARA
go
IF OBJECT_ID('IAUDIT_PERMISSION') IS NOT NULL
    PRINT '<<< CREATED TABLE IAUDIT_PERMISSION >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE IAUDIT_PERMISSION >>>'
go

-- 2. IAUDIT_ROLE
/*
   角色表
 
*/
drop table IAUDIT_ROLE
go

CREATE TABLE IAUDIT_ROLE
(
    ROLE_ID   numeric(6,0) NOT NULL,
    ROLE_NAME varchar(30)  NULL,
    ROLE_TYPE numeric(2,0) NULL,
    USER_ID   numeric(6,0) NULL,
    CONSTRAINT PK_IAUDIT_ROLE
    PRIMARY KEY NONCLUSTERED (ROLE_ID)
) on HXPARA
go
IF OBJECT_ID('IAUDIT_ROLE') IS NOT NULL
    PRINT '<<< CREATED TABLE IAUDIT_ROLE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE IAUDIT_ROLE >>>'
go

-- 3. IAUDIT_ROLE_OBJECT
/*
   对象表
 
*/
drop table IAUDIT_ROLE_OBJECT
go
CREATE TABLE IAUDIT_ROLE_OBJECT
(
    ROLE_ID      numeric(6,0) NOT NULL,
    OBJECT_ID    numeric(6,0) NOT NULL,
    OPERATE_FLAG numeric(1,0) NULL,
    CONSTRAINT PK_IAUDIT_ROLE_OBJECT
    PRIMARY KEY NONCLUSTERED (ROLE_ID,OBJECT_ID)
) on HXPARA
go
IF OBJECT_ID('IAUDIT_ROLE_OBJECT') IS NOT NULL
    PRINT '<<< CREATED TABLE IAUDIT_ROLE_OBJECT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE IAUDIT_ROLE_OBJECT >>>'
go

-- 4. IAUDIT_ROLE_PERMISSION
/*
   角色权限表
 
*/
drop table IAUDIT_ROLE_PERMISSION
go
CREATE TABLE IAUDIT_ROLE_PERMISSION
(
    ROLE_ID    numeric(6,0) NOT NULL,
    PERM_ID    numeric(6,0) NOT NULL,
    AUDIT_TIME datetime     NULL,
    CONSTRAINT PK_IAUDIT_ROLE_PERMISSION
    PRIMARY KEY NONCLUSTERED (ROLE_ID,PERM_ID)
) on HXPARA
go
IF OBJECT_ID('IAUDIT_ROLE_PERMISSION') IS NOT NULL
    PRINT '<<< CREATED TABLE IAUDIT_ROLE_PERMISSION >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE IAUDIT_ROLE_PERMISSION >>>'
go


-- 5. IAUDIT_USER
/*
   用户表
 
*/
-- 取消IPARA_MTRSTATUS外键约束先，才能删除此表
ALTER TABLE IPARA_MTRSTATUS DROP CONSTRAINT FK_IPARA_MTRSTATUS_1
go

ALTER TABLE LOG_USERLOGIN_OUT DROP CONSTRAINT FK_LOG_USERLOGIN_OUT_1
go

drop table IAUDIT_USER
go

CREATE TABLE IAUDIT_USER
(
    USER_ID          numeric(6,0) NOT NULL,
    USER_ACCOUNT     varchar(20)   NULL,
    USER_NAME        varchar(30)   NULL,
    USER_DESC        varchar(30)   NULL,
    USER_TYPE        numeric(2,0)  NULL,
    PASSWORD         varchar(100)  NULL,
    TELEPHONE        varchar(16)   NULL,
    MOBILE_TELEPHONE varchar(16)   NULL,
    EMAIL            varchar(40)   NULL,
    GENDER           numeric(2,0)  NULL,
    POSITION         varchar(30)   NULL,
    ADDRESS          varchar(40)   NULL,
    CREATE_TIME      datetime      NULL,
    CREATE_END       datetime      NULL,
    CREATER          numeric(6,0)  NULL,
    NOTE             varchar(100)  NULL,
    IP               varchar(200)  NULL,
    PWDPRETIME       datetime      NULL,
    PWDLIMITTIME     numeric(2,0)  DEFAULT 30 NULL,
    MODIFYDATE       datetime      NULL,
    ISDELETE         numeric(2,0)  DEFAULT 0 NULL,
    CONSTRAINT PK_IAUDIT_USER
    PRIMARY KEY NONCLUSTERED (USER_ID)
) on HXPARA
go
IF OBJECT_ID('IAUDIT_USER') IS NOT NULL
    PRINT '<<< CREATED TABLE IAUDIT_USER >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE IAUDIT_USER >>>'
go

INSERT [dbo].[IAUDIT_USER] ([USER_ID], [USER_ACCOUNT], [USER_NAME], [USER_DESC], [USER_TYPE], [PASSWORD], [TELEPHONE], [MOBILE_TELEPHONE], [EMAIL], [GENDER], [POSITION], [ADDRESS], [CREATE_TIME], [CREATE_END], [CREATER], [NOTE], [IP], [PWDPRETIME], [PWDLIMITTIME], [MODIFYDATE], [ISDELETE])
  VALUES (CAST(0 AS Numeric(6, 0)), N'Administrator', NULL, NULL, CAST(-1 AS Numeric(2, 0)), N'E10ADC3949BA59ABBE56E057F20F883E', N'0571-88888888', N'13800571505', N'admin@hotmail.com', CAST(0 AS Numeric(2, 0)), NULL, N'CENTLEC ', CAST(0x00009B8400000000 AS DateTime), CAST(0x0000AC8F00000000 AS DateTime), NULL, N'first user of the system.', NULL, CAST(0x0000A0FD00CDB93C AS DateTime), CAST(90 AS Numeric(2, 0)), CAST(0x0000A0FD00CDB93C AS DateTime), CAST(0 AS Numeric(2, 0)))
go


-- 6. IAUDIT_USER_ROLE
/*
   用户角色表
 
*/
drop table IAUDIT_USER_ROLE
go

CREATE TABLE IAUDIT_USER_ROLE
(
    USER_ID    numeric(6,0) NOT NULL,
    ROLE_ID    numeric(6,0) NOT NULL,
    AUDIT_TIME datetime     NULL,
    CONSTRAINT PK_IAUDIT_USER_ROLE
    PRIMARY KEY NONCLUSTERED (USER_ID,ROLE_ID)
) on HXPARA
go
IF OBJECT_ID('IAUDIT_USER_ROLE') IS NOT NULL
    PRINT '<<< CREATED TABLE IAUDIT_USER_ROLE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE IAUDIT_USER_ROLE >>>'
go


/*
   二.内核参数相关表(12 tables)
 
*/

-- 7. IKERNEL_CT
/*
   CT参数表
 
*/
drop table IKERNEL_CT
go

CREATE TABLE IKERNEL_CT
(
    CT_CODE    varchar(6)    NOT NULL,
    CT_DESC    varchar(20)   NULL,
    CT_RATIO   varchar(20)   NULL,
    MODIFYDATE datetime      NULL,
    ISDELETE   numeric(2,0)  DEFAULT 0 NULL,
    CONSTRAINT PK_IKERNEL_CT
    PRIMARY KEY NONCLUSTERED (CT_CODE)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_CT') IS NOT NULL
    PRINT '<<< CREATED TABLE 7.IKERNEL_CT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 7.IKERNEL_CT >>>'
go

-- 8. IKERNEL_DEBTTYPE
/*
   债务类型参数表
 
*/
drop table IKERNEL_DEBTTYPE
go

CREATE TABLE IKERNEL_DEBTTYPE
(
    ID            numeric(3,0)  NOT NULL,
    DEBT_TYPENAME varchar(20)   NOT NULL,
    CONSTRAINT PK_IKERNEL_DEBTTYPE
    PRIMARY KEY NONCLUSTERED (ID)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_DEBTTYPE') IS NOT NULL
    PRINT '<<< CREATED TABLE 8.IKERNEL_DEBTTYPE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 8.IKERNEL_DEBTTYPE >>>'
go

-- 9. IKERNEL_FEETYPE
/*
   税费收取方式表
 
*/
drop table IKERNEL_FEETYPE
go

CREATE TABLE IKERNEL_FEETYPE
(
    FEEMETHODID numeric(3,0) NOT NULL,
    FM_NAME     varchar(50)  NULL,
    CONSTRAINT PK_TARIFF_FEEMETHOD
    PRIMARY KEY NONCLUSTERED (FEEMETHODID)
)ON HXPARA
go
IF OBJECT_ID('dbo.IKERNEL_FEETYPE') IS NOT NULL
    PRINT '<<< CREATED TABLE 9.IKERNEL_FEETYPE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 9.IKERNEL_FEETYPE >>>'
go

-- 10. IKERNEL_INSDUSTRY_TYPE
/*
   工业类型参数表
 
*/
drop table IKERNEL_INSDUSTRY_TYPE
go

CREATE TABLE IKERNEL_INSDUSTRY_TYPE
(
    INDUSTRY_ID varchar(8)   NOT NULL,
    CONTENT     varchar(70)  NULL,
    PHYLUM_TYPE varchar(2)   NULL,
    LARGE_TYPE  varchar(4)   NULL,
    MIDDLE_TYPE varchar(6)   NULL,
    SMALL_TYPE  varchar(8)   NULL,
    CONSTRAINT PK_IKERNEL_INSDUSTRY_TYPE
    PRIMARY KEY NONCLUSTERED (INDUSTRY_ID)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_INSDUSTRY_TYPE') IS NOT NULL
    PRINT '<<< CREATED TABLE 10.IKERNEL_INSDUSTRY_TYPE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 10.IKERNEL_INSDUSTRY_TYPE >>>'
go

-- 11. IKERNEL_MANUFACTURER
/*
   厂家类型参数表
 
*/
drop table IKERNEL_MANUFACTURER
go

CREATE TABLE IKERNEL_MANUFACTURER
(
    MANUFACTURER_ID   varchar(4)   NOT NULL,
    MANUFACTURER_DESC varchar(40)  NULL,
    CONSTRAINT PK_IKERNEL_MANUFACTURER
    PRIMARY KEY NONCLUSTERED (MANUFACTURER_ID)
) on HXPARA
go
IF OBJECT_ID('dbo.IKERNEL_MANUFACTURER') IS NOT NULL
    PRINT '<<< CREATED TABLE 11.IKERNEL_MANUFACTURER >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 11.IKERNEL_MANUFACTURER >>>'
go


-- 12. IKERNEL_MT_PROTOCOL
/*
   表计协议参数表
 
*/
drop table IKERNEL_MT_PROTOCOL
go

CREATE TABLE IKERNEL_MT_PROTOCOL
(
    MT_PROTOCOL_ID   numeric(3,0) NOT NULL,
    MT_PROTOCOL_DESC varchar(40)  NULL,
    CONSTRAINT PK_IKERNEL_MT_PROTOCOL
    PRIMARY KEY NONCLUSTERED (MT_PROTOCOL_ID)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_MT_PROTOCOL') IS NOT NULL
    PRINT '<<< CREATED TABLE 12.IKERNEL_MT_PROTOCOL >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 12.IKERNEL_MT_PROTOCOL >>>'
go

-- 13. IKERNEL_MT_TYPE
/*
   表计类型参数表
 
*/
drop table IKERNEL_MT_TYPE
go

CREATE TABLE IKERNEL_MT_TYPE
(
    MT_MODEL_ID           numeric(3,0)  NOT NULL,
    MT_MODEL_DESC         varchar(60)   NULL,
    MANUFACTURER_ID       varchar(4)    NULL,
    MT_PROTOCOL_ID        numeric(3,0)  NULL,
    TARIFF_NUM            numeric(2,0)  NULL,
    CONNECT_TYPE          numeric(2,0)  NULL,
    BAUDRATE              numeric(8,0)  NULL,
    PARITY_MODE           numeric(2,0)  NULL,
    PASSWORD              varchar(20)   NULL,
    KWH_DECIMAL_DIGITS    numeric(1,0)  NULL,
    KVARH_DECIMAL_DIGITS  numeric(1,0)  NULL,
    KW_DECIMAL_DIGITS     numeric(1,0)  NULL,
    KVAR_DECIMAL_DIGITS   numeric(1,0)  NULL,
    PF_DECIMAL_DIGITS     numeric(1,0)  NULL,
    AMPERE_DECIMAL_DIGITS numeric(1,0)  NULL,
    VOLTS_DECIMAL_DIGITS  numeric(1,0)  NULL,
    CURRENT_RATING        numeric(12,0) NULL,
    VOLTAGE_RATING        varchar(12)   NULL,
    CLASS                 varchar(12)   NULL,
    CONSTANT              varchar(20)   NULL,
    MAX_POWER_VALUE       varchar(9)    NULL,
    METER_TYPE            numeric(2,0)  DEFAULT 0 NULL,
    METER_CREDITMETHOD    numeric(2,0)  NULL,
    MODIFYDATE            datetime      NULL,
    ISDELETE              numeric(2,0)  DEFAULT 0 NULL,
    CONSTRAINT PK_IKERNEL_MT_TYPE
    PRIMARY KEY NONCLUSTERED (MT_MODEL_ID)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_MT_TYPE') IS NOT NULL
    PRINT '<<< CREATED TABLE 13.IKERNEL_MT_TYPE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 13.IKERNEL_MT_TYPE >>>'
go

-- 14. IKERNEL_MTRSTATUS
/*
   表计生命周期状态参数表
 
*/
drop table IKERNEL_MTRSTATUS
go

CREATE TABLE IKERNEL_MTRSTATUS
(
    ID          numeric(3,0)  NOT NULL,
    NAME        varchar(20)   NOT NULL,
    STATUS_DESC varchar(60)   NULL,
    ISVENDING   numeric(1,0)  NULL,
    CONSTRAINT PK_IKERNEL_MTRSTATUS
    PRIMARY KEY NONCLUSTERED (ID)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_MTRSTATUS') IS NOT NULL
    PRINT '<<< CREATED TABLE 14.IKERNEL_MTRSTATUS >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 14.IKERNEL_MTRSTATUS >>>'
go

-- 15. IKERNEL_POWER
/*
   电量数据类型参数表
 
*/
drop table IKERNEL_POWER
go

CREATE TABLE IKERNEL_POWER
(
    POWER_ID   numeric(2,0) NOT NULL,
    POWER_DESC varchar(30)  NULL,
    CONSTRAINT PK_IKERNEL_POWER
    PRIMARY KEY NONCLUSTERED (POWER_ID)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_POWER') IS NOT NULL
    PRINT '<<< CREATED TABLE 17.IKERNEL_POWER >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 17.IKERNEL_POWER >>>'
go


-- 16. IKERNEL_PT
/*
   PT参数表
 
*/
drop table IKERNEL_PT
go

CREATE TABLE IKERNEL_PT
(
    PT_CODE    varchar(6)    NOT NULL,
    PT_DESC    varchar(20)   NULL,
    PT_RATIO   varchar(20)   NULL,
    MODIFYDATE datetime      NULL,
    ISDELETE   numeric(2,0)  DEFAULT 0 NULL,
    CONSTRAINT PK_IKERNEL_PT
    PRIMARY KEY NONCLUSTERED (PT_CODE)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_PT') IS NOT NULL
    PRINT '<<< CREATED TABLE 16.IKERNEL_PT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 16.IKERNEL_PT >>>'
go


-- 17. IKERNEL_TARIFF
/*
   费率时段参数表
 
*/
drop table IKERNEL_TARIFF
go

CREATE TABLE IKERNEL_TARIFF
(
    TARIFF_ID   numeric(2,0) NOT NULL,
    TARIFF_DESC varchar(20)  NULL,
    CONSTRAINT PK_IKERNEL_TARIFF
    PRIMARY KEY NONCLUSTERED (TARIFF_ID)
) on HXPARA
go
IF OBJECT_ID('dbo.IKERNEL_TARIFF') IS NOT NULL
    PRINT '<<< CREATED TABLE 17.IKERNEL_TARIFF >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 17.IKERNEL_TARIFF >>>'
go

-- 18. IKERNEL_VOLT_GRADE
/*
   电压等级参数表
 
*/
drop table IKERNEL_VOLT_GRADE
go

CREATE TABLE IKERNEL_VOLT_GRADE
(
    VOLTGRD_ID        varchar(2)   NOT NULL,
    VOLTGRD_DESC      varchar(20)  NULL,
    VOLT_VALUE        numeric(7,2) NULL,
    VOLT_UPLMT        numeric(7,2) NULL,
    VOLT_LOWLMT       numeric(7,2) NULL,
    BUS_UNBALANCE_LMT numeric(4,1) NULL,
    HARMONIC_LIMIT    numeric(4,1) NULL,
    MODIFYDATE        datetime     NULL,
    ISDELETE          numeric(2,0) DEFAULT 0 NULL,
    CONSTRAINT PK_IKERNEL_VOLT_GRADE
    PRIMARY KEY NONCLUSTERED (VOLTGRD_ID)
) on HXPARA
go
IF OBJECT_ID('IKERNEL_VOLT_GRADE') IS NOT NULL
    PRINT '<<< CREATED TABLE 18.IKERNEL_VOLT_GRADE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 18.IKERNEL_VOLT_GRADE >>>'
go

/*
   二.动态参数相关表(10 tables)
 
*/


-- 19. IPARA_CDUREGION
/*
   CDU区域参数表
 
*/
drop table IPARA_CDUREGION
go

CREATE TABLE IPARA_CDUREGION
(
    REGION_ID  numeric(6,0)   NOT NULL,
    REGIONNAME varchar(200)   NULL,
    NOTE       varchar(1000) NULL,
    CONSTRAINT PK_IPARA_CDUREGION
    PRIMARY KEY NONCLUSTERED (REGION_ID)
) on HXPARA
go
IF OBJECT_ID('IPARA_CDUREGION') IS NOT NULL
    PRINT '<<< CREATED TABLE 19.IPARA_CDUREGION >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 19.IPARA_CDUREGION >>>'
go


-- 20. IPARA_CDUSTATION
/*
   CDU售电点表
 
*/
drop table IPARA_CDUSTATION
go

CREATE TABLE dbo.IPARA_CDUSTATION
(
    TERRITORYID    numeric(6,0)  NOT NULL,
    FATHERID       numeric(6,0)  NULL,
    TE_NAME        varchar(50)   NULL,
    TE_TYPE        numeric(2,0)  NOT NULL,
    TE_ADDRESS     varchar(250)  NULL,
    TE_CREDIT      numeric(12,4) NOT NULL,
    TE_STATE       numeric(1,0)  NOT NULL,
    TE_MAXVAL      numeric(9,0)  NOT NULL,
    TE_MINVAL      numeric(9,0)  NOT NULL,
    NEWDATE        datetime      NOT NULL,
    NEWOPERATOR    numeric(6,0)  NULL,
    TE_KEY         char(8)       NULL,
    MANAGER        numeric(6,0)  NULL,
    MODIFYDATE     datetime      NULL,
    EMERGENCYLIMIT numeric(9,0)  NULL,
    CREDITLIMIT    numeric(9,0)  NULL,
    ISDELETE       numeric(2,0)  DEFAULT 0 NULL,
    CREATOR        numeric(6,0)  NULL,
    REGIOINID      numeric(6,0)  NULL,
    CONSTRAINT PK_IPARA_CDUSTATION
    PRIMARY KEY NONCLUSTERED (TERRITORYID)
     ON HXPARA
)
ON HXPARA
go
IF OBJECT_ID('dbo.IPARA_CDUSTATION') IS NOT NULL
    PRINT '<<< CREATED TABLE 20.IPARA_CDUSTATION >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 20.IPARA_CDUSTATION >>>'
go

-- 21. IPARA_CDUSTATION_CREDITLOG
/*
   CDU充值日志表
 
*/
drop table IPARA_CDUSTATION_CREDITLOG;
go

CREATE TABLE dbo.IPARA_CDUSTATION_CREDITLOG
(
    CDUCLOGID    numeric(6,0)  NOT NULL,
    TERRITORYID  numeric(6,0)  NULL,
    CCL_EVIDENCE varchar(20)   COLLATE Chinese_PRC_CI_AS NULL,
    CCL_CASH     numeric(12,4) NOT NULL,
    CCL_TYPE     numeric(1,0)  NOT NULL,
    NEWDATE      datetime      NULL,
    NEWOPERATOR  varchar(50)   COLLATE Chinese_PRC_CI_AS NULL,
    CONSTRAINT PK_IPARA_CDUSTATION_CREDITLOG
    PRIMARY KEY NONCLUSTERED (CDUCLOGID)
     ON HXPARA
)
ON HXPARA
go
IF OBJECT_ID('dbo.IPARA_CDUSTATION_CREDITLOG') IS NOT NULL
    PRINT '<<< CREATED TABLE 21.IPARA_CDUSTATION_CREDITLOG >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 21.IPARA_CDUSTATION_CREDITLOG >>>'
go


-- 22. IPARA_CLIREG
/*
   客户端注册参数表
 
*/
drop table IPARA_CLIREG;
go

create table IPARA_CLIREG(
   M_ID                 numeric(4)     NOT NULL,
   M_CDKEY              varchar(64),
   M_HARDCODE           varchar(64),
   M_IPADD              varchar(128),
   M_CDUID              numeric(6),
   OPIDLIST             varchar(256),
   M_VATYPE             numeric(1),
   ISDELETE             numeric(1)     DEFAULT 0 NULL,
   M_REMARK             varchar(255),
   MODDATE              datetime,
   CONSTRAINT PK_IPARA_CLIREG 
   PRIMARY KEY NONCLUSTERED(M_ID)
) on HXPARA
go
IF OBJECT_ID('IPARA_CLIREG') IS NOT NULL
    PRINT '<<< CREATED TABLE 22.IPARA_CLIREG >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 22.IPARA_CLIREG >>>'
go

-- 23. IPARA_DEBT
/*
   债务参数表
 
*/
drop table IPARA_DEBT;
go

CREATE TABLE IPARA_DEBT
(
    DEBTID       numeric(16,0)  NOT NULL,
    DEBTNM       varchar(20)      NULL,
    CREATOR      varchar(20)      NULL,
    DEBT_DATE    datetime              NULL,
    CUSTOMER_ID  numeric(16,0)  NOT NULL,
    AGREE_ID     varchar(20)      NULL,
    OPERATE_DATE datetime              NULL,
    OPERATOR_ID  numeric(6,0)       NULL,
    OPTYPE       numeric(1,0)       NULL,
    AMOUNT       numeric(19,4)      NULL,
    CURENTBLC    numeric(19,4)      NULL,
    ISTAX        numeric(1,0)       NULL,
    TAXPCT       numeric(4,2)       NULL,
    INTREST      numeric(4,2)       NULL,
    DTYPE        numeric(1,0)       NULL,
    MINPAY       numeric(19,4)      NULL,
    PMONEYPCT    numeric(4,2)       NULL,
    AMOUNTPCT    numeric(4,2)       NULL,
    PENALTYPCT   numeric(4,2)       NULL,
    PAYPERIOD    numeric(4,0)       NULL,
    PAYCTS       numeric(16,0)      NULL,
    DAYS         numeric(16,0)      NULL,
    LASTDATE     datetime           NULL,
    OKFLAG       numeric(1,0)       DEFAULT 0   NULL, 
    REMARK       varchar(200)       NULL,
    CONSTRAINT   PK_IPARA_DEBT
    PRIMARY KEY  NONCLUSTERED(DEBTID)
) on HXPARA
go
IF OBJECT_ID('IPARA_DEBT') IS NOT NULL
    PRINT '<<< CREATED TABLE 23.IPARA_DEBT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 23.IPARA_DEBT >>>'
go

-- 24. IPARA_MTRPOINT
/*
   表计参数表
 
*/
drop table IPARA_MTRPOINT;
go
CREATE TABLE dbo.IPARA_MTRPOINT
(
    MTRPOINT_ID        numeric(16,0)  NOT NULL,
    MTRPOINT_DESC      varchar(80)    NULL,
    POINT_NO           numeric(4,0)   NULL,
    MT_MODEL_ID        numeric(3,0)   NULL,
    MT_ASSET_NO        varchar(20)    NULL,
    MT_COMM_ADDR       varchar(16)    NULL,
    CT_CODE            varchar(6)     NULL,
    PT_CODE            varchar(6)     NULL,
    VOLTGRD_ID         varchar(2)     NULL,
    CAPACITY           numeric(6,0)   NULL,
    TRANSLOSS_ID       varchar(20)    NULL,
    GRID_ID            numeric(6,0)   NULL,
    REGION_ID          numeric(6,0)   NULL,
    POWER_SUPPLYER     numeric(6,0)   NULL,
    LINE_ID            numeric(6,0)   NULL,
    TML_ID             numeric(6,0)   NULL,
    ACTUAL_LINE_ID     numeric(6,0)   NULL,
    SUBSTATION_ID      numeric(6,0)   NULL,
    MUS_TI             numeric(2,0)   DEFAULT 1 NULL,
    MUS_SGCID          numeric(6,0)   NULL,
    MUS_KEYVISION      numeric(2,0)   DEFAULT 1 NULL,
    MUS_KEYEXPIRY      numeric(3,0)   DEFAULT 255 NULL,
    MODIFYDATE         datetime       NULL,
    LIMIT_PF           numeric(4,3)   DEFAULT 0.9 NULL,
    LASTVENDDATE       datetime       NULL,
    LASTVENDFREEDATE   datetime       DEFAULT getdate() NULL,
    CUR_MONTH_UNITS    numeric(12,4)  DEFAULT 0 NULL,
    CUR_MONTH_MONEY    numeric(12,4)  DEFAULT 0 NULL,
    TARIFFINDEXID      numeric(2,0)   DEFAULT 1 NULL,
    TARIFFGROUPIDS     numeric(10,0)  DEFAULT 1 NULL,
    ACTUAL_CUSTOMER_ID numeric(16,0)  NULL,
    CUSTOMER_ID        numeric(16,0)  NULL,
    LAT                numeric(20,17) DEFAULT 0 NULL,
    LNG                numeric(20,17) DEFAULT 0 NULL,
    CONSTRAINT PK_IPARA_MTRPOINT
    PRIMARY KEY NONCLUSTERED (MTRPOINT_ID)
     ON HXPARA
)
ON HXPARA
go

IF OBJECT_ID('dbo.IPARA_MTRPOINT') IS NOT NULL
    PRINT '<<< CREATED TABLE 24.IPARA_MTRPOINT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 24.IPARA_MTRPOINT >>>'
go

PRINT '<<< CREATE 24.IPARA_MTRPOINT INDEX IND_IPARA_MTRPOINT >>>'
CREATE INDEX IND_IPARA_MTRPOINT
    ON IPARA_MTRPOINT(MT_COMM_ADDR) ON [HXPARA]
go

PRINT '<<< CREATE 24.IPARA_MTRPOINT INDEX IND_IPARA_MTRPOINT >>>'
CREATE NONCLUSTERED INDEX IND2_IPARA_MTRPOINT
    ON IPARA_MTRPOINT(ACTUAL_CUSTOMER_ID) ON [HXPARA]
go

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.IPARA_MTRPOINT') AND name='IND2_IPARA_MTRPOINT')
    PRINT '<<< CREATED INDEX dbo.IPARA_MTRPOINT.IND2_IPARA_MTRPOINT >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.IPARA_MTRPOINT.IND2_IPARA_MTRPOINT >>>'
go



-- 25. IPARA_MTRSTATUS
/*
   表计状态表
 
*/
drop table IPARA_MTRSTATUS;
go

CREATE TABLE IPARA_MTRSTATUS
(
    MTRPOINT_ID numeric(16,0)  NOT NULL,
    STATUS_ID   numeric(3,0)   NOT NULL,
    MODIFY_DATE datetime       NULL,
    OPEARTOR_ID numeric(6,0)   NULL,
    REMARK      varchar(100)   NULL,
    CONSTRAINT  PK_IPARA_MTRSTATUS
    PRIMARY KEY NONCLUSTERED (MTRPOINT_ID),
    CONSTRAINT  FK_IPARA_MTRSTATUS_1
    FOREIGN KEY (OPEARTOR_ID) REFERENCES IAUDIT_USER(USER_ID)
)  on HXPARA
go
IF OBJECT_ID('IPARA_MTRSTATUS') IS NOT NULL
    PRINT '<<< CREATED TABLE 25.IPARA_MTRSTATUS >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 25.IPARA_MTRSTATUS >>>'
go


-- 26. IPARA_OBJECT
/*
  对象参数表 
 
*/
drop table IPARA_OBJECT
go

CREATE TABLE IPARA_OBJECT
(
    OBJECT_ID        numeric(6,0) NOT NULL,
    OBJECT_NAME      varchar(50)     NULL,
    STATUS           numeric(2,0) NULL,
    OBJECT_TYPE      numeric(2,0) NULL,
    VOLTGRD_ID       varchar(2)   NULL,
    OBJECT_CODE      varchar(20)  NULL,
    GRID_ID          numeric(6,0) NULL,
    REGION_ID        numeric(6,0) NULL,
    POWER_SUPPLYER   numeric(6,0) NULL,
    LINE_ID          numeric(6,0) NULL,
    CALC_FLAG_MINUTE numeric(2,0) NULL,
    CALC_FLAG_HOUR   numeric(2,0) NULL,
    CALC_FLAG_DAY    numeric(2,0) NULL,
    CALC_FLAG_MONTH  numeric(2,0) NULL,
    MULTI_PERIOD     numeric(2,0) NULL,
    LINELOSS_LMT     numeric(2,0) NULL,
    VOLT_RATIO       numeric(2,0) NULL,
    SUBSTATION_ID    numeric(6,0) NULL,
    MAIN_TRANS_ID    numeric(6,0) NULL,
    BUS_ID           numeric(6,0) NULL,
    CONNECT_LINE_ID  numeric(6,0) NULL,
    PUB_TRANS_ID     numeric(6,0) NULL,
    SGCID            numeric(6,0) NULL,
    TARIFFGROUPID    numeric(2,0) NULL,
    MODIFYDATE       datetime     NULL,
    ISDELETE         numeric(2,0) DEFAULT 0 NULL,
    CONSTRAINT PK_IPARA_OBJECT
    PRIMARY KEY NONCLUSTERED (OBJECT_ID)
) on HXPARA
go
IF OBJECT_ID('IPARA_OBJECT') IS NOT NULL
    PRINT '<<< CREATED TABLE 26.IPARA_OBJECT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 26.IPARA_OBJECT >>>'
go

-- 27. IPARA_RESIDENT
/*
  客户表 
 
*/
drop table IPARA_RESIDENT
go

CREATE TABLE IPARA_RESIDENT
(
    CUSTOMER_ID      numeric(16,0)    NOT NULL,
    CUSTOMER_NAME    varchar(100)     NULL,
    STATUS           numeric(2,0)     NULL,
    OPENACCOUNT_DATE DATE             NULL,
    PASSWORD         varchar(20)      NULL,
    ADDRESS          varchar(500)     NULL,
    LINKMAN          varchar(100)     NULL,
    LINKMAN_PHONE    CHAR(30)         NULL,
    OBJECT_CODE      varchar(20)      NULL,
    GRID_ID          numeric(6,0)     NULL,
    REGION_ID        numeric(6,0)     NULL,
    POWER_SUPPLYER   numeric(6,0)     NULL,
    LINE_ID          numeric(6,0)     NULL,
    US_TI            numeric(2,0)     NULL,
    US_MANAGESTATE   varchar(16)      NULL,
    US_IDNUM         varchar(20)      NULL,
    US_EMAIL         varchar(100)     NULL,
    US_ZIP           varchar(10)      NULL,
    US_SEX           numeric(1,0)     NULL,
    BANKACCOUNT      varchar(20)      NULL,
    POWERLIMIT       numeric(6,0)     NULL,
    CREDITLINE       numeric(6,0)   DEFAULT null  NULL,
    OVERDRAFT        numeric(8,2)   DEFAULT 0     NULL,
    TOTALENERGY      numeric(10,2)  DEFAULT 0     NULL,
    TOTALMONEY       numeric(10,2)  DEFAULT 0     NULL,
    TOTALTAXES       numeric(10,2)  DEFAULT 0     NULL,
    TOTALTIMES       numeric(6,0)   DEFAULT 0     NULL,
    TIMES            numeric(6,0)   DEFAULT 0     NULL,
    LASTDATE         datetime         NULL,
    MODIFYDATE       datetime         NULL,
    ISDELETE         numeric(2,0)   DEFAULT 0     NULL,
    CONSTRAINT PK_IPARA_RESIDENT
    PRIMARY KEY NONCLUSTERED (CUSTOMER_ID)
    
) on HXPARA
go
IF OBJECT_ID('IPARA_RESIDENT') IS NOT NULL
    PRINT '<<< CREATED TABLE 27.IPARA_RESIDENT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 27.IPARA_RESIDENT >>>'
go

-- 28. IPARA_SGC_SECURITY
/*
  SGC KE安全表 
 
*/
drop table IPARA_SGC_SECURITY
go

CREATE TABLE IPARA_SGC_SECURITY
(
    SECURITY_ID   numeric(2,0) NOT NULL,
    KEYVERSIONID  numeric(2,0) NOT NULL,
    SGCID         numeric(6,0) NOT NULL,
    SE_EXPIRYDATE datetime     NOT NULL,
    SE_EXPIRY     numeric(3,0) NOT NULL,
    SE_KMF        char(100)    NULL,
    SE_STATE      numeric(2,0) NOT NULL,
    NEWDATE       datetime     NOT NULL,
    NEWOPERATOR   numeric(6,0) NOT NULL,
    ENDDATE       datetime     NULL,
    ENDOPERATOR   numeric(6,0) NULL,
    CONSTRAINT PK_IPARA_SGC_SECURITY
    PRIMARY KEY NONCLUSTERED (SECURITY_ID)
) on HXPARA
go
IF OBJECT_ID('IPARA_SGC_SECURITY') IS NOT NULL
    PRINT '<<< CREATED TABLE 28.IPARA_SGC_SECURITY >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 28.IPARA_SGC_SECURITY >>>'
go

/*
   三.日志相关表( 4 tables)
 
*/

-- 29. LOG_DEBT
/*
  债务修改增加日志表
 
*/
drop table LOG_DEBT
go

CREATE TABLE LOG_DEBT
(
    LOG_DEBTID   numeric(16,0)       NOT NULL,
    DEBTID       numeric(16,0)       NOT NULL,
    DEBTNM       varchar(20)         NULL,
    CREATOR      varchar(20)         NULL,
    DEBT_DATE    varchar(4000)       NULL,
    CUSTOMER_ID  numeric(16,0)       NOT NULL,
    AGREE_ID     varchar(20)         NULL,
    OPERATE_DATE datetime            NOT NULL,
    OPERATOR_ID  numeric(6,0)        NULL,
    OPTYPE       numeric(1,0)        NULL,
    AMOUNT       numeric(19,4)       NULL,
    CURENTBLC    numeric(19,4)       NULL,
    ISTAX        numeric(1,0)        NULL,
    TAXPCT       numeric(4,2)        NULL,
    INTREST      numeric(4,2)        NULL,
    DTYPE        numeric(1,0)        NULL,
    MINPAY       numeric(19,4)       NULL,
    PMONEYPCT    numeric(4,2)        NULL,
    AMOUNTPCT    numeric(4,2)        NULL,
    PENALTYPCT   numeric(4,2)        NULL,
    PAYPERIOD    numeric(4,0)        NULL,
    PAYCTS       numeric(16,0)       NULL,
    DAYS         numeric(16,0)       NULL,
    LASTDATE     datetime            NULL,
    OKFLAG       numeric(1,0)        NULL,
    REMARK       varchar(200)        NULL,
    CONSTRAINT PK_LOG_DEBT
    PRIMARY KEY NONCLUSTERED (LOG_DEBTID)
 ) on HXPARA
go
IF OBJECT_ID('LOG_DEBT') IS NOT NULL
    PRINT '<<< CREATED TABLE 29.LOG_DEBT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 29.LOG_DEBT >>>'
go

-- 30. LOG_MTRSTATUS
/*
  表计状态记录日志表 --数据量大可考虑建 MTRPOINT_ID,MODIFY_DATE 索引
 
*/
drop table LOG_MTRSTATUS
go
CREATE TABLE LOG_MTRSTATUS
(
    ID          numeric(16,0)  NOT NULL,
    MTRPOINT_ID numeric(16,0)  NOT NULL,
    STATUS_ID   numeric(3,0)   NOT NULL,
    MODIFY_DATE datetime           NULL,
    OPEARTOR_ID numeric(6,0)       NULL,
    REMARK      varchar(100)       NULL,
    CONSTRAINT PK_LOG_MTRSTATUS
    PRIMARY KEY NONCLUSTERED (ID)
) on HXPARA
go
IF OBJECT_ID('LOG_DEBT') IS NOT NULL
    PRINT '<<< CREATED TABLE 30.LOG_MTRSTATUS >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 30.LOG_MTRSTATUS >>>'
go

-- 31. LOG_OPERATOR
/*
  操作日志表
 
*/
drop table LOG_OPERATOR
go

CREATE TABLE LOG_OPERATOR
(
    OPERATORLOGID numeric(6,0)      NOT NULL,
    OPERATORID    CHAR(20)          NULL,
    WORKTYPEID    numeric(2,0)      NULL,
    OL_REMARKS    varchar(200)      NULL,
    OL_INDATE     datetime          NOT NULL,
    CONSTRAINT PK_LOG_OPERATOR
    PRIMARY KEY NONCLUSTERED (OPERATORLOGID)
) on HXPARA
go
IF OBJECT_ID('LOG_OPERATOR') IS NOT NULL
    PRINT '<<< CREATED TABLE 31.LOG_OPERATOR >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 31.LOG_OPERATOR >>>'
go

-- 32. LOG_USERLOGIN_OUT
/*
  用户登录登出日志表
 
*/
drop table LOG_USERLOGIN_OUT
go

CREATE TABLE LOG_USERLOGIN_OUT
(
    USER_ID  numeric(6,0)     NULL,
    OPERTIME datetime         NULL,
    OPERTYPE numeric(1,0)     NULL,
    IP       varchar(100)     NULL,
    MAC      varchar(100)     NULL,
    CONSTRAINT  FK_LOG_USERLOGIN_OUT_1
    FOREIGN KEY (USER_ID) REFERENCES IAUDIT_USER(USER_ID)
) on HXPARA
go
IF OBJECT_ID('LOG_USERLOGIN_OUT') IS NOT NULL
    PRINT '<<< CREATED TABLE 32.LOG_USERLOGIN_OUT >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 32.LOG_USERLOGIN_OUT >>>'
go

/*
   四.业务订单相关表-建立在不同文件组上( 6 tables)
 
*/

-- 33. ORDER_BANKING
/*
  BANK 表
 
*/
drop table ORDER_BANKING
go

CREATE TABLE ORDER_BANKING
(
    BANKINGNO  numeric(20,0)  NOT NULL,
    BATCHNO    numeric(20,0)  NOT NULL,
    STARTTIME  datetime       NOT NULL,
    ENDTIME    datetime       NULL,
    OPERATORID numeric(6,0)   NOT NULL,
    CDUID      numeric(6,0)   NOT NULL,
    M_ID       numeric(4,0)   NOT NULL,
    CONSTRAINT PK_ORDER_BANKING
    PRIMARY KEY NONCLUSTERED (BANKINGNO,BATCHNO,STARTTIME)
    
) on HXDATA
go
IF OBJECT_ID('ORDER_BANKING') IS NOT NULL
    PRINT '<<< CREATED TABLE 33.ORDER_BANKING >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 33.ORDER_BANKING >>>'
go

-- 34. ORDER_DEBTS
/*
  债务订单表
 
*/
drop table ORDER_DEBTS
go

CREATE TABLE ORDER_DEBTS
(
    ORDERSID    numeric(18,0) NOT NULL,
    DEBTID      numeric(16,0) NOT NULL,
    METERID     numeric(16,0)     NULL,
    USER_ID     numeric(16,0) NOT NULL,
    DE_AMOUNT   numeric(19,4) NOT NULL,
    DE_BANLANCE numeric(19,4)     NULL,
    DE_DATE     date              NULL,
    CONSTRAINT PK_ORDER_DEBTS
    PRIMARY KEY NONCLUSTERED (ORDERSID,DEBTID)
) on HXDATA
go
IF OBJECT_ID('ORDER_DEBTS') IS NOT NULL
    PRINT '<<< CREATED TABLE 34.ORDER_DEBTS >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 34.ORDER_DEBTS >>>'
go

-- 35. ORDER_MANAGE
/*
  管理订单表
 
*/
drop table ORDER_MANAGE
go

CREATE TABLE ORDER_MANAGE
(
    METERID          numeric(16,0) NOT NULL,
    ORDERSID         numeric(18,0)     NULL,
    MANAGEID         numeric(18,0) NOT NULL,
    TOKEN_TYPE       numeric(3,0)      NULL,
    USER_ID          numeric(16,0)     NULL,
    MAN_VALUE1       numeric(10,2)     NULL,
    MAN_VALUE2       numeric(10,2)     NULL,
    SGCID            numeric(6,0)      NULL,
    TI               numeric(2,0)      NULL,
    KEYVERSIONID     numeric(2,0)      NULL,
    KEYEXPIRY        numeric(3,0)      NULL,
    MAN_TOKEN1       varchar(20)   NOT NULL,
    MAN_TOKEN2       varchar(20)       NULL, 
    OPERATORID       numeric(6,0)      NULL,
    MAN_DATE         datetime          NULL,
    SGCID_OLD        numeric(6,0)      NULL,
    TI_OLD           numeric(2,0)      NULL,
    KEYVERSIONID_OLD numeric(2,0)      NULL,
    KEYEXPIRY_OLD    numeric(3,0)      NULL,
    BACK_MONEY       numeric(19,4)     NULL,
    BACK_UNITS       numeric(19,4)     NULL,
    BACK_DATE        datetime          NULL,
    DELFLAG          numeric(1,0)     DEFAULT 0  NULL,
    CONSTRAINT PK_ORDER_MANAGE
    PRIMARY KEY NONCLUSTERED (MANAGEID)
) on HXDATA
go
IF OBJECT_ID('ORDER_MANAGE') IS NOT NULL
    PRINT '<<< CREATED TABLE 35.ORDER_MANAGE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 35.ORDER_MANAGE >>>'
go

PRINT '<<< CREATE 35.ORDER_MANAGE INDEX IND_MANAGEMENTTOKEN >>>'
CREATE INDEX IND_MANAGEMENTTOKEN
    ON ORDER_MANAGE(METERID,TOKEN_TYPE,MAN_DATE)
go

PRINT '<<< CREATE 35.ORDER_MANAGE INDEX IND_MANAGEMENTTOKEN2 >>>'
CREATE INDEX IND_MANAGEMENTTOKEN2
    ON ORDER_MANAGE(ORDERSID)
go

-- 36. ORDER_REISSUE
/*
  订单重新发行表
 
*/
drop table ORDER_REISSUE
go

CREATE TABLE ORDER_REISSUE
(
    ORDERSID   numeric(18,0)     NOT NULL,
    OPERATORID numeric(6,0)      NOT NULL,
    OD_DATE    datetime          NOT NULL,
    METERID    numeric(16,0)     NULL,
    USER_ID    numeric(16,0)     NULL,
    CONSTRAINT PK_ORDER_REISSUE
    PRIMARY KEY NONCLUSTERED (ORDERSID,OD_DATE)
) on HXDATA
go
IF OBJECT_ID('ORDER_REISSUE') IS NOT NULL
    PRINT '<<< CREATED TABLE 36.ORDER_REISSUE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 36.ORDER_REISSUE >>>'
go

-- 37. ORDER_REISSUE
/*
  订单重新发行表
 
*/
drop table ORDER_REVERSED
go

CREATE TABLE ORDER_REVERSED
(
    ORDERSID   numeric(18,0) NOT NULL,
    OPERATORID numeric(6,0)      NULL,
    OD_DATE    datetime          NULL,
    METERID    numeric(16,0)     NULL,
    USER_ID    numeric(16,0)     NULL,
    MONEY_BACK numeric(19,4)     NULL,
    CONSTRAINT PK_ORDER_REVERSED
    PRIMARY KEY NONCLUSTERED (ORDERSID)
) on HXDATA
go
IF OBJECT_ID('ORDER_REVERSED') IS NOT NULL
    PRINT '<<< CREATED TABLE 37.ORDER_REVERSED >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 37.ORDER_REVERSED >>>'
go

-- 38. ORDER_TRN
/*
  核心订单表
 
*/
-- delete a partition function

-- Creates a partition function called MonthRange that will partition a table into partitions

alter table ORDER_TRN
drop constraint PK_ORDER_TRN
go

DROP INDEX ORDER_TRN.IND_ORDER_TRN
go


drop table ORDER_TRN
go

drop PARTITION SCHEME ps_OrderDate
go


set dateformat ymd
go

drop PARTITION FUNCTION pf_OrderDate
go


-- 2013.3.1 - 2020.12.31 共94个分区,95个HXDATA

CREATE PARTITION FUNCTION pf_OrderDate (datetime)
    AS RANGE RIGHT FOR VALUES ('2013/03/01', '2013/04/01','2013/05/01','2013/06/01','2013/07/01','2013/08/01','2013/09/01','2013/10/01','2013/11/01','2013/12/01','2014/01/01', '2014/02/01','2014/03/01','2014/04/01','2014/05/01','2014/06/01','2014/07/01','2014/08/01','2014/09/01','2014/10/01','2014/11/01','2014/12/01','2015/01/01', '2015/02/01','2015/03/01','2015/04/01','2015/05/01','2015/06/01','2015/07/01','2015/08/01','2015/09/01','2015/10/01','2015/11/01','2015/12/01','2016/01/01', '2016/02/01','2016/03/01','2016/04/01','2016/05/01','2016/06/01','2016/07/01','2016/08/01','2016/09/01','2016/10/01','2016/11/01','2016/12/01','2017/01/01', '2017/02/01','2017/03/01','2017/04/01','2017/05/01','2017/06/01','2017/07/01','2017/08/01','2017/09/01','2017/10/01','2017/11/01','2017/12/01','2018/01/01', '2018/02/01','2018/03/01','2018/04/01','2018/05/01','2018/06/01','2018/07/01','2018/08/01','2018/09/01','2018/10/01','2018/11/01','2018/12/01','2019/01/01', '2019/02/01','2019/03/01','2019/04/01','2019/05/01','2019/06/01','2019/07/01','2019/08/01','2019/09/01','2019/10/01','2019/11/01','2019/12/01','2020/01/01', '2020/02/01','2020/03/01','2020/04/01','2020/05/01','2020/06/01','2020/07/01','2020/08/01','2020/09/01','2020/10/01','2020/11/01','2020/12/01') 
GO

CREATE PARTITION SCHEME ps_OrderDate
    AS  PARTITION  pf_OrderDate to (HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA,HXDATA) 
go

CREATE TABLE ORDER_TRN
(
    METERID       numeric(16,0)     NULL,
    OD_DATE       datetime          NOT NULL,
    ORDERSID      numeric(18,0)     NOT NULL,
    ISFREE        numeric(1,0)      NULL,
    USER_ID       numeric(16,0)     NULL,
    SGCID         numeric(6,0)      NULL,
    TI            numeric(2,0)      NULL,
    TG            numeric(6,0)      NULL,
    KEYVERSIONID  numeric(2,0)      NULL,
    KEYEXPIRY     numeric(3,0)      NULL,
    OCD_TOKEN     varchar(20)       NULL,
    OCD_ENERGY    numeric(12,4)     NULL,
    OCD_MONEY     numeric(12,4)     NULL,
    OCD_MONEY1    numeric(12,4)     NULL,
    OCD_MONEY2    numeric(12,4)     NULL,
    OCD_MONEY3    numeric(12,4)     NULL,
    OCD_MONEY4    numeric(12,4)     NULL,
    OCD_MONEY5    numeric(12,4)     NULL,
    PAYTYPE       numeric(1,0)      NULL,
    OCD_TAXES     numeric(12,4)     NULL,
    FI1           numeric(6,0)      NULL,
    FEEPARTID     numeric(6,0)      NULL,
    FEEMETHODID   numeric(3,0)      NULL,
    FP_VAL        numeric(12,4)     NULL,
    FI2           numeric(6,0)      NULL,
    FEEPARTID2    numeric(6,0)      NULL,
    FEEMETHODID2  numeric(3,0)      NULL,
    FP_VAL2       numeric(12,4)     NULL,
    FI3           numeric(6,0)      NULL,
    FEEPARTID3    numeric(6,0)      NULL,
    FEEMETHODID3  numeric(3,0)      NULL,
    FP_VAL3       numeric(12,4)     NULL,
    OCD_DEBT      numeric(12,4)     NULL,
    DEBT_BLC      numeric(12,4)     NULL,
    OCD_PAYALL    numeric(12,4)     NULL,
    OCD_PAYMONEY  numeric(12,4)     NULL,
    OCD_CHANGE    numeric(12,4)     NULL,
    OPERATORID    numeric(6,0)      NULL,
    OCD_MACHINEID numeric(4,0)      NULL,
    CDUID         numeric(6,0)      NULL,
    SMSID         numeric(6,0)      NULL,
    REGIONID      numeric(6,0)      NULL,
    OCD_FIXED     numeric(12,4)     NULL,
    OCD_FINED     numeric(12,4)     NULL,
    DELFLAG       numeric(1,0)      DEFAULT 0  NULL,
    FI4           numeric(6,0)  NULL,
    FEEPARTID4    numeric(6,0)  NULL,
    FEEMETHODID4  numeric(3,0)  NULL,
    FP_VAL4       numeric(12,4) NULL,
    FI5           numeric(6,0)  NULL,
    FEEPARTID5    numeric(6,0)  NULL,
    FEEMETHODID5  numeric(3,0)  NULL,
    FP_VAL5       numeric(12,4) NULL,
) on ps_OrderDate(OD_DATE)

IF OBJECT_ID('ORDER_TRN') IS NOT NULL
    PRINT '<<< CREATED TABLE 38.ORDER_TRN >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 38.ORDER_TRN >>>'
go

CREATE NONCLUSTERED INDEX IND_ORDER_TRN
    ON dbo.ORDER_TRN(OD_DATE,METERID)
  WITH (
        PAD_INDEX = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON
       )
    ON ps_OrderDate(OD_DATE)
go

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.ORDER_TRN') AND name='IND_ORDER_TRN')
    PRINT '<<< CREATED INDEX dbo.ORDER_TRN.IND_ORDER_TRN >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ORDER_TRN.IND_ORDER_TRN >>>'
go


alter table ORDER_TRN
add constraint PK_ORDER_TRN primary key NONCLUSTERED (ordersid) on hxdata
go


/*
   五.费率相关表( 5 tables)
 
*/


-- 39. TARIFF_FEEINDEX
/*
   TAX表
 
*/
drop table TARIFF_FEEINDEX
go

CREATE TABLE TARIFF_FEEINDEX
(
    FI         numeric(10,0)  NOT NULL,
    FI_NAME    varchar(50)    NOT NULL,
    FI_STATE   numeric(1,0)   NOT NULL,
    FI_REMARK  varchar(250)   NULL,
    MODIFYDATE datetime       NULL,
    ISDELETE   numeric(1,0)   DEFAULT 0     NULL,
    CONSTRAINT  PK_TARIFF_FEEINDEX
    PRIMARY KEY NONCLUSTERED (FI)
) on HXPARA
go
IF OBJECT_ID('TARIFF_FEEINDEX') IS NOT NULL
    PRINT '<<< CREATED TABLE 39.TARIFF_FEEINDEX >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 39.TARIFF_FEEINDEX >>>'
go

-- 40. TARIFF_FEEPART
/*
  税费表
 
*/
drop table TARIFF_FEEPART
go

CREATE TABLE TARIFF_FEEPART
(
    FEEPARTID   numeric(6,0)   NOT NULL,
    FP_NAME     varchar(50)    NOT NULL,
    FP_REMARKS  varchar(250)   NULL,
    FP_STATE    numeric(3,0)   NOT NULL,
    FEEMETHODID numeric(3,0)   NOT NULL,
    FP_VAL      numeric(10,5)  NOT NULL,
    FI          numeric(10,0)  NOT NULL,
    MODIFYDATE  datetime       NULL,
    ISDELETE    numeric(1,0)   DEFAULT 0     NULL,
    CONSTRAINT  PK_TARIFF_FEEPART
    PRIMARY KEY NONCLUSTERED (FEEMETHODID,FI)
) on HXPARA
go
IF OBJECT_ID('TARIFF_FEEPART') IS NOT NULL
    PRINT '<<< CREATED TABLE 40.TARIFF_FEEPART >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 40.TARIFF_FEEPART >>>'
go


-- 41. TARIFF_GROUP
/*
  费率组
 
*/
drop table TARIFF_GROUP
go

CREATE TABLE TARIFF_GROUP
(
    TARIFFGROUPID numeric(6,0)  NOT NULL,
    TG_NAME       varchar(50)   NOT NULL,
    TG_STATE      numeric(1,0)  NOT NULL,
    TG_MAXSTEPS   numeric(1,0)  NOT NULL,
    TG_LIMIT      numeric(4,0)  NOT NULL,
    TG_TIMES      numeric(4,0)  NOT NULL,
    MODIFYDATE    datetime      NULL,
    ISDELETE      numeric(1,0)  DEFAULT 0     NULL,
    CONSTRAINT  PK_TARIFF_GROUP
    PRIMARY KEY NONCLUSTERED (TARIFFGROUPID)
) on HXPARA
go
IF OBJECT_ID('TARIFF_GROUP') IS NOT NULL
    PRINT '<<< CREATED TABLE 41.TARIFF_GROUP >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 41.TARIFF_GROUP >>>'
go

-- 42. TARIFF_INDEX
/*
  费率索引
 
*/
drop table TARIFF_INDEX
go

CREATE TABLE TARIFF_INDEX
(
    TI            numeric(2,0)  NOT NULL,
    TARIFFGROUPID numeric(6,0)  NOT NULL,
    PROFILEID     numeric(6,0)      NULL,
    TI_NAME       varchar(50)       NULL,
    TI_STATE      numeric(1,0)  NOT NULL,
    FI            numeric(10,0) NOT NULL,
    TI_CUSTOMER   numeric(1,0)  NOT NULL,
    TI_FREECHARGE numeric(6,0)      NULL,
    MODIFYDATE    datetime          NULL,
    ISDELETE      numeric(1,0)  DEFAULT 0     NULL,
    CONSTRAINT  PK_TARIFF_INDEX
    PRIMARY KEY NONCLUSTERED (TI,TARIFFGROUPID)
    
) on HXPARA
go
IF OBJECT_ID('TARIFF_INDEX') IS NOT NULL
    PRINT '<<< CREATED TABLE 42.TARIFF_INDEX >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 42.TARIFF_INDEX >>>'
go

-- 43. TARIFF_TABLE
/*
  费率价格表
 
*/
drop table TARIFF_TABLE
go

CREATE TABLE TARIFF_TABLE
(
    TARIFFVERSIONID   numeric(2,0)   NOT NULL,
    TARIFFGROUPID     numeric(6,0)   NOT NULL,
    TI                numeric(2,0)   NOT NULL,
    TAR_EFFECTIVEDATE datetime       NOT NULL,
    TAR_TRTYPE        numeric(1,0)   NOT NULL,
    TAR_STATE         numeric(1,0)   NOT NULL,
    TAR_MONTHSVAL     numeric(2,0)   NOT NULL,
    TOU_STEP          varchar(80)      NULL,
    TOU_PRICE         varchar(200)     NULL,
    TOU_AMOUNTPRICE   varchar(2)       NULL,
    TOU_AMOUNTSTEP    varchar(2)       NULL,
    MODIFYDATE        datetime         NULL,
    ISDELETE          numeric(1,0)   DEFAULT 0     NULL,
    CONSTRAINT  PK_TARIFF_TABLE
    PRIMARY KEY NONCLUSTERED (TARIFFVERSIONID,TI,TARIFFGROUPID)
) on HXPARA
go
IF OBJECT_ID('TARIFF_TABLE') IS NOT NULL
    PRINT '<<< CREATED TABLE 43.TARIFF_TABLE >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 43.TARIFF_TABLE >>>'
go


/*
   五.其它表( 1 tables)

*/

-- 44. SYS_IDENTITY
/*
  系统ID增长表
 
*/

drop table SYS_IDENTITY
go

CREATE TABLE SYS_IDENTITY
(
    IDENTITYNAME       varchar(50)  NOT NULL,
    IDENTITYVALUE      numeric(20,0)    DEFAULT 0     NULL,
    CONSTRAINT  PK_SYS_IDENTITY
    PRIMARY KEY NONCLUSTERED (IDENTITYNAME)
) on HXPARA
go
IF OBJECT_ID('SYS_IDENTITY') IS NOT NULL
    PRINT '<<< CREATED TABLE 44.SYS_IDENTITY >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE 44.SYS_IDENTITY >>>'
go

PRINT '<<< CREATE PROCEDURE  >>>'


/****** Object:  StoredProcedure [dbo].[sp_show_tablerows]    Script Date: 03/17/2013 11:44:53 ******/

drop procedure sp_show_tablerows
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[sp_show_tablerows]
as
begin
 set nocount on

declare @tbname varchar(50) 
declare tbroy cursor for select name from sysobjects where xtype= 'u' --第一个游标遍历所有的表 
open tbroy 
fetch next from tbroy into @tbname 
while @@fetch_status=0 
begin 
declare @sql nvarchar(1000)
--select @sql='select '+@tbname
select @sql='select count(*) as '+@tbname+' from '+@tbname
--print @tbname
begin try
exec sp_executesql @sql
end try
begin catch
end catch
fetch next from tbroy into @tbname 
end
close tbroy
deallocate tbroy

end
GO
/****** Object:  StoredProcedure [dbo].[sp_show_partition_range]    Script Date: 03/17/2013 11:44:53 ******/
drop procedure sp_show_partition_range
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[sp_show_partition_range]
(
   @partition_table    nvarchar(255) = null
  ,@partition_function nvarchar(255) = null
)
as
begin
   set nocount on

   declare @function_id int
       set @function_id = null

   -- get @function_id base on @partition_table
   if len(@partition_table) > 0 begin
      select @function_id = s.function_id
        from sys.indexes i
                inner join sys.partition_schemes s
          on i.data_space_id = s.data_space_id
       where i.index_id < 2
         and i.object_id = object_id(@partition_table)
         
      if @function_id is null
         return 1         
   end

   -- get @function_id base on @partition_function
   if len(@partition_function) > 0 begin
      select @function_id = function_id
        from sys.partition_functions
       where name = @partition_function
       
      if @function_id is null
         return 1        
    end
   

   -- get partition range
   -- select partition_function = f.name
   select 
          t.partition
         ,cast(t.minval as date )
         ,value = case when f.boundary_value_on_right=1 then '<= val <' else '< val <=' end
         ,cast(t.maxval as date)
     from (
           select h.function_id
                 ,partition = h.boundary_id
                 ,minval    = l.value
                 ,maxval    = h.value
             from sys.partition_range_values h
                     left join sys.partition_range_values l
               on h.function_id = l.function_id and h.boundary_id = l.boundary_id + 1

           union all

           select function_id
                 ,partition = max(boundary_id) + 1
                 ,minval    = max(value)
                 ,maxval    = null
             from sys.partition_range_values
            group by function_id
          ) t
              inner join sys.partition_functions f
         on t.function_id = f.function_id
      where f.function_id = @function_id
         or @function_id is null
      order by 1, 2
end
GO
/****** Object:  StoredProcedure [dbo].[P_QuerySplit]    Script Date: 03/17/2013 11:44:53 ******/
drop procedure P_QuerySplit
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[P_QuerySplit] 
@sqlscript nvarchar(4000), --查询字符串 
@pageIndex int, --第N页 
@pagesize int, --每页行数 
@totalpage int output,
@totalcount int output
as 
set nocount on 
declare @P1 int, --P1是游标的id 
@rowcount int 
exec sp_cursoropen @P1 output,@sqlscript,@scrollopt=1,@ccopt=1,@rowcount=@rowcount output
 set @totalpage=ceiling(1.0*@rowcount/@pagesize)
 set @totalcount=@rowcount
 set @pageIndex=(@pageIndex-1)*@pagesize+1 
exec sp_cursorfetch @P1,16,@pageIndex,@pagesize 
exec sp_cursorclose @P1 
set nocount off

go

