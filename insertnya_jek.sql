-- Generate records
-- kep
insert into kep (kep_id, kep_nama, kep_reknamabank, kep_statusaktif, kep_statusdate)
select generate_series(1, 10000) kep_id, -- id
substr(md5(random()::text), 0, 25), -- nama
(array['Mandiri', 'BCA', 'BNI'])[floor(random() * 3 + 1)], -- nama bank
round(random())::int::bool, -- kep_statusaktif
timestamp '2018-01-10 20:00:00' + random() * (timestamp '2020-12-31 20:00:00' - timestamp '2018-01-10 10:00:00') -- kep_statusdate
;

-- sk kep
insert into sk_kep (sk_id, kep_id, sk_validstart, sk_validend)
select kep_id as sk_id, kep_id, kep_statusdate as sk_validstart, kep_statusdate + 90 as sk_validend -- 3 bulan
from kep

-- daftar harga layanan
insert into daftar_harga_layanan (dhl_id, kep_id, dhl_nama, dhl_biaya)
select generate_series(1, 100000) 
,trunc(random() * 10000 + 1)
,(array['Penelitian Doktor', 'Penelitian Mahasiswa', 'Penelitian Kesehatan', 'Swasta', 'BUMN'])[floor(random() * 5 + 1)]
,trunc(random() * 1000 + 100) * 1000

-- anggota
insert into anggota (ag_id, ag_nama, ag_institusiasal, jenis_kelamin)
select generate_series(1, 100000)
,concat((array['Anggun ', 'Bayu ', 'Cece ', 'Dirga ', 'Ehehe '])[floor(random() * 5 + 1)], substr(md5(random()::text), 0, 5))-- nama
,(array['ITS', 'UI', 'Unair', 'Telkom', 'UPNVJ'])[floor(random() * 5 + 1)]
,(array['P', 'L', 'N'])[floor(random() * 3 + 1)]

-- member_kep
insert into member_kep (ag_id, sk_id)
select distinct trunc(random() * 100000 + 1) as ag_id
, trunc(random() * 10000 + 1) as sk_id
from generate_series(1, 1000000)