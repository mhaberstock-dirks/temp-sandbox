create or replace editionable trigger dirkspzm32.tr_isi_projekt_bi before
    insert on dirkspzm32.isi_project
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_id       isi_purch_kopf.id%type;
begin
    if inserting then
        if :new.create_date is null then
            :new.create_date := sysdate;
        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_isi_projekt_bi enable;


-- sqlcl_snapshot {"hash":"299993b81225c2b1a4ea99481e843c888ea98af9","type":"TRIGGER","name":"TR_ISI_PROJEKT_BI","schemaName":"DIRKSPZM32","sxml":""}