create or replace editionable trigger dirkspzm32.tr_isi_order_kopf_bd before
    delete on dirkspzm32.isi_order_kopf
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr    number;
    v_err_text  varchar2(255);
    v_order_pos isi_order_pos%rowtype;
    cursor c_order_pos is
    select
        t.*
    from
        isi_order_pos t
    where
            t.sid = :old.sid
        and t.vorgang_typ = :old.vorgang_typ
        and t.vorgang_id = :old.vorgang_id
        and ( nvl(t.li_nr, -1) = nvl(:old.li_nr,
                                     -1)
              or ( t.satzart != 'LI'
                   and :old.li_nr is null ) );

    v_found     boolean;
    v_result    number;
    v_lte_id    lvs_lte.lte_id%type;
    v_auf_id    lvs_lte.order_auf_id%type;
    cursor c_lte is
    select
        t.lte_id,
        t.order_auf_id
    from
        lvs_lte t
    where
        t.order_vorgang_id = :old.vorgang_id;

begin
    delete isi_komm_order t
    where
        t.vorgang_id = :old.vorgang_id;

    open c_lte;
    fetch c_lte into
        v_lte_id,
        v_auf_id;
    loop
        exit when c_lte%notfound;
        v_result := lvs_ausl.lvs_lte_res_rueck(:old.sid,
                                               :old.firma_nr,
                                               :old.vorgang_id,
                                               v_auf_id,
                                               v_lte_id,
                                               :old.vorgang_id,
                                               null,
                                               c.c_true);

        fetch c_lte into
            v_lte_id,
            v_auf_id;
    end loop;

    close c_lte;
    open c_order_pos;
    fetch c_order_pos into v_order_pos;
    v_found := c_order_pos%found;
    close c_order_pos;
    if v_found then
        v_err_nr := 10;
        v_err_text := 'Der Datensatz mit der VorgangID '
                      || :old.vorgang_id
                      || ' kann nicht gelöscht werden, '
                      || 'da noch Positionen vorhanden sind! Es müssen erst alle Positionen gelöscht werden.';
        raise v_error;
    end if;

    update lvs_lte lte
    set
        lte.order_vorgang_id = null,
        lte.order_auf_id = null
    where
        lte.order_vorgang_id = :old.vorgang_id;

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
end tr_isi_order_kopf_bd;
/

alter trigger dirkspzm32.tr_isi_order_kopf_bd enable;


-- sqlcl_snapshot {"hash":"54a5315b53effbe49f969c91d922be14c7f538fd","type":"TRIGGER","name":"TR_ISI_ORDER_KOPF_BD","schemaName":"DIRKSPZM32","sxml":""}