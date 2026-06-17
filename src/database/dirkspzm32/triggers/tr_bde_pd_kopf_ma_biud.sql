
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_PD_KOPF_MA_BIUD" 
  before insert or update on DIRKSPZM32.BDE_PD_KOPF_MA
  for each row

declare
  -- local variables here
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler-Variablen fï¿½r eine Exception
  -------------------------------------------------------------------------------------------------------
  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  v_bde_pd_pers_zeit_kst            bde_pd_pers_zeit_kst%rowtype;

begin
  -- Erst mal kein Fehler
  v_err_nr   := null;
  v_err_text := null;

  if INSERTING then
    if :new.created_date is NULL
    then
      :new.created_date := sysdate;
    end if;
    if :new.created_login_id is NULL
    then
      :new.created_login_id := -1;
    end if;
    if :new.pers_nr is NULL -- Keine PZM Bezug (Kostenstellenauswertung nicht mï¿½glich)
    then
      return;
    end if;
    insert into bde_pd_pers_zeit_kst t
      values (:new.sid,
              :new.firma_nr,
              :new.res_id,
              :new.pers_nr,
              :new.ls_login_id,
              :new.pd_kopf_beginn,
              to_date('31.12.3000', 'dd.mm.yyyy'),
              :new.res_kst,
              :new.pers_kst,
              NULL,
              NULL);

  elsif UPDATING
  then
    if :new.last_change_date = :old.last_change_date
    or :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    if not bde_p_base.get_pd_pers_zeit_kst(:new.sid, :new.firma_nr, :new.res_id, :new.pers_nr, :new.pd_kopf_beginn, v_bde_pd_pers_zeit_kst)
    then
      if :new.pd_kopf_ende is null
      then
        v_bde_pd_pers_zeit_kst.pd_pers_ende := to_date('31.12.3000', 'dd.mm.yyyy');
      else
        v_bde_pd_pers_zeit_kst.pd_pers_ende := :new.pd_kopf_ende;
      end if;
      insert into bde_pd_pers_zeit_kst t
        values (:new.sid,
                :new.firma_nr,
                :new.res_id,
                :new.pers_nr,
                :new.ls_login_id,
                :new.pd_kopf_beginn,
                v_bde_pd_pers_zeit_kst.pd_pers_ende,
                :new.res_kst,
                :new.pers_kst,
                NULL,
                NULL);
    else
      update bde_pd_pers_zeit_kst t
         set t.pd_pers_ende = :new.pd_kopf_ende
       where t.sid = :new.sid
         and t.firma_nr = :new.firma_nr
         and t.res_id = :new.res_id
         and t.ls_login_id = :new.ls_login_id
         and t.pd_pers_beginn = :new.pd_kopf_beginn;
    end if;
    if :new.last_change_login_id is null
    then
      :new.last_change_login_id := -1;
    end if;
  elsif DELETING then
    delete bde_pd_pers_zeit_kst t
     where t.sid = :old.sid
       and t.firma_nr = :old.firma_nr
       and t.res_id = :old.res_id
       and t.ls_login_id = :old.ls_login_id
       and t.pd_pers_beginn = :old.pd_kopf_beginn;
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
end tr_BDE_PD_KOPF_MA_biud;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_PD_KOPF_MA_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"5d84fbdb883652dff932132f7fa7e2dc6cfc0e42","type":"TRIGGER","name":"TR_BDE_PD_KOPF_MA_BIUD","schemaName":"DIRKSPZM32","sxml":""}