SET NOCOUNT ON;
---Quick Scan Environment on Number of Jobs per Context, Newest and Oldest Job
select count(*) Jobs, c.SRECCCDES ContextDescription, max(j.JobReportDate) LatestJob, min(j.JobReportDate) OldestJob,  j.JobContext from dba.Job j
join dba.SRECORDCONTEXTCOUNTRY c on j.jobcontext = c.SRECCCCONTEXT
 where SRECCCREC='JOB' and SRECCCCOU='NL'
 and j.JobRecStatus>=0
 group by JobContext, c.SRECCCDES
 order by Jobs desc

 select count(*) Reserveringen, c.SRECCCDES ContextDescription, max(Resocc.ResocStartDate) LatestRes, min(Resocc.ResocStartDate) OldestRes , resocc.ResocContext
 from dba.ReservationOccurrence ResOcc
join dba.SRECORDCONTEXTCOUNTRY c on ResOcc.ResocContext = c.SRECCCCONTEXT
where SRECCCREC='RESERVATION' and SRECCCCOU='NL'
and Resocc.ResocRecStatus >=0
group by resocc.ResocContext, c.SRECCCDES
order by Reserveringen desc

select count(*) Bestellingen, SRECSCDES Status from dba.Purchase
join dba.SRECORDSTATUSCOUNTRY on PchRecStatus=SRECSCSTATUS
where SRECSCREC='PURCHASE' and SRECSCCOU='NL'
and PchRecStatus>=0
group by PchRecStatus, SRECSCDES
order by Bestellingen desc

select count(*) Users, SGRONAME Role, SGRODES Description, MIN([SGROUSESUSEID]) AS UserId from .dba.suser
join dba.SGROUPUSER on SGROUSESUSEID=SUSEID
join dba.SGROUP on SGROUSEGROID=SGRONAME
join dba.Employee on SUSEEMPID=EmpId
where SUSERecStatus >= 0
and EmpRecStatus>=0
group by SGRODES, SGRONAME
Order by Users desc
