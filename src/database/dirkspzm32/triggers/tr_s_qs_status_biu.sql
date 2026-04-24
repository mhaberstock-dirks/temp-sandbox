create or replace editionable trigger dirkspzm32.tr_s_qs_status_biu before
    insert or update on dirkspzm32.s_qs_status
    for each row
declare
    v_lam  lvs_lam%rowtype;
    v_vorg number;
    cursor c_lam is
    select
        *
    from
        lvs_lam t
    where
        t.lte_id = :new.lte_id;

begin
    open c_lam;
    if inserting then
        :new.created_date := nvl(:new.created_date,
                                 sysdate);
        :new.last_change_date := sysdate;
        :new.created_login_id := nvl(:new.created_login_id,
                                     -1);
        :new.last_change_login_id := nvl(:new.last_change_login_id,
                                         :new.created_login_id);

    end if;

    if :new.status = 'N' then
        :new.status := 'ERR';
        loop
            fetch c_lam into v_lam;
            exit when c_lam%notfound;
            lvs_p_lte_lhm.lvs_c_lam_status(v_lam.lam_id,
                                           :new.created_login_id,
                                           v_vorg,
                                           :new.laborstatus,
                                           :new.labortext);

        end loop;

        close c_lam;
        :new.status := 'UE';
    end if;

end tr_s_qs_status_bi;
/

alter trigger dirkspzm32.tr_s_qs_status_biu enable;


-- sqlcl_snapshot {"hash":"28248cb033c2b58dd161e8e769aeabadb67c7c12","type":"TRIGGER","name":"TR_S_QS_STATUS_BIU","schemaName":"DIRKSPZM32","sxml":""}