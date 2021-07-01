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


--peneliti, pengusul, protokol, protokol_peneliti
--protokol_peneliti
SELECT * FROM protokol_peneliti
INSERT INTO protokol_peneliti(pr_id, p_id, prp_role)
SELECT trunc(random()*(10001-1)+1),
trunc(random()*(10001-1)+1),
(array['V', 'W', 'X', 'Y', 'Z'])[floor(random() * 5 + 1)]
FROM generate_series(1,10000);

DELETE FROM protokol_peneliti;

--protokol
ALTER TABLE protokol ALTER COLUMN pr_tglpenugasantim DROP NOT NULL;
ALTER TABLE protokol ALTER COLUMN pr_nosle DROP NOT NULL;
ALTER TABLE protokol ALTER COLUMN pr_tglsle DROP NOT NULL;
ALTER TABLE protokol ALTER COLUMN pr_tgluploadsle DROP NOT NULL;
ALTER TABLE protokol ALTER COLUMN pr_pathfilesle DROP NOT NULL;
ALTER TABLE protokol ALTER COLUMN pr_klasifikasikep DROP NOT NULL;

SELECT * FROM protokol
INSERT INTO protokol(pr_id, pu_id, pr_judul, pr_tglpengajuan, pr_tglkeputusankep)
SELECT generate_series(1,10000),
trunc(random()*(10001-1)+1),
(array['A', 'B', 'C', 'D', 'E'])[floor(random() * 5 + 1)],
timestamp '2018-01-10 20:00:00' + random() * (timestamp '2020-12-31 20:00:00' - timestamp '2018-01-10 10:00:00'),
timestamp '2020-12-31 20:00:00' + random() * (timestamp '2022-12-31 10:00:00' - timestamp '2020-12-31 20:00:00')
;

--pengusul
SELECT * FROM pengusul;
ALTER TABLE pengusul ALTER COLUMN pu_instansi DROP NOT NULL;
ALTER TABLE pengusul ALTER COLUMN pu_email DROP NOT NULL;
ALTER TABLE pengusul ALTER COLUMN pu_password DROP NOT NULL;
ALTER TABLE pengusul ALTER COLUMN pu_nokontak DROP NOT NULL;

INSERT INTO pengusul(pu_id, p_id, pu_nama, pu_nik)
SELECT generate_series(1,10000),
trunc(random()*(10001-1)+1),
substr(md5(random()::text),0,25),
trunc(random()*10000+1);

DELETE FROM pengusul;

--peneliti
ALTER TABLE peneliti ALTER COLUMN p_email DROP NOT NULL;
ALTER TABLE peneliti ALTER COLUMN p_instansi DROP NOT NULL;
ALTER TABLE peneliti ALTER COLUMN pu_id DROP NOT NULL;

SELECT * FROM peneliti;
INSERT INTO peneliti (p_id, pu_id, p_nama, p_nik)
SELECT generate_series(1,10000)
, trunc(random()*(10001-1)+1)
, substr(md5(random()::text),0,25)
, trunc(random()*10000+1);

ALTER TABLE peneliti ADD CONSTRAINT fk_pu
FOREIGN KEY (pu_id) REFERENCES pengusul (pu_id);

DELETE FROM peneliti;



