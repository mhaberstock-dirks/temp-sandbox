create or replace editionable trigger dirkspzm32.tr_s_qs_babtec_lte_rcv_bi before
    insert on dirkspzm32.s_qs_babtec_lte_rcv
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
    :new.erstell_datum := nvl(:new.erstell_datum,
                              sysdate);
    :new.bearb_datum := sysdate;
    :new.status := 'ERR';
    loop
        fetch c_lam into v_lam;
        exit when c_lam%notfound;
        lvs_p_lte_lhm.lvs_c_lam_status(v_lam.lam_id,
                                       0,
                                       v_vorg,
                                       :new.laborstatus,
                                       :new.labortext);

    end loop;

    close c_lam;
    :new.status := 'UE';
end;
/

alter trigger dirkspzm32.tr_s_qs_babtec_lte_rcv_bi enable;


-- sqlcl_snapshot {"hash":"93a28c4bf6608187775574111c11b9ac0473b207","type":"TRIGGER","name":"TR_S_QS_BABTEC_LTE_RCV_BI","schemaName":"DIRKSPZM32","sxml":""}