-- Contoh Random Generate
INSERT INTO anggota (ag_nama, ag_institusiasal, ag_email, ag_password, ag_jenis_kelamin) 
SELECT 
  'nama-' || round(random()*1000), 
  'institusi-' || round(random()*1000), 
  'email-' || round(random()*1000) || '@gmail.com', 
  substr(md5(random()::text), 0, 10), 
  (ARRAY['P','L'])[round(random())+1]
FROM generate_series(1,10000);

-- Hasil Telaah
CREATE SEQUENCE auto_hasil_telaah
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY hasil_telaah.ht_id;
	
CREATE OR REPLACE FUNCTION add_hasil_telaah()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	NEW.ht_id := NEXTVAL('auto_hasil_telaah');
	WHILE NEW.ht_id IN (
		SELECT ht_id
		FROM hasil_telaah
	) LOOP
		NEW.ht_id := NEXTVAL('auto_hasil_telaah');
	END LOOP;
	RETURN NEW;
END
$$;

CREATE TRIGGER add_hasil_telaah BEFORE INSERT ON hasil_telaah
	FOR EACH ROW
	EXECUTE PROCEDURE add_hasil_telaah();


CREATE OR replace FUNCTION hasil_klasifikasi()
RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	IF new.ht_klasifikasi = 'E2' OR new.ht_klasifikasi = 'FB' THEN
		new.ht_keputusan = 'PERBAIKAN';
		new.ht_tglkeputusan = NOW();
	END IF;
	RETURN new;
END
$$;

CREATE TRIGGER hasil_klasifikasi BEFORE UPDATE ON hasil_telaah
	FOR EACH ROW
	EXECUTE PROCEDURE hasil_klasifikasi();
	
-- Detail Nilai Telaah
CREATE SEQUENCE auto_detail_nilai_telaah
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY detail_nilai_telaah.dt_id;
	
CREATE OR REPLACE FUNCTION add_detail_nilai_telaah()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	NEW.dt_id := NEXTVAL('auto_detail_nilai_telaah');
	WHILE NEW.dt_id IN (
		SELECT dt_id
		FROM detail_nilai_telaah
	) LOOP
		NEW.dt_id := NEXTVAL('auto_detail_nilai_telaah');
	END LOOP;
	RETURN NEW;
END
$$;

CREATE TRIGGER add_detail_nilai_telaah BEFORE INSERT ON detail_nilai_telaah
	FOR EACH ROW
	EXECUTE PROCEDURE add_detail_nilai_telaah();

-- Member Penelaah
CREATE OR REPLACE FUNCTION add_member_penelaah()
RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
	DECLARE
		ht_record record;
BEGIN
	SELECT * INTO ht_record FROM hasil_telaah WHERE ht_id = new.ht_id;
	UPDATE hasil_telaah SET ht_statusproses = 'PROSES' WHERE ht_id = new.ht_id;
	UPDATE protokol SET pr_tglpenugasantim = NOW() WHERE pr_id = ht_record.pr_id;
	RETURN new;
END
$$;

CREATE TRIGGER add_member_penelaah AFTER INSERT ON member_penelaah
	FOR EACH ROW
	EXECUTE PROCEDURE add_member_penelaah();

CREATE OR REPLACE FUNCTION random_between(low INT ,high INT) 
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$ language 'plpgsql' STRICT;


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

