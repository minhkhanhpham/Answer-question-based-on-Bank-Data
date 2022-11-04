use test
go

-- Xóa duplicate trong bảng cus_stt
with cte as(
select *,
ROW_NUMBER() over(partition by business_date, cif, status order by business_date, cif, status) as row_no
from cus_stt)
delete from cte
where row_no>1


-- Xóa duplicate trong bảng cus_lessvalue
with cte as(
select *,
ROW_NUMBER() over(partition by business_date, cif order by business_date, cif) as row_no
from cus_lessvalue)
delete from cte
where row_no>1


-- đếm số ngày dữ liệu trong 60 ngày
select distinct business_date
from cus_stt
order by BUSINESS_DATE

select distinct business_date
from cus_stt
where month(BUSINESS_DATE)=12
order by BUSINESS_DATE

--khách hàng inactive 60 ngày liên tiếp
with ds as
(select cif, count(*) as solan
from cus_stt  
where status = 'inactive'
group by cif)
select cif 
into #bangtam1
from ds
where solan>= 52


-- khách hàng lessvalue 60 ngày liên tiếp
with ds2 as
(select cif, count(*) as solan
from cus_lessvalue  
group by cif)
select cif 
into #bangtam2
from ds2
where solan>=27
 

 --khách hàng có trạng thái inactive trong 60 ngày liên tiếp hoặc khách hàng less value trong 60 ngày liên tiếp
select * from #bangtam1
union
select * from #bangtam2

