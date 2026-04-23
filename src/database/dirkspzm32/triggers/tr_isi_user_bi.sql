create or replace editionable trigger dirkspzm32.tr_isi_user_bi before
    insert on dirkspzm32.isi_user
    for each row
declare
  -- local variables here
    v_group_id sec_groups.group_id%type;
    cursor c_groups is
    select
        group_id
    from
        sec_groups
    where
            default_group = 'T'
        and sid = :new.sid;

begin
    if :new.sid is null then
        :new.sid := '01';
    end if;

    if :new.firma_nr is null then
        :new.firma_nr := 1;
    end if;

    if :new.login_id is null then
        select
            seq_login_id.nextval
        into :new.login_id
        from
            dual;

    end if;

    open c_groups;
    loop
        fetch c_groups into v_group_id;
        exit when c_groups%notfound;
        insert into sec_user_groups values ( :new.sid,
                                             :new.login_id,
                                             v_group_id,
                                             :new.firma_nr );

    end loop;

    close c_groups;
end tr_isi_user_bi;
/

alter trigger dirkspzm32.tr_isi_user_bi enable;


-- sqlcl_snapshot {"hash":"4fe6c6b8ada2b658df85cb391a9fcaca937f4c83","type":"TRIGGER","name":"TR_ISI_USER_BI","schemaName":"DIRKSPZM32","sxml":""}