
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_DB_TRACE_CFG" 
  before insert or update or delete on DIRKSPZM32."DB_TRACE_CFG"
  FOR each row
declare
  -- local variables here
  v_text varchar2(4096);
begin

  if inserting
  then
    db_p_trace.c_trigger_von_tmpl_erstellen(:new.sid,
                                            :new.firma_nr,
                                            :new.userid,
                                            :new.tabellenname,
                                            v_text);
    db_p_trace.c_job_erstellen(:new.sid,
                               :new.firma_nr,
                               :new.userid,
                               NULL,
                               v_text);
    if :new.spalten is NULL
    then
      :new.spalten := db_p_trace.get_spalten_namen(:new.sid,
                                                   :new.firma_nr,
                                                   :new.userid,
                                                   :new.tabellenname);
    end if;

  elsif updating
  then
    :new.changeddate := sysdate();
    if :new.spalten is NULL
    then
      :new.spalten := db_p_trace.get_spalten_namen(:new.sid,
                                                   :new.firma_nr,
                                                   :new.userid,
                                                   :new.tabellenname);
    end if;

  elsif deleting
  then
    db_p_trace.c_trigger_loeschen(:new.sid,
                                  :new.firma_nr,
                                  -1,
                                  :old.tabellenname,
                                  v_text);
  end if;

end tr_isi_db_act_cfg;

/
ALTER TRIGGER "DIRKSPZM32"."TR_DB_TRACE_CFG" ENABLE;


-- sqlcl_snapshot {"hash":"77e6ba3ab9973e768ad944dd7f2296f4644da9e7","type":"TRIGGER","name":"TR_DB_TRACE_CFG","schemaName":"DIRKSPZM32","sxml":""}