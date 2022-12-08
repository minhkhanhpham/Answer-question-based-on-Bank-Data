Data Source: https://docs.google.com/spreadsheets/d/1GejpDFrZgfY18H0pQanyt-5OoXmj3uOh/edit?usp=sharing&ouid=111964587167429019188&rtpof=true&sd=true
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


--3 cán bộ bán được thẻ nhất theo điều kiện
select top(3) c.Ten_can_bo, count(c.ten_can_bo) as sotheban
from the as a
inner join gdt as b on a.card_id=b.CARD_ID
inner join [nhan su] as c on a.Ma_can_bo_ban=c.Ma_can_bo_ban
where a.UNLOCK_DATE between '2021/06/01' and '2021/10/31'
and b.TXN_AMT_LCY>=1000000 and a.CARD_STATUS='card ok' 
group by c.Ten_can_bo
order by sotheban desc
 

 --tổng giao dịch theo tháng
select month(cdr_dt) as thang,count(txn_amt_lcy) as solangd, sum(txn_amt_lcy) as tonggiaodich
from gdt
where MONTH(cdr_dt) between '3' and '10'
and TXN_STT='successfull'
group by month(CDR_DT)
order by sum(txn_amt_lcy) desc


--tổng giao dịch theo ngành giao dịch 
+ Thay thế các giá trị null
update gdt
set SIC_NM = 'Khác'
where SIC_NM = 'null'

update gdt
set SIC_NM= N'học tập'
where SIC_NM=N'hoc tập'

select SIC_NM as nganhgd, count(txn_amt_lcy) as solangd, sum(txn_amt_lcy) as tonggiaodich
from gdt
where MONTH(cdr_dt) between '3' and '10'
and TXN_STT='successfull'
group by SIC_NM
order by sum(txn_amt_lcy) desc


---tổng giao dịch theo hình thức giao dịch
select TXN_TP as hinhthuc, count(txn_amt_lcy) as solangd, sum(txn_amt_lcy) as tonggiaodich
from gdt
where MONTH(cdr_dt) between '3' and '10'
and TXN_STT='successfull'
group by TXN_TP
order by sum(txn_amt_lcy) desc


--Tổng giao dịch theo loại thẻ
select b.SEC_UNSEC, count(txn_amt_lcy) as solangd, sum(txn_amt_lcy) as tonggiaodich
from gdt as a
inner join the as b on a.CARD_ID=b.card_id
where MONTH(cdr_dt) between '3' and '10'
and TXN_STT='successfull'
group by b.SEC_UNSEC 


--Tổng giao dịch theo chi nhánh
select b.Ma_chi_nhanh, count(txn_amt_lcy) as solangd, sum(txn_amt_lcy) as tonggiaodich
from gdt as a
inner join the as b on a.CARD_ID=b.card_id
where MONTH(cdr_dt) between '3' and '10'
and TXN_STT='successfull'
group by b.Ma_chi_nhanh


--tổng số lần giao dịch theo ngành hàng và hình thức gd
with tong as
(select sic_nm, TXN_TP ,count(txn_amt_lcy) as solangd
from gdt
where MONTH(cdr_dt) between '3' and '10'
and TXN_STT='successfull'
group by sic_nm, TXN_TP)
select * from tong
pivot(sum(solangd) for txn_tp in([onlinepayment],[pos],[atm withdraw])) as pivoted


--tổng giao dịch theo ngành hàng và hình thức gd
with tong as
(select sic_nm, TXN_TP ,sum(txn_amt_lcy) as tonggd
from gdt
where MONTH(cdr_dt) between '3' and '10'
and TXN_STT='successfull'
group by sic_nm, TXN_TP)
select * from tong
pivot(sum(tonggd) for txn_tp in([onlinepayment],[pos],[atm withdraw])) as pivoted
--


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

