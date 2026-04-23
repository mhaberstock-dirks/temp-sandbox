create or replace editionable trigger dirkspzm32.tr_s_mfr_auftr_bi before
    insert or update on dirkspzm32.s_mfr_rcv_auftr
    for each row
declare begin
    if inserting then
        if :new.auf_id is null then
            select
                seq_s_auftr.nextval
            into :new.auf_id
            from
                dual;

        end if;

    end if;
end tr_s_diaf_rcv_auftr_biu;
/

alter trigger dirkspzm32.tr_s_mfr_auftr_bi enable;


-- sqlcl_snapshot {"hash":"84cbfddeaf8b95b0a7b38b787fbfa3399ddc4e21","type":"TRIGGER","name":"TR_S_MFR_AUFTR_BI","schemaName":"DIRKSPZM32","sxml":""}