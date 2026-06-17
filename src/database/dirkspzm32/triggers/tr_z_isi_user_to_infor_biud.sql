
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_Z_ISI_USER_TO_INFOR_BIUD" 
  before insert or update
  on DIRKSPZM32.ISI_USER
  for each row
begin
  begin
    if inserting 
    then
      if :new.transponder is not NULL
      and :new.pers_nr is not NULL
      then
        insert into z_pzm_stammdaten_to_infor
          (tabelle, pk_felder, pk_value, action_date, status, action_type)
        values
          ('PZM_PERSONAL', 'pers_nr', :new.pers_nr, sysdate, 'N', 'I');
      end if;
    else
      if nvl(:new.transponder, '0') != nvl(:old.transponder, '0')
      and :old.pers_nr is not NULL
      then
        insert into z_pzm_stammdaten_to_infor
          (tabelle, pk_felder, pk_value, action_date, status, action_type)
        values
          ('PZM_PERSONAL', 'pers_nr', :new.pers_nr, sysdate, 'N', 'U');
      end if;
    end if;
  exception
    when others then NULL;
  end;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_Z_ISI_USER_TO_INFOR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"e0615efaba1c70b7d1e6121a6fcea420ae10898a","type":"TRIGGER","name":"TR_Z_ISI_USER_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}