SELECT * FROM peneliti

-- Sequence ID peneliti
CREATE SEQUENCE peneliti_add
	AS integer
	INCREMENT BY 1
	MINVALUE 1
	NO MAXVALUE
	OWNED BY peneliti.p_id;

--TRIGGER
CREATE OR REPLACE FUNCTION add_peneliti()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN
	NEW.p_id := NEXTVAL('peneliti_add'); --sequence
	WHILE NEW.p_id IN (
		SELECT p_id
		FROM peneliti
	) LOOP
		NEW.p_id := NEXTVAL('peneliti_add');
	END LOOP;
	RETURN NEW;
END
$$;

CREATE TRIGGER add_peneliti BEFORE INSERT ON peneliti
	FOR EACH ROW
	EXECUTE PROCEDURE add_peneliti();

INSERT INTO peneliti (p_nama, p_email,p_nik) values ('123','123','123');