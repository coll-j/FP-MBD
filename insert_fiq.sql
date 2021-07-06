-- Contoh Random Generate
INSERT INTO anggota (ag_nama, ag_institusiasal, ag_email, ag_password, ag_jenis_kelamin) 
SELECT 
  'nama-' || round(random()*1000), 
  'institusi-' || round(random()*1000), 
  'email-' || round(random()*1000) || '@gmail.com', 
  substr(md5(random()::text), 0, 10), 
  (ARRAY['P','L'])[round(random())+1]
FROM generate_series(1,10000);

-- multicenter
insert into multicenter (kep_id, pr_id, kep_utama)
select distinct trunc(random() * 10000 + 1)
, trunc(random() * 10000 + 1), false
from generate_series(1, 1000000)

update multicenter 
set kep_utama = true
where mod(kep_id, 5) = 0

-- hasil_telaah
insert into hasil_telaah (ht_id, pr_id, ht_statusproses)
select generate_series(1, 1000000), 
trunc(random() * 10000 + 1),  
(array['PROSES', 'MENUNGGU', 'SELESAI'])[floor(random() * 3 + 1)];

select * from hasil_telaah

update hasil_telaah
set ht_perbaikanke = random_between(1,2)
where ht_statusproses = 'SELESAI' and mod(ht_id, 2) = 0;

-- detail_nilai_telaah
ALTER TABLE detail_nilai_telaah ALTER COLUMN sk_id DROP NOT NULL;

insert into detail_nilai_telaah (dt_id, ag_id, ht_id, dt_rekomklasifikasi)
select generate_series(1, 5000000), 
random_between(1, 100000),  
random_between(1, 1000000),  
(array['E2', 'E1', 'FB'])[floor(random() * 3 + 1)];

select * from detail_nilai_telaah;

