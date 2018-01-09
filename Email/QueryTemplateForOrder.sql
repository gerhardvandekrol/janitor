DECLARE @CustomerDescription nvarchar(max)
DECLARE @CustomeID nvarchar(max)
DECLARE @OrderDescription nvarchar(max)
DECLARE @OrderProjectLead nvarchar(max)
DECLARE @SoftwarePakket nvarchar(max)
DECLARE @OrderHours nvarchar(max)
DECLARE @OrderProjectLeadEmail nvarchar(max)

select @CustomerDescription=CusDescr from dba.customer
join dba._order on _OrdCusId=cusid
where _OrdId='OrderNumber'

select @CustomeID=CusId from dba.customer
join dba._order on _OrdCusId=cusid
where _OrdId='OrderNumber'

select @OrderDescription=_OrdDescr from dba._order
where _Ordid='OrderNumber'

select @OrderProjectLead=EmpDescr from dba._order
Join dba.Employee on _ordempid=EmpId
where _Ordid='OrderNumber'

select @SoftwarePakket=_CusSofteId from dba.customer
join dba._order on _OrdCusId=cusid
where _OrdId='OrderNumber'

select @OrderHours=_OrdAgrHours from dba._order
where _Ordid='OrderNumber'

select @OrderProjectLeadEmail=EmpEmailAddress from dba._order
Join dba.Employee on _ordempid=EmpId
where _Ordid='OrderNumber'

PRINT @CustomerDescription
PRINT @CustomeID
PRINT @OrderDescription
PRINT @OrderProjectLead
PRINT @SoftwarePakket
PRINT @OrderHours
PRINT @OrderProjectLeadEmail