with joined as (select kep.kep_id, kep.kep_nama, kep.kep_reknamabank, dhl.dhl_nama, dhl.dhl_biaya
from kep
join daftar_harga_layanan dhl on dhl.kep_id = kep.kep_id)
select * from joined
where kep_reknamabank = 'Mandiri'
order by kep_id, dhl_biaya;

select kep.kep_id, kep.kep_nama, kep.kep_reknamabank, dhl.dhl_nama, dhl.dhl_biaya
from kep
join daftar_harga_layanan dhl on dhl.kep_id = kep.kep_id
where kep.kep_reknamabank = 'Mandiri'
order by kep.kep_id, dhl.dhl_biaya;

select kep.kep_id, kep.kep_nama, kep.kep_reknamabank, dhl.dhl_nama, dhl.dhl_biaya
from kep, daftar_harga_layanan dhl
where kep.kep_id = dhl.kep_id and kep.kep_reknamabank = 'Mandiri'
order by kep.kep_id, dhl.dhl_biaya;

select kep.kep_id, kep.kep_nama, kep.kep_reknamabank, dhl.dhl_nama, dhl.dhl_biaya
from (select kep_id, kep_nama, kep_reknamabank from kep where kep_reknamabank = 'Mandiri') as kep
join daftar_harga_layanan dhl on dhl.kep_id = kep.kep_id
order by kep.kep_id, dhl.dhl_biaya;

select kep.kep_id, kep.kep_nama, kep.kep_reknamabank, dhl.dhl_nama, dhl.dhl_biaya
from kep
join daftar_harga_layanan dhl on dhl.kep_id = kep.kep_id
where kep.kep_reknamabank = 'Mandiri'
and dhl.dhl_biaya < 500000
order by kep.kep_id, dhl.dhl_biaya;

select kep.kep_id, kep.kep_nama, kep.kep_reknamabank, dhl.dhl_nama, dhl.dhl_biaya
from kep
join (select kep_id, dhl_nama, dhl_biaya from daftar_harga_layanan where dhl_biaya < 500000) dhl 
on dhl.kep_id = kep.kep_id
where kep.kep_reknamabank = 'Mandiri'
order by kep.kep_id, dhl.dhl_biaya;

-- Nama anggota kep
select kep.kep_id, kep.kep_statusaktif, sk.sk_id, ag.ag_id, ag.ag_nama from kep
join sk_kep sk on sk.kep_id = kep.kep_id
join member_kep on member_kep.sk_id = sk.sk_id
join anggota ag on ag.ag_id = member_kep.ag_id
where kep.kep_statusaktif = true
order by kep_id

select kep.kep_id, kep.kep_statusaktif, sk.sk_id, ag.ag_id, ag.ag_nama from kep
join (sk_kep sk join (member_kep join anggota ag 
					  on (ag.ag_id = member_kep.ag_id)) 
	  on (member_kep.sk_id = sk.sk_id)) 
on sk.kep_id = kep.kep_id
where kep.kep_statusaktif = true
and ag_nama like 'Ehehe %'
order by kep_id

select kep.kep_id, kep.kep_statusaktif, sk.sk_id, ag.ag_id, ag.ag_nama 
from kep, sk_kep sk, member_kep, anggota ag
where kep.kep_id = sk.kep_id and member_kep.sk_id = sk.sk_id and ag.ag_id = member_kep.ag_id
and kep.kep_statusaktif = true
order by kep_id
