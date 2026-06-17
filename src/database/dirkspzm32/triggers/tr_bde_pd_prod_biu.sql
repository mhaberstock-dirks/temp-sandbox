
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_PD_PROD_BIU" 
  before insert or update on DIRKSPZM32.BDE_PD_PROD
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_bde_fa_auftrag              bde_fa_auftrag%rowtype;

begin
  if :new.vorg_typ = 'PP'
  and bde_p_base.get_fa_ag(:new.sid,
                           :new.firma_nr,
                           :new.leitzahl,
                           :new.fa_ag,
                           :new.fa_upos,
                           v_bde_fa_auftrag)
  then
    if v_bde_fa_auftrag.freig_status = 'N'     -- Auftrag nicht angemeldet. Man. Eingabe dann Auftrag Status auf Produktion und Startzeit eintragen.
    then
      update bde_fa_auftrag t
         set t.termin_start_ist = :new.prod_beginn,
             t.freig_status = 'TF'
       where t.sid = :new.sid
         and t.firma_nr = :new.firma_nr
         and t.leitzahl = :new.leitzahl
         and t.fa_ag = :new.fa_ag
         and t.fa_upos = :new.fa_upos;
    end if;
    if v_bde_fa_auftrag.anz_res = 0     -- Auftrag nicht angemeldet. Man. Eingabe dann Auftrag Status auf Produktion und Startzeit eintragen.
    then
      update bde_fa_auftrag t
         set t.freig_status = case when :new.menge_a + v_bde_fa_auftrag.ag_ist_mg >= v_bde_fa_auftrag.ag_soll_mg
                                   then 'F'
                                   else t.freig_status
                                   end
       where t.sid = :new.sid
         and t.firma_nr = :new.firma_nr
         and t.leitzahl = :new.leitzahl
         and t.fa_ag = :new.fa_ag
         and t.fa_upos = :new.fa_upos;
    end if;
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
end TR_BDE_PD_PROD_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_PD_PROD_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"1af3a30819d059f2f4c3815fdc86a954b064ae12","type":"TRIGGER","name":"TR_BDE_PD_PROD_BIU","schemaName":"DIRKSPZM32","sxml":""}