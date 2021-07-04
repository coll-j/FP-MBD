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
from (select kep_id, kep_nama, kep_reknamabank from kep where kep_reknamabank = 'Mandiri') as kep
join daftar_harga_layanan dhl on dhl.kep_id = kep.kep_id
order by kep.kep_id, dhl.dhl_biaya;

select kep.kep_id, sk.sk_id, ag.ag_id from kep
join sk_kep sk on sk.kep_id = kep.kep_id
