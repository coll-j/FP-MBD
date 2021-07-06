-- Sequence ID KEP
Drop sequence auto_kep;
CREATE SEQUENCE auto_kep
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY kep.kep_id;
	
CREATE OR REPLACE FUNCTION add_kep()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	NEW.kep_id := NEXTVAL('auto_kep');
	WHILE NEW.kep_id IN (
		SELECT kep_id
		FROM kep
	) LOOP
		NEW.kep_id := NEXTVAL('auto_kep');
	END LOOP;
	RETURN NEW;
END
$$;

drop trigger add_kep on kep;
CREATE TRIGGER add_kep BEFORE INSERT ON kep
	FOR EACH ROW
	EXECUTE PROCEDURE add_kep();

-- Test insert KEP
-- insert into kep (kep_nama, kep_email, kep_password) values ('test', 'tets', 'test')

-- Generate records
-- kep
insert into kep (kep_id, kep_nama, kep_reknamabank, kep_statusaktif, kep_statusdate)
select generate_series(1, 10000) kep_id, -- id
substr(md5(random()::text), 0, 25), -- nama
(array['Mandiri', 'BCA', 'BNI'])[floor(random() * 3 + 1)], -- nama bank
round(random())::int::bool, -- kep_statusaktif
timestamp '2018-01-10 20:00:00' + random() * (timestamp '2020-12-31 20:00:00' - timestamp '2018-01-10 10:00:00') -- kep_statusdate
;

ALTER TABLE sk_kep ALTER COLUMN sk_nomorsk DROP NOT NULL;

-- sk kep
insert into sk_kep (sk_id, kep_id, sk_validstart, sk_validend)
select kep_id as sk_id, kep_id, kep_statusdate as sk_validstart, kep_statusdate + 90 as sk_validend -- 3 bulan
from kep

ALTER TABLE daftar_harga_layanan ALTER COLUMN dhl_hargavalidstart DROP NOT NULL;
ALTER TABLE daftar_harga_layanan ALTER COLUMN dhl_hargavalidend DROP NOT NULL;

-- daftar harga layanan
insert into daftar_harga_layanan (dhl_id, kep_id, dhl_nama, dhl_biaya)
select generate_series(1, 100000) 
,trunc(random() * 10000 + 1)
,(array['Penelitian Doktor', 'Penelitian Mahasiswa', 'Penelitian Kesehatan', 'Swasta', 'BUMN'])[floor(random() * 5 + 1)]
,trunc(random() * 1000 + 100) * 1000

ALTER TABLE anggota ADD COLUMN jenis_kelamin VARCHAR;
ALTER TABLE anggota ALTER COLUMN ag_email DROP NOT NULL;
ALTER TABLE anggota ALTER COLUMN ag_password DROP NOT NULL;

-- anggota
insert into anggota (ag_id, ag_nama, ag_institusiasal, jenis_kelamin)
select generate_series(1, 100000)
,concat((array['Anggun ', 'Bayu ', 'Cece ', 'Dirga ', 'Ehehe '])[floor(random() * 5 + 1)], substr(md5(random()::text), 0, 5))-- nama
,(array['ITS', 'UI', 'Unair', 'Telkom', 'UPNVJ'])[floor(random() * 5 + 1)]
,(array['P', 'L', 'N'])[floor(random() * 3 + 1)]
