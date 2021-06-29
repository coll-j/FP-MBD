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
insert into kep (kep_nama, kep_email, kep_password) values ('test', 'tets', 'test')
delete from kep

-- Generate records
insert into kep (kep_nama, kep_email, kep_password, kep_reknamabank, kep_statusaktif, kep_statusdate)
select substr(md5(random()::text), 0, 25), -- nama
concat(substr(md5(random()::text), 0, 5), '@mail.com'), -- email
substr(md5(random()::text), 0, 25), -- pass
(array['Mandiri', 'BCA', 'BNI'])[floor(random() * 3 + 1)], -- nama bank
round(random())::int::bool, -- kep_statusaktif
timestamp '2018-01-10 20:00:00' + random() * (timestamp '2020-12-31 20:00:00' - timestamp '2018-01-10 10:00:00') -- kep_statusdate
from generate_series(1, 1000);
