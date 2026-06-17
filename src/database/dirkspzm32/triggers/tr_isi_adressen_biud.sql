
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ADRESSEN_BIUD" 
  before insert or update or delete on DIRKSPZM32.isi_adressen
  for each row
declare
  -- local variables here
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);
  
  v_adress_id isi_adressen.adress_id%TYPE;

  v_lvs_prod_linie lvs_prod_linie%ROWTYPE;
  v_owner_id       lvs_lam.owner_address_id%type;

  CURSOR c_lvs_prod_linie IS
    SELECT *
      FROM lvs_prod_linie t
     WHERE t.adress_id = v_adress_id
       FOR UPDATE OF linie_aktiv;

  CURSOR c_lam is
    select l.owner_address_id
      from lvs_lam l
     where l.owner_address_id = :old.adress_id;

begin
  if INSERTING then
    if :new.adress_id is null
    then
      select seq_adressen_id.nextval into :new.adress_id from dual;
    end if;

    if :new.adr_art = 'L' and :new.ext_etiketten_druck = 'T' then
      -- bei fregeschlatetem Etikettendruck für externe Lieferanten
      -- Linie für den jew. Lieferanten freischalten
      lvs_prod.lieferant_linie_erzeugen(:new.sid, :new.firma_nr, :new.adr_art || to_char(:new.adr_nr), :new.adress_id);
    end if;
  elsif UPDATING then
    if :new.adr_art = 'L' then
      -- Liniendaten für Lieferanten pflegen
      -- (derzeit gibt es nur 1 Linie für einen Lieferanten)
      v_adress_id := :new.adress_id;

      OPEN c_lvs_prod_linie;

      FETCH c_lvs_prod_linie INTO v_lvs_prod_linie;
      if c_lvs_prod_linie%NOTFOUND then
        if :new.ext_etiketten_druck = 'T' then
          lvs_prod.lieferant_linie_erzeugen(:new.sid, :new.firma_nr, :new.adr_art || to_char(:new.adr_nr), :new.adress_id);
        end if;
      else
        if :new.ext_etiketten_druck = 'F' then
          -- Linie sperren
          UPDATE lvs_prod_linie
             SET linie_aktiv = 0
           WHERE CURRENT OF c_lvs_prod_linie;
        elsif :new.ext_etiketten_druck = 'T' AND v_lvs_prod_linie.linie_aktiv = 0 then
          -- Linie freischalten
          UPDATE lvs_prod_linie
             SET linie_aktiv = 1
           WHERE CURRENT OF c_lvs_prod_linie;
        end if;
      end if;

      CLOSE c_lvs_prod_linie;
    end if;
  elsif DELETING then
    OPEN c_lam;
    FETCH c_lam into v_owner_id;
    if c_lam%FOUND
    then
      CLOSE c_lam;
      v_err_nr := 10;
      v_err_text := 'Fehler: Adresse kann nicht gelöscht werden, da diese in der Bestandsführung ist.';
      raise v_error;
    end if;
    CLOSE c_lam;
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

end TR_ISI_ADRESSEN_BIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ADRESSEN_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"3667a5285f588437c6de8edd730f7299056680aa","type":"TRIGGER","name":"TR_ISI_ADRESSEN_BIUD","schemaName":"DIRKSPZM32","sxml":""}