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

