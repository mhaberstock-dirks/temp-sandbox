
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_BIU" 
BEFORE INSERT OR UPDATE ON DIRKSPZM32.PZM_KONTEN FOR EACH ROW
begin
  if inserting
  then
    if :new.konto_nr is null
    then
      select seq_pzm_konto_nr.nextval into :new.konto_nr from dual;
    end if;
  elsif updating then
    if :new.min_saldo is not null
    then
      if :new.saldo < :new.min_saldo
      then
        pzm_p_log.log_data(
          p_level => pzm_p_log.LEVEL_WARNING,
          p_message => 'Der Saldo unterschreitet den Minimalwert des Kontos. Konto: ' || :new.name,
          p_category => pzm_p_log.cat_system,
          p_module => 'TR_PZM_KONTEN_BIU',
          p_error_code => pzm_p_lc.PZM_ERROR_BUCHUNG,
          p_pers_nr => :new.pers_nr
        );
      end if;
    end if;

    if :new.max_saldo is not null
    then
      if :new.saldo > :new.max_saldo
      then
        pzm_p_log.log_data(
          p_level => pzm_p_log.LEVEL_WARNING,
          p_message => 'Der Saldo ueberschreitet den Maximalwert des Kontos. Konto: ' || :new.name,
          p_category => pzm_p_log.cat_system,
          p_module => 'TR_PZM_KONTEN_BIU',
          p_error_code => pzm_p_lc.PZM_ERROR_BUCHUNG,
          p_pers_nr => :new.pers_nr
        );
      end if;
    end if;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"2211125d2eff5bcb584b81c21f4914c313fcc7ba","type":"TRIGGER","name":"TR_PZM_KONTEN_BIU","schemaName":"DIRKSPZM32","sxml":""}