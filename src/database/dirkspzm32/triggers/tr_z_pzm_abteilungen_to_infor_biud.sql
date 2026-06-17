
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_Z_PZM_ABTEILUNGEN_TO_INFOR_BIUD" 
  before insert or update or delete
  on DIRKSPZM32.PZM_ABTEILUNGEN
  for each row
declare
  v_action_type     varchar2(1);
begin
  begin
    if inserting 
    then
      insert into z_pzm_stammdaten_to_infor
        (tabelle, pk_felder, pk_value, action_date, status, action_type)
      values
        ('PZM_ABTEILUNGEN', 'ABT_ID', :new.abt_id, sysdate, 'N', 'I');
    else
      if updating
      then
        v_action_type := 'U';
      else
        v_action_type := 'D';
      end if;
      insert into z_pzm_stammdaten_to_infor
        (tabelle, pk_felder, pk_value, action_date, status, action_type)
      values
        ('PZM_ABTEILUNGEN', 'ABT_ID', :old.abt_id, sysdate, 'N', v_action_type);
    end if;
  exception
    when others then NULL;
  end;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_Z_PZM_ABTEILUNGEN_TO_INFOR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"089c47e7ba6ad4d7039fb8b5c6be1f01c3fa1ab8","type":"TRIGGER","name":"TR_Z_PZM_ABTEILUNGEN_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}