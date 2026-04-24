create or replace editionable trigger dirkspzm32.tr_isi_contact_bi before
    insert on dirkspzm32.isi_contact
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_id       isi_contact.contact_id%type;
begin
    if inserting then
        select
            seq_isi_contact.nextval
        into v_id
        from
            dual;

        :new.contact_id := v_id;
        if :new.create_date is null then
            :new.create_date := sysdate;
        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_isi_contact_bi enable;


-- sqlcl_snapshot {"hash":"516a62b645ac2c557e98e7e7c88641fa793bfffa","type":"TRIGGER","name":"TR_ISI_CONTACT_BI","schemaName":"DIRKSPZM32","sxml":""}