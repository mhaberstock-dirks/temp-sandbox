
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_PD_KOPF_BIUD" 
  before insert or update or delete on DIRKSPZM32.BDE_PD_KOPF
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_bde_pd_pers_zeit_kst            bde_pd_pers_zeit_kst%rowtype;

  -- local variables here
begin

 if deleting
  then
    delete BDE_PD_KOPF_MA t
     where t.sid = :old.sid
       and t.firma_nr = :old.firma_nr
       and t.res_id = :old.res_id
       and t.pd_kopf_beginn = :old.pd_kopf_beginn;
  end if;

  if updating
  then
    update bde_pd_kopf_ma t
       set t.pd_kopf_ende = :new.pd_kopf_ende
     where t.sid = :new.sid
       and t.firma_nr = :new.firma_nr
       and t.res_id = :new.res_id
       and t.pd_kopf_beginn >= :new.pd_kopf_beginn - 1  -- -AG- 2019.10.18 - Falscher Filter
       and t.pd_kopf_ende is NULL;
  end if;

  if :new.pers_nr is NULL -- Keine PZM Bezug (Kostenstellenauswertung nicht möglich)
  then
    return;
  end if;
  if inserting
  then
    insert into bde_pd_kopf_ma
      values (:new.sid,
              :new.firma_nr,
              :new.res_id,
              :new.ls_login_id,
              :new.pers_nr,
              :new.pd_kopf_beginn,
              NULL,
              :new.res_kst,
              :new.pers_kst,
              NULL,
              nvl(:new.ls_login_id, -1),
              NULL,
              NULL);
  end if;

exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end TR_BDE_FA_AUFTRAG_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_PD_KOPF_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"e75bf55835f73c92a7a81144297f6ea5ba875814","type":"TRIGGER","name":"TR_BDE_PD_KOPF_BIUD","schemaName":"DIRKSPZM32","sxml":""}