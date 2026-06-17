
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ARTIKEL_BD" 
  before delete on DIRKSPZM32.isi_artikel
  for each row
declare

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);

  -- local variables here

  v_c_result                  number;
  v_found                     boolean;
  CURSOR c_lam is
    select lam_id
      from lvs_v_lam
     where artikel_id = :old.artikel_id;

  CURSOR c_fa_auftrag is
    select auf.leitzahl
      from bde_fa_auftrag auf
     where auf.ag_artikel_id = :old.artikel_id;

  CURSOR c_linie_daten is
    select plw.linie_nr
      from lvs_prod_linie_waren plw
     where plw.artikel_id = :old.artikel_id;
begin
  OPEN c_lam;
  FETCH c_lam into v_c_result;
  v_found := c_lam%FOUND;
  CLOSE c_lam;
  if v_found then
    v_err_nr := 10;
    v_err_text := 'Fehler: Artikel kann nicht gelöscht werden, da dieser Bestandsführung hat.';
    raise v_error;
  end if;

  OPEN c_fa_auftrag;
  FETCH c_fa_auftrag into v_c_result;
  v_found := c_fa_auftrag%FOUND;
  CLOSE c_fa_auftrag;
  if v_found then
    v_err_nr := 20;
    v_err_text := 'Fehler: Artikel kann nicht gelöscht werden, da dieser in der Produktionplanung für Fertigungsauftrag '
                   || v_c_result || ' ist.';
    raise v_error;
  end if;

  OPEN c_linie_daten;
  FETCH c_linie_daten into v_c_result;
  v_found := c_linie_daten%FOUND;
  CLOSE c_linie_daten;
  if v_found then
    v_err_nr := 30;
    v_err_text := 'Fehler: Artikel kann nicht gelöscht werden, da dieser in der Warenauszeichnung auf Linie '
                   || v_c_result || ' Eingetragen ist.';
    raise v_error;
  end if;

exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    v_err_text := v_err_text  || cr_lf() || dbms_utility.format_error_backtrace;
    raise_application_error(-20000 - v_err_nr, v_err_text, true);
  when others then
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || dbms_utility.format_error_backtrace;
      raise_application_error(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := dbms_utility.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := lc.ec(lc.O_TXT_DB_ERROR) || cr_lf() || dbms_utility.format_error_backtrace;
        raise_application_error(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ARTIKEL_BD" ENABLE;


-- sqlcl_snapshot {"hash":"6c056af28dbf77beee37160b21882b6ac3fe9c0e","type":"TRIGGER","name":"TR_ISI_ARTIKEL_BD","schemaName":"DIRKSPZM32","sxml":""}