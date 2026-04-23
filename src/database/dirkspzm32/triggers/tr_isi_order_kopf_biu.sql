create or replace editionable trigger dirkspzm32.tr_isi_order_kopf_biu before
    insert or update on dirkspzm32.isi_order_kopf
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_li_nr    isi_order_kopf.li_nr%type;
begin
    if inserting then
        if :new.status is null then
            :new.status := 'N'; -- ab 3.5.2 Status Neu ist 'N' anstatt Null
        end if;

        if
            :new.vorgang_typ = 'WAI'
            and :new.satzart = 'MA'
        then
            if :new.vorgang_id is null then
                select
                    seq_isi_order_ma_lief.nextval
                into v_li_nr
                from
                    dual;

                :new.vorgang_id := v_li_nr;
                :new.li_nr := v_li_nr;
            end if;

            if :new.order_datum is null then
                :new.order_datum := sysdate;
            end if;

            if :new.liefer_datum is null then
                :new.liefer_datum := :new.order_datum;
            end if;

        end if;

    end if;

    if updating then
        if
            :old.status != 'E'
            and :new.status = 'E'  -- Fertig
        then
            :new.fertig_datum := nvl(:new.fertig_datum,
                                     sysdate); -- Wenn Fertigdatum nicht gesetzt, dann jetzt setzen da fertig
        end if;

        if :new.prioritaet != :old.prioritaet then
            update isi_order_pos pos
            set
                pos.prioritaet = :new.prioritaet
            where
                    pos.sid = :new.sid
                and pos.firma_nr = :new.firma_nr
                and pos.vorgang_typ = :new.vorgang_typ
                and pos.vorgang_id = :new.vorgang_id;

        end if;

        if nvl(:new.transport_gruppe,
               0) != nvl(:old.transport_gruppe,
                         0) then
            update isi_order_pos pos
            set
                pos.transport_gruppe = :new.transport_gruppe
            where
                    pos.sid = :new.sid
                and pos.firma_nr = :new.firma_nr
                and pos.vorgang_typ = :new.vorgang_typ
                and pos.vorgang_id = :new.vorgang_id;

        end if;

        if :new.wa_verladepunkt != :old.wa_verladepunkt
        or (
            :old.wa_verladepunkt is null
            and :new.wa_verladepunkt is not null
        ) then
            :new.ziel := :new.wa_verladepunkt;
        end if;

        if :new.ziel != :old.ziel
        or (
            :old.ziel is null
            and :new.ziel is not null
        ) then
            update isi_order_pos pos
            set
                pos.ziel = :new.ziel
            where
                    pos.sid = :new.sid
                and pos.firma_nr = :new.firma_nr
                and pos.vorgang_typ = :new.vorgang_typ
                and pos.vorgang_id = :new.vorgang_id;

        end if;

        if :new.arbeitsplatz_id != :old.arbeitsplatz_id
        or (
            :old.arbeitsplatz_id is null
            and :new.arbeitsplatz_id is not null
        ) then
            update isi_order_pos pos
            set
                pos.arbeitsplatz_id = :new.arbeitsplatz_id
            where
                    pos.sid = :new.sid
                and pos.firma_nr = :new.firma_nr
                and pos.vorgang_typ = :new.vorgang_typ
                and pos.vorgang_id = :new.vorgang_id
                and nvl(pos.arbeitsplatz_id,
                        :new.arbeitsplatz_id + 1) != :new.arbeitsplatz_id
                and ( pos.arbeitsplatz_id = :old.arbeitsplatz_id
                      or pos.arbeitsplatz_id is null );

        end if;

        if
            :new.ziel != :old.ziel
            and :new.satzart not in ( 'MAK', 'LAK', 'LNK' ) -- -AG- In diesem fall bestimmt der Kopf nicht das Ziel aller positionen
        then
            update isi_order_pos pos
            set
                pos.ziel = :new.ziel
            where
                    pos.sid = :new.sid
                and pos.firma_nr = :new.firma_nr
                and pos.vorgang_typ = :new.vorgang_typ
                and pos.vorgang_id = :new.vorgang_id
                and pos.ziel != :new.ziel
                and ( pos.ziel = :old.ziel
                      or pos.ziel is null );

        end if;

        if nvl(:new.lvs_info,
               'nix') != nvl(:old.lvs_info,
                             'nix') then
            update isi_order_pos pos
            set
                pos.lvs_info = :new.lvs_info
            where
                    pos.sid = :new.sid
                and pos.firma_nr = :new.firma_nr
                and pos.vorgang_typ = :new.vorgang_typ
                and pos.vorgang_id = :new.vorgang_id;

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
end tr_isi_order_kopf_bu;
/

alter trigger dirkspzm32.tr_isi_order_kopf_biu enable;


-- sqlcl_snapshot {"hash":"575b22b80b30160fdcaa24e8f64d793e6be75393","type":"TRIGGER","name":"TR_ISI_ORDER_KOPF_BIU","schemaName":"DIRKSPZM32","sxml":""}