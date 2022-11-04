use test
go

alter table the
drop column nhomno

----số lượng thẻ tại trạng thái ok theo tên chi nhánh
select ma_chi_nhanh, count(*)
from the 
where BUSINESS_DATE='2021/10/31' and CARD_STATUS='card ok' 
and CONTRACT_STATUS='account ok'
group by Ma_chi_nhanh
order by Ma_chi_nhanh


----tổng nợ và số thẻ nợ theo loại thẻ và nhóm nợ

+chia nhóm nợ
alter table the
add nhomno as case
when ovd_days =0 then 'nodutieuchuan'
when ovd_days < 90 then 'nocanchuy'
when ovd_days < 180 then 'noduoitieuchuan'
when ovd_days < 360 then 'nonghingo'
else 'nomatvon' 
end

+ tổng nợ và số thẻ nợ theo nhóm nợ
select  nhomno, sum(balance)*(-1) as tongno, count(balance) as sotheno
from the
where balance<0 and BUSINESS_DATE='20211031'
group by nhomno

+ tổng nợ và số thẻ nợ theo loại thẻ
select SEC_UNSEC, sum(balance)*(-1) as tongno, count(balance) as sotheno
from the
where balance<0 and BUSINESS_DATE='20211031'
group by SEC_UNSEC


--Số lượng thẻ phát sinh giao dịch trong 30 ngày theo tháng
select month(cdr_dt) as thang, count(a.card_id) as sothe
from the as a
inner join gdt as b
on a.card_id=b.CARD_ID
where b.cdr_dt between a.UNLOCK_DATE and  DATEADD(day, 30, a.unlock_date)
group by month(cdr_dt)
order by thang


--Số lượng thẻ phát sinh giao dịch trong 30 ngày theo chi nhanh quản lý thẻ
select a.Ma_chi_nhanh as chinhanh, count(a.card_id) as sothe
from the as a
inner join gdt as b
on a.card_id=b.CARD_ID
where b.cdr_dt between a.UNLOCK_DATE and  DATEADD(day, 30, a.unlock_date)
group by a.Ma_chi_nhanh
order by a.Ma_chi_nhanh


--Số lượng thẻ phát sinh giao dịch trong 30 ngày theo trạng thái thẻ ngày 31/10
select  count(a.card_id) as sothe, c.status
from the as a
inner join gdt as b a on.card_id=b.CARD_ID
inner join cus_stt as c on a.card_cif=c.cif
where b.cdr_dt between a.UNLOCK_DATE and  DATEADD(day, 30, a.unlock_date)
and c.BUSINESS_DATE='20211031'
group by c.status


