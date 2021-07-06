--
-- SCENARIO 1
--

-- QUERY 1
select kep.kep_id, kep.kep_nama, mc.pr_id, pr.pr_judul 
from kep
join multicenter as mc on mc.kep_id = kep.kep_id
join protokol as  pr on pr.pr_id = mc.pr_id
where mc.kep_utama = true
order by kep.kep_id;     

-- QUERY 2
select kep.kep_id, kep.kep_nama, mc.pr_id, pr.pr_judul from kep join (select kep_id, pr_id, kep_utama from 
multicenter where kep_utama = true) mc on mc.kep_id = kep.kep_id
join (select pr_id, pr_judul from protokol) pr on pr.pr_id = mc.pr_id  order by kep.kep_id;     

-- INDEXING
create index idx_kep_utama on multicenter (kep_utama);

-- 
-- SCENARIO 2
--

-- QUERY 1
select ht.ht_id, ht.pr_id, pr.pr_judul, dt.tmp_hklasifikasi as jml_hklasifikasi_e2 
from hasil_telaah ht
join (select count(*) as tmp_hklasifikasi, ht_id from detail_nilai_telaah 
		where dt_rekomklasifikasi = 'E2' group by ht_id) dt 
	on dt.ht_id = ht.ht_id
join protokol pr on pr.pr_id = ht.pr_id
where dt.tmp_hklasifikasi > 2  
order by jml_hklasifikasi_e2 desc, pr_judul asc;

-- QUERY 2
select ht.ht_id, ht.pr_id, pr.pr_judul, dt.tmp_hklasifikasi as jml_hklasifikasi_e2 
from hasil_telaah ht, 
	(select count(*) as tmp_hklasifikasi, ht_id from detail_nilai_telaah 
		where dt_rekomklasifikasi = 'E2' group by ht_id) dt,
	(select pr_id, pr_judul from protokol) pr
where dt.ht_id = ht.ht_id and pr.pr_id = ht.pr_id and dt.tmp_hklasifikasi > 2  
order by jml_hklasifikasi_e2 desc, pr_judul asc;

-- QUERY 3
select ht.ht_id, ht.pr_id, pr.pr_judul, dt.tmp_hklasifikasi as jml_hklasifikasi_e2 
from (select ht_id, pr_id from hasil_telaah) ht, 
	(select count(*) as tmp_hklasifikasi, ht_id from detail_nilai_telaah 
		where dt_rekomklasifikasi = 'E2' group by ht_id) dt,
	(select pr_id, pr_judul from protokol) pr
where dt.ht_id = ht.ht_id and pr.pr_id = ht.pr_id and dt.tmp_hklasifikasi > 2  
order by jml_hklasifikasi_e2 desc, pr_judul asc;

-- JOIN_COLLAPSE_LIMIT
set join_collapse_limit=1;

-- INDEXING
create index idx_rekomklasifikasi on detail_nilai_telaah (dt_rekomklasifikasi);