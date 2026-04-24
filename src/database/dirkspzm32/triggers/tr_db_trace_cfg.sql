create or replace editionable trigger dirkspzm32.tr_db_trace_cfg before
    insert or update or delete on dirkspzm32.db_trace_cfg
    for each row
declare
  -- local variables here
    v_text varchar2(4096);
begin
    if inserting then
        db_p_trace.c_trigger_von_tmpl_erstellen(:new.sid,
                                                :new.firma_nr,
                                                :new.userid,
                                                :new.tabellenname,
                                                v_text);

        db_p_trace.c_job_erstellen(:new.sid,
                                   :new.firma_nr,
                                   :new.userid,
                                   null,
                                   v_text);

        if :new.spalten is null then
            :new.spalten := db_p_trace.get_spalten_namen(:new.sid,
                                                         :new.firma_nr,
                                                         :new.userid,
                                                         :new.tabellenname);
        end if;

    elsif updating then
        :new.changeddate := sysdate();
        if :new.spalten is null then
            :new.spalten := db_p_trace.get_spalten_namen(:new.sid,
                                                         :new.firma_nr,
                                                         :new.userid,
                                                         :new.tabellenname);

        end if;

    elsif deleting then
        db_p_trace.c_trigger_loeschen(:new.sid,
                                      :new.firma_nr,
                                      -1,
                                      :old.tabellenname,
                                      v_text);
    end if;
end tr_isi_db_act_cfg;
/

alter trigger dirkspzm32.tr_db_trace_cfg enable;


-- sqlcl_snapshot {"hash":"e22c3845e6f2c748166b74cc5d223dcf829cb64f","type":"TRIGGER","name":"TR_DB_TRACE_CFG","schemaName":"DIRKSPZM32","sxml":""}