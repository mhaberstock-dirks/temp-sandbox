create or replace editionable trigger dirkspzm32.tr_sec_group_actions_buid before
    insert or update or delete on dirkspzm32.sec_group_actions
    for each row
declare
  -- local variables here
    v_sec_action  sec_action_info%rowtype;
    v_sec_grp_mod sec_group_modules%rowtype;
    cursor c_sec_action is
    select
        *
    from
        sec_action_info t
    where
        t.action_id = :new.action_id;

    cursor c_sec_grp_mod is
    select
        *
    from
        sec_group_modules t
    where
            t.group_id = :new.group_id
        and t.mod_id = v_sec_action.mod_id;

begin
    if inserting then
        open c_sec_action;
        fetch c_sec_action into v_sec_action;
        close c_sec_action;
        v_sec_grp_mod := null;
        open c_sec_grp_mod;
        fetch c_sec_grp_mod into v_sec_grp_mod;
        close c_sec_grp_mod;
        if v_sec_grp_mod.mod_id is null then
            insert into sec_group_modules values ( :new.sid,
                                                   :new.group_id,
                                                   v_sec_action.mod_id,
                                                   :new.firma_nr );

        end if;

    end if;
end tr_sec_group_actions_buid;
/

alter trigger dirkspzm32.tr_sec_group_actions_buid enable;


-- sqlcl_snapshot {"hash":"d5b04470fb9f6a43433e5f0f8866ace516bc4d80","type":"TRIGGER","name":"TR_SEC_GROUP_ACTIONS_BUID","schemaName":"DIRKSPZM32","sxml":""}