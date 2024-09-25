ALTER SESSION SET CONTAINER=FREEPDB1;

Create tablespace maxdata datafile '/opt/oracle/oradata/FREE/FREEPDB1/maxdata.dbf' size 1000M autoextend on;
Create tablespace maxlobs datafile '/opt/oracle/oradata/FREE/FREEPDB1/maxlobs.dbf' size 1000M autoextend on;
Create tablespace maxindex datafile '/opt/oracle/oradata/FREE/FREEPDB1/maxindex.dbf' size 1000M autoextend on;
create temporary tablespace maxtemp tempfile '/opt/oracle/oradata/FREE/FREEPDB1/maxtemp.dbf' size 1000M autoextend on maxsize unlimited;

create user maximo identified by maximo default tablespace maxdata temporary tablespace maxtemp;
alter user maximo quota unlimited on maxindex;

grant connect to maximo;
grant create job to maximo;
grant create trigger to maximo;
grant create session to maximo;
grant create sequence to maximo;
grant create synonym to maximo;
grant create table to maximo;
grant create view to maximo;
grant create procedure to maximo;
grant alter session to maximo;
grant execute on ctxsys.ctx_ddl to maximo;
alter user maximo quota unlimited on maxdata;
alter user maximo quota unlimited on maxlobs;

grant select_catalog_role to maximo;


call ctx_ddl.create_preference('MAXIMO_STORAGE', 'BASIC_STORAGE');
call ctx_ddl.set_attribute('MAXIMO_STORAGE', 'I_TABLE_CLAUSE', 'tablespace MAXDATA LOB(token_info) store as (tablespace MAXLOBS enable storage in row)');
call ctx_ddl.set_attribute('MAXIMO_STORAGE', 'I_INDEX_CLAUSE', 'tablespace MAXINDX compress 2');
call ctx_ddl.set_attribute('MAXIMO_STORAGE', 'K_TABLE_CLAUSE', 'tablespace MAXINDX');
call ctx_ddl.set_attribute('MAXIMO_STORAGE', 'R_TABLE_CLAUSE', 'tablespace MAXDATA LOB(data) store as (tablespace MAXLOBS cache)');
call ctx_ddl.set_attribute('MAXIMO_STORAGE', 'N_TABLE_CLAUSE', 'tablespace MAXINDX');

call ctx_ddl.drop_preference('global_lexer');
call ctx_ddl.drop_preference('default_lexer');
call ctx_ddl.drop_preference('english_lexer');
call ctx_ddl.drop_preference('chinese_lexer');
call ctx_ddl.drop_preference('japanese_lexer');
call ctx_ddl.drop_preference('korean_lexer');
call ctx_ddl.drop_preference('german_lexer');
call ctx_ddl.drop_preference('dutch_lexer');
call ctx_ddl.drop_preference('swedish_lexer');
call ctx_ddl.drop_preference('french_lexer');
call ctx_ddl.drop_preference('italian_lexer');
call ctx_ddl.drop_preference('spanish_lexer');
call ctx_ddl.drop_preference('portu_lexer');

call ctx_ddl.create_preference('default_lexer','basic_lexer');
call ctx_ddl.create_preference('english_lexer','basic_lexer');
call ctx_ddl.create_preference('chinese_lexer','chinese_lexer');
call ctx_ddl.create_preference('japanese_lexer','japanese_lexer');
call ctx_ddl.create_preference('korean_lexer','korean_morph_lexer');
call ctx_ddl.create_preference('german_lexer','basic_lexer');
call ctx_ddl.create_preference('dutch_lexer','basic_lexer');
call ctx_ddl.create_preference('swedish_lexer','basic_lexer');
call ctx_ddl.create_preference('french_lexer','basic_lexer');
call ctx_ddl.create_preference('italian_lexer','basic_lexer');
call ctx_ddl.create_preference('spanish_lexer','basic_lexer');
call ctx_ddl.create_preference('portu_lexer','basic_lexer');
call ctx_ddl.create_preference('global_lexer', 'multi_lexer');
call ctx_ddl.add_sub_lexer('global_lexer','default','default_lexer');
call ctx_ddl.add_sub_lexer('global_lexer','english','english_lexer','en');
call ctx_ddl.add_sub_lexer('global_lexer','simplified chinese','chinese_lexer','zh');
call ctx_ddl.add_sub_lexer('global_lexer','japanese','japanese_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','korean','korean_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','german','german_lexer','de');
call ctx_ddl.add_sub_lexer('global_lexer','dutch','dutch_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','swedish','swedish_lexer','sv');
call ctx_ddl.add_sub_lexer('global_lexer','french','french_lexer','fr');
call ctx_ddl.add_sub_lexer('global_lexer','italian','italian_lexer','it');
call ctx_ddl.add_sub_lexer('global_lexer','spanish','spanish_lexer','es');
call ctx_ddl.add_sub_lexer('global_lexer','portuguese','portu_lexer',null);


commit;