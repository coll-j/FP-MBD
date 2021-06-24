-- No 1
create or replace function deactivate_kep()
RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
	declare
	sk_id_kep int;
BEGIN
	if new.kep_statusaktif = false then
		sk_id_kep := (select sk_id 
					  from sk_kep 
					  where kep_id = new.kep_id 
					  order by sk_validstart desc
					  limit 1);
		update member_kep set mk_statusaktif = false where sk_id = sk_id_kep;
	end if;
	return new;
end
$$;

CREATE TRIGGER deactivate_kep after update ON kep
	FOR EACH ROW
	EXECUTE PROCEDURE deactivate_kep();

update kep set kep_statusaktif = false where kep_id = 5

-- No 2
-- Peneliti
CREATE SEQUENCE auto_peneliti
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY peneliti.p_id;
	
CREATE OR REPLACE FUNCTION add_peneliti()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	NEW.p_id := NEXTVAL('auto_peneliti');
	WHILE NEW.p_id IN (
		SELECT p_id
		FROM peneliti
	) LOOP
		NEW.p_id := NEXTVAL('auto_peneliti');
	END LOOP;
	RETURN NEW;
END
$$;

CREATE TRIGGER add_peneliti BEFORE INSERT ON peneliti
	FOR EACH ROW
	EXECUTE PROCEDURE add_peneliti();
	
-- Pengusul
CREATE SEQUENCE auto_pengusul
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY pengusul.pu_id;
	
CREATE OR REPLACE FUNCTION add_pengusul()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	NEW.pu_d := NEXTVAL('auto_pengusul');
	WHILE NEW.pu_id IN (
		SELECT pu_id
		FROM pengusul
	) LOOP
		NEW.pu_id := NEXTVAL('auto_pengusul');
	END LOOP;
	RETURN NEW;
END
$$;

CREATE TRIGGER add_pengusul BEFORE INSERT ON pengusul
	FOR EACH ROW
	EXECUTE PROCEDURE add_pengusul();
	
-- Protokol
CREATE SEQUENCE auto_protokol
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY protokol.pr_id;
	
CREATE OR REPLACE FUNCTION add_protokol()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	NEW.pr_id := NEXTVAL('auto_protokol');
	WHILE NEW.pr_id IN (
		SELECT pr_id
		FROM protokol
	) LOOP
		NEW.pr_id := NEXTVAL('auto_protokol');
	END LOOP;
	RETURN NEW;
END
$$;

CREATE TRIGGER add_protokol BEFORE INSERT ON protokol
	FOR EACH ROW
	EXECUTE PROCEDURE add_protokol();
	
-- Hasil telaah
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
	
-- No 3
alter table anggota
add column jenis_kelamin char;

CREATE SEQUENCE auto_jk_p
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY anggota.ag_id;
	
CREATE SEQUENCE auto_jk_l
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY anggota.ag_id;
	
CREATE SEQUENCE auto_jk_any
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY anggota.ag_id;
	
CREATE OR REPLACE FUNCTION add_anggota()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
	declare
	id_anggota varchar(254);
BEGIN
	if lower(new.jenis_kelamin) = 'p' then
		NEW.ag_id := replace(concat('P', to_char(NEXTVAL('auto_jk_p'), '0000')), ' ', '');
		WHILE NEW.ag_id IN (
			SELECT ag_id
			FROM anggota
		) LOOP
			NEW.ag_id := replace(concat('P', to_char(NEXTVAL('auto_jk_p'), '0000')), ' ', '');
		END LOOP;
	elseif lower(new.jenis_kelamin) = 'l' then
		NEW.ag_id := replace(concat('L', to_char(NEXTVAL('auto_jk_l'), '0000')), ' ', '');
		WHILE NEW.ag_id IN (
			SELECT ag_id
			FROM anggota
		) LOOP
			NEW.ag_id := replace(concat('L', to_char(NEXTVAL('auto_jk_l'), '0000')), ' ', '');
		END LOOP;
	else 
		NEW.ag_id := replace(concat('A', to_char(NEXTVAL('auto_jk_any'), '0000')), ' ', '');
		WHILE NEW.ag_id IN (
			SELECT ag_id
			FROM anggota
		) LOOP
			NEW.ag_id := replace(concat('A', to_char(NEXTVAL('auto_jk_any'), '0000')), ' ', '');
		END LOOP;
	end if;
	RETURN NEW;
END
$$;

CREATE TRIGGER add_anggota BEFORE INSERT ON anggota
	FOR EACH ROW
	EXECUTE PROCEDURE add_anggota();

insert into anggota (ag_nama, ag_institusiasal, ag_email, ag_password, jenis_kelamin)
values ('jek', 'its', 'admin@a.a', '12345', 'P')

-- No 8
create or replace function hasil_klasifikasi()
RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	if new.ht_klasifikasi = 'E2' or new.ht_klasifikasi = 'FB' then
		new.ht_keputusan = 'PERBAIKAN';
		new.ht_tglkeputusan = NOW();
	end if;
	return new;
end
$$;

CREATE TRIGGER hasil_klasifikasi before update ON hasil_telaah
	FOR EACH ROW
	EXECUTE PROCEDURE hasil_klasifikasi();

update hasil_telaah set ht_klasifikasi = 'E2' where ht_id = 1

-- No 5
create or replace function add_protokol_ht()
RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	insert into hasil_telaah (pr_id, ht_tglsubmitproposal, ht_perbaikanke, ht_statusproses, ht_fileproposal)
	values (new.pr_id, NOW(), 0, 'MENUNGGU', concat('\Uploads\Proposal\', new.pr_id, '.pdf'));
	return new;
end
$$;

CREATE TRIGGER add_protokol_ht after insert ON protokol
	FOR EACH ROW
	EXECUTE PROCEDURE add_protokol_ht();
	
insert into protokol (pu_id, pr_judul, pr_tglpengajuan) values (1, 'tes', now())

-- No 4
create or replace procedure cek_aktif_kep()
language plpgsql
as $$
declare 
id_kep int;
skkep record;
begin
for id_kep in (select kep_id from kep)
loop
 select * into skkep from sk_kep where kep_id = id_kep order by sk_validstart desc limit 1;
 if skkep.sk_validend < NOW() then
 update kep set kep_statusaktif = false where kep_id = id_kep;
 end if;
end loop;
end
$$;

call cek_aktif_kep();

-- No 6
alter table peneliti
drop constraint fk_peneliti_merangkap_pengusul,
add constraint fk_peniliti_merangkap_pengusul
   foreign key (pu_id)
   references pengusul(pu_id)
   on delete cascade;

alter table protokol_peneliti
drop constraint fk_protokol_sebagai_p_peneliti,
add constraint fk_protokol_sebagai_p_peneliti
   foreign key (p_id)
   references peneliti(p_id)
   on delete cascade;
   
alter table pengusul
drop constraint fk_pengusul_merangkap_peneliti,
add constraint fk_pengusul_merangkap_peneliti
   foreign key (p_id)
   references peneliti(p_id)
   on delete cascade;
   
create or replace procedure cek_pengusul()
language plpgsql
as $$
declare
id_pu int;
jumlah int;
begin
for id_pu in (select pu_id from pengusul)
loop
 jumlah := (select count(pr_judul) from protokol where pu_id = id_pu);
 if jumlah < 1 then
 delete from pengusul where pu_id = id_pu;
 end if;
end loop;
end
$$;

call cek_pengusul();

--No 7
create or replace function add_member_penelaah()
RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
	declare
		ht_record record;
BEGIN
	select * into ht_record from hasil_telaah where ht_id = new.ht_id;
	update hasil_telaah set ht_statusproses = 'PROSES' where ht_id = new.ht_id;
	update protokol set pr_tglpenugasantim = NOW() where pr_id = ht_record.pr_id;
	return new;
end
$$;

CREATE TRIGGER add_member_penelaah after insert ON member_penelaah
	FOR EACH ROW
	EXECUTE PROCEDURE add_member_penelaah();

insert into member_penelaah values ('L0017', 4, 6)
