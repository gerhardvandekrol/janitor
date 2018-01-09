DECLARE @CustomerDescription nvarchar(max)
DECLARE @CustomeID nvarchar(max)
DECLARE @OrderDescription nvarchar(max)
DECLARE @OrderProjectLead nvarchar(max)
DECLARE @SoftwarePakket nvarchar(max)
DECLARE @OrderHours nvarchar(max)
DECLARE @OrderProjectLeadEmail nvarchar(max)

select @CustomerDescription=CusDescr from dba.customer
join dba._order on _OrdCusId=cusid
where _OrdId='015258'

select @CustomeID=CusId from dba.customer
join dba._order on _OrdCusId=cusid
where _OrdId='015258'

select @OrderDescription=_OrdDescr from dba._order
where _Ordid='015258'

select @OrderProjectLead=EmpDescr from dba._order
Join dba.Employee on _ordempid=EmpId
where _Ordid='015258'

select @SoftwarePakket=_CusSofteId from dba.customer
join dba._order on _OrdCusId=cusid
where _OrdId='015258'

select @OrderHours=_OrdAgrHours from dba._order
where _Ordid='015258'

select @OrderProjectLeadEmail=EmpEmailAddress from dba._order
Join dba.Employee on _ordempid=EmpId
where _Ordid='015258'

PRINT @CustomerDescription
PRINT @CustomeID
PRINT @OrderDescription
PRINT @OrderProjectLead
PRINT @SoftwarePakket
PRINT @OrderHours
PRINT @OrderProjectLeadEmail