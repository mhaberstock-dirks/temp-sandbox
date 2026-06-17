
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_REP_ABFRAGEN_BIUD" 
  before insert or update or delete on DIRKSPZM32.rep_abfragen
  for each row
declare
  -- local variables here
begin
  if inserting then
    select seq_rep_id.nextval into :new.rep_id from dual;
  end if;

  -- Historische Eintraege
  if updating or deleting
  then
    insert into rep_abfragen_hist
    values (:old.sid,
            :old.firma_nr,
            seq_rep_hist_id.nextval,
            sysdate,
            :old.rep_id,
            :old.rep_name,
            :old.rep_gruppe,
            :old.rep_info,
            :old.rep_intern,
            :old.sort_field_param_name,
            :old.erz_datum,
            :old.erz_login_name,
            :old.aend_datum,
            :old.aend_login_name,
            :old.rave_rep_datei,
            :old.rave_rep_name,
            :old.default_sort_field,
            :old.security_level,
            :old.mod_id,
            :old.rep_sql_clob,
            :old.web_freigabe,
            :old.default_anzeige,
            :old.chart_anzeige_aktiv,
            :old.extensions_params_csv,
            :old.base_rep_name
    );
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_REP_ABFRAGEN_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"e5c9feabc4a8c2e52e462b8275f0411aab39644a","type":"TRIGGER","name":"TR_REP_ABFRAGEN_BIUD","schemaName":"DIRKSPZM32","sxml":""}