
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_Z_PZM_VERTRAGSARTEN_TO_INFOR_BIUD" 
  before insert or update or delete
  on DIRKSPZM32.PZM_VERTRAGSARTEN
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
        ('PZM_VERTRAGSARTEN', 'VA_ID', :new.va_id, sysdate, 'N', 'I');
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
        ('PZM_VERTRAGSARTEN', 'VA_ID', :old.va_id, sysdate, 'N', v_action_type);
    end if;
  exception
    when others then NULL;
  end;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_Z_PZM_VERTRAGSARTEN_TO_INFOR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"af168dc04afb76e5737256e8647ccfd09565f282","type":"TRIGGER","name":"TR_Z_PZM_VERTRAGSARTEN_TO_INFOR_BIUD","schemaName":"DIRKSPZM32","sxml":""}