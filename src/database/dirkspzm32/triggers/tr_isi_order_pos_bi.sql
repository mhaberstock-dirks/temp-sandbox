create or replace editionable trigger dirkspzm32.tr_isi_order_pos_bi before
    insert on dirkspzm32.isi_order_pos
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

  -- local variables here
    v_art      isi_artikel%rowtype;
    v_found    boolean;
    cursor c_art is
    select
        *
    from
        isi_artikel art
    where
            art.sid = :new.sid
        and art.artikel_id = :new.artikel_id;

begin
    if :new.auf_id is null then
        select
            seq_isi_order.nextval
        into :new.auf_id
        from
            dual;

        begin
            if :new.satzart = 'BE'
            or :new.satzart = 'RK'
            or :new.satzart = 'BK' then
                :new.vorgang_pos := :new.pos_nr;
            else
                select
                    max(nvl(p.vorgang_pos, 0)) + 1
                into :new.vorgang_pos
                from
                    isi_order_pos p
                where
                        p.vorgang_id = :new.vorgang_id
                    and p.vorgang_typ = :new.vorgang_typ
                    and p.satzart = :new.satzart
                group by
                    vorgang_id;

            end if;

        exception
            when others then
                :new.vorgang_pos := 1;
        end;

    end if;

    if :new.status is null then
        :new.status := 'N';  -- ISI_ORDER_POS.STATUS ab V 3.5.2 NULL--> 'N'
    end if;

    open c_art;                         -- Artikeldaten lesen
    fetch c_art into v_art;
    v_found := c_art%found;             -- Artikeldaten gefunden ?
    close c_art;
    if not v_found then
        v_err_nr := 10;
        v_err_text := 'Fehler: Artikeldaten fehlen für Artikel ID <'
                      || nvl(
            to_char(:new.artikel_id),
            'NULL'
        )
                      || '>';

        raise v_error;
    end if;

    :new.mengeneinheit := v_art.mengeneinheit_basis;
    :new.menge_basis := v_art.menge_basis;
    if :new.order_datum is null then
        :new.order_datum := sysdate;
    end if;

    if
        :new.vorgang_typ = 'WAI'
        and :new.satzart = 'MA'
    then
        if :new.liefer_datum is null then
            :new.liefer_datum := :new.order_datum;
        end if;
    end if;

exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;
end;
/

alter trigger dirkspzm32.tr_isi_order_pos_bi enable;


-- sqlcl_snapshot {"hash":"65837bab48433ca4889232a5d8866653c4c33e7a","type":"TRIGGER","name":"TR_ISI_ORDER_POS_BI","schemaName":"DIRKSPZM32","sxml":""}