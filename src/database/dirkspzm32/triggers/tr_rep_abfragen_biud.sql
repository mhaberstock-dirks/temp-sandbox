create or replace editionable trigger dirkspzm32.tr_rep_abfragen_biud before
    insert or update or delete on dirkspzm32.rep_abfragen
    for each row
declare
  -- local variables here
 begin
    if inserting then
        select
            seq_rep_id.nextval
        into :new.rep_id
        from
            dual;

    end if;

  -- Historische Eintraege
    if updating
    or deleting then
        insert into rep_abfragen_hist values ( :old.sid,
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
                                               :old.base_rep_name );

    end if;

end;
/

alter trigger dirkspzm32.tr_rep_abfragen_biud enable;


-- sqlcl_snapshot {"hash":"edfc83379b244af2f340c1fe47f957236fb7701b","type":"TRIGGER","name":"TR_REP_ABFRAGEN_BIUD","schemaName":"DIRKSPZM32","sxml":""}