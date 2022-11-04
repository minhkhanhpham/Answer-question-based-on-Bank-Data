use test
go
select * from gdt

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
