-- Clean foreign key constraints --
do
$$
declare r record;
begin
for r in (select constraint_name, table_name from information_schema.table_constraints where table_schema = 'public' and constraint_type != 'CHECK' order by constraint_type) loop
  raise info '%','dropping '||r.constraint_name||' from table'||r.table_name;
  execute CONCAT('ALTER TABLE "public".'||r.table_name||' DROP CONSTRAINT '||r.constraint_name);
end loop;
end;
$$
;

-- Drop all records --
do
$$
declare r record;
begin
for r in (select * from information_schema.tables where table_schema = 'public') loop
  raise info '%','truncating '||r.table_name;
  execute CONCAT('TRUNCATE "public".'||r.table_name||' CASCADE');
end loop;
end;
$$
;

-- Ganti id ag jd int
ALTER TABLE anggota ALTER COLUMN ag_id TYPE int using ag_id::integer;
ALTER TABLE detail_nilai_telaah ALTER COLUMN ag_id TYPE int using ag_id::integer;
ALTER TABLE member_kep ALTER COLUMN ag_id TYPE int using ag_id::integer;
ALTER TABLE member_penelaah ALTER COLUMN ag_id TYPE int using ag_id::integer;

-- Create PK
ALTER TABLE anggota 
   ADD CONSTRAINT pk_anggota
   PRIMARY KEY (ag_id);
ALTER TABLE daftar_harga_layanan 
   ADD CONSTRAINT pk_dhl
   PRIMARY KEY (dhl_id);
ALTER TABLE detail_nilai_telaah 
   ADD CONSTRAINT pk_dt
   PRIMARY KEY (dt_id);
ALTER TABLE hasil_telaah 
   ADD CONSTRAINT pk_ht
   PRIMARY KEY (ht_id);
ALTER TABLE kep 
   ADD CONSTRAINT pk_kep
   PRIMARY KEY (kep_id);
ALTER TABLE sk_kep 
   ADD CONSTRAINT pk_sk
   PRIMARY KEY (sk_id);
ALTER TABLE peneliti 
   ADD CONSTRAINT pk_p
   PRIMARY KEY (p_id);
ALTER TABLE pengusul 
   ADD CONSTRAINT pk_pu
   PRIMARY KEY (pu_id);
ALTER TABLE protokol 
   ADD CONSTRAINT pk_pr
   PRIMARY KEY (pr_id);
   
-- Create FK
ALTER TABLE multicenter 
   ADD CONSTRAINT fk_kep
   FOREIGN KEY (kep_id) 
   REFERENCES kep(kep_id);
ALTER TABLE multicenter 
   ADD CONSTRAINT fk_pr
   FOREIGN KEY (pr_id) 
   REFERENCES protokol(pr_id);
   
ALTER TABLE sk_kep 
   ADD CONSTRAINT fk_kep
   FOREIGN KEY (kep_id) 
   REFERENCES kep(kep_id);
   
ALTER TABLE member_kep 
   ADD CONSTRAINT fk_sk
   FOREIGN KEY (sk_id) 
   REFERENCES sk_kep(sk_id);
ALTER TABLE member_kep 
   ADD CONSTRAINT fk_ag
   FOREIGN KEY (ag_id) 
   REFERENCES anggota(ag_id);

ALTER TABLE member_penelaah 
   ADD CONSTRAINT fk_ag
   FOREIGN KEY (ag_id) 
   REFERENCES anggota(ag_id);
ALTER TABLE member_penelaah 
   ADD CONSTRAINT fk_sk
   FOREIGN KEY (sk_id) 
   REFERENCES sk_kep(sk_id);
ALTER TABLE member_penelaah 
   ADD CONSTRAINT fk_ht
   FOREIGN KEY (ht_id) 
   REFERENCES hasil_telaah(ht_id);
   
ALTER TABLE detail_nilai_telaah 
   ADD CONSTRAINT fk_ag
   FOREIGN KEY (ag_id) 
   REFERENCES anggota(ag_id);
ALTER TABLE detail_nilai_telaah 
   ADD CONSTRAINT fk_sk
   FOREIGN KEY (sk_id) 
   REFERENCES sk_kep(sk_id);
ALTER TABLE detail_nilai_telaah 
   ADD CONSTRAINT fk_ht
   FOREIGN KEY (ht_id) 
   REFERENCES hasil_telaah(ht_id);
   
ALTER TABLE peneliti 
   ADD CONSTRAINT fk_pu
   FOREIGN KEY (pu_id) 
   REFERENCES pengusul(pu_id);
   
ALTER TABLE pengusul 
   ADD CONSTRAINT fk_p
   FOREIGN KEY (p_id) 
   REFERENCES peneliti(p_id);
   
ALTER TABLE protokol_peneliti 
   ADD CONSTRAINT fk_p
   FOREIGN KEY (p_id) 
   REFERENCES peneliti(p_id);
ALTER TABLE protokol_peneliti 
   ADD CONSTRAINT fk_pr
   FOREIGN KEY (pr_id) 
   REFERENCES protokol(pr_id);
   
ALTER TABLE protokol 
   ADD CONSTRAINT fk_pu
   FOREIGN KEY (pu_id) 
   REFERENCES pengusul(pu_id);
   
ALTER TABLE hasil_telaah 
   ADD CONSTRAINT fk_pr
   FOREIGN KEY (pr_id) 
   REFERENCES protokol(pr_id);
   
ALTER TABLE daftar_harga_layanan 
   ADD CONSTRAINT fk_kep
   FOREIGN KEY (kep_id) 
   REFERENCES kep(kep_id);
   
-- Drop all trigger
CREATE OR REPLACE FUNCTION strip_all_triggers() RETURNS text AS $$ DECLARE
    triggNameRecord RECORD;
    triggTableRecord RECORD;
BEGIN
    FOR triggNameRecord IN select distinct(trigger_name) from information_schema.triggers where trigger_schema = 'public' LOOP
        FOR triggTableRecord IN SELECT distinct(event_object_table) from information_schema.triggers where trigger_name = triggNameRecord.trigger_name LOOP
            RAISE NOTICE 'Dropping trigger: % on table: %', triggNameRecord.trigger_name, triggTableRecord.event_object_table;
            EXECUTE 'DROP TRIGGER ' || triggNameRecord.trigger_name || ' ON ' || triggTableRecord.event_object_table || ';';
        END LOOP;
    END LOOP;

    RETURN 'done';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

select strip_all_triggers();
