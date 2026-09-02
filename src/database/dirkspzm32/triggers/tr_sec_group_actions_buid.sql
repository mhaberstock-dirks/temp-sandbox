
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_SEC_GROUP_ACTIONS_BUID" 
  before insert or update or delete on sec_group_actions
  for each row
declare
  -- local variables here
  v_sec_action       sec_action_info%rowtype;
  v_sec_grp_mod      sec_group_modules%rowtype;

  CURSOR c_sec_action is
    select *
      from sec_action_info t
     where t.action_id = :new.action_id;

  CURSOR c_sec_grp_mod is
    select *
      from sec_group_modules t
     where t.group_id = :new.group_id
       and t.mod_id = v_sec_action.mod_id;
begin
  if inserting
  then
    OPEN c_sec_action;
    FETCH c_sec_action into v_sec_action;
    CLOSE c_sec_action;

    v_sec_grp_mod := NULL;
    OPEN c_sec_grp_mod;
    FETCH c_sec_grp_mod into v_sec_grp_mod;
    CLOSE c_sec_grp_mod;

    if v_sec_grp_mod.mod_id is NULL
    then
      insert into sec_group_modules
        values (:new.sid,
                :new.group_id,
                v_sec_action.mod_id,
                :new.firma_nr);

    end if;
  end if;


end tr_sec_group_actions_buid;


/
ALTER TRIGGER "TR_SEC_GROUP_ACTIONS_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"d54b0d2bdaf1973ecd034d999a3b9e3a93818dd0","type":"TRIGGER","name":"TR_SEC_GROUP_ACTIONS_BUID","schemaName":"DIRKSPZM32","sxml":""}