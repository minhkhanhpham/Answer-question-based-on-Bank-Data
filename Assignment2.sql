--3 cán bộ bán được thẻ nhất theo điều kiện
select top(3) c.Ten_can_bo, count(c.ten_can_bo) as sotheban
from the as a
inner join gdt as b on a.card_id=b.CARD_ID
inner join [nhan su] as c on a.Ma_can_bo_ban=c.Ma_can_bo_ban
where a.UNLOCK_DATE between '2021/06/01' and '2021/10/31'
and b.TXN_AMT_LCY>=1000000 and a.CARD_STATUS='card ok' 
group by c.Ten_can_bo
order by sotheban desc