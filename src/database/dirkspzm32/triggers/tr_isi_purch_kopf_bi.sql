create or replace editionable trigger dirkspzm32.tr_isi_purch_kopf_bi before
    insert on dirkspzm32.isi_purch_kopf
    for each row
declare
    v_id isi_purch_kopf.id%type;
begin
    if inserting then
        if :new.id is null then
            select
                seq_isi_purch_kopf.nextval
            into v_id
            from
                dual;

            :new.id := v_id;
        end if;

        if :new.erz_datum is null then
            :new.erz_datum := sysdate;
            :new.aend_datum := sysdate;
        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_isi_purch_kopf_bi enable;


-- sqlcl_snapshot {"hash":"6a80d03e0a955872068e78bb67dfc425def792df","type":"TRIGGER","name":"TR_ISI_PURCH_KOPF_BI","schemaName":"DIRKSPZM32","sxml":""}