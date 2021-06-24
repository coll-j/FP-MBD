-- Sequence ID KEP
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

CREATE TRIGGER add_kep BEFORE INSERT ON kep
	FOR EACH ROW
	EXECUTE PROCEDURE add_kep();

-- Test insert KEP
insert into kep (kep_nama, kep_email, kep_password) values ('test', 'tets', 'test')