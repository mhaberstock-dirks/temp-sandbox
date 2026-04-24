create or replace editionable trigger dirkspzm32.tr_s_erp_rcv_fa_auf_res_buid before
    insert or update or delete on dirkspzm32.s_erp_rcv_fa_auf_res
    for each row
declare
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(2550);
    v_res      isi_resource%rowtype;
    v_fa_res   s_rcv_fa_auf_res%rowtype;
    v_found    boolean;
    cursor c_fa_res is
    select
        *
    from
        s_rcv_fa_auf_res t
    where
            t.sid = '01'
        and t.firma_nr = :new.firma_nr
        and t.leitzahl = :new.leitzahl
        and t.fa_ag = :new.fa_ag
        and t.fa_upos = :new.fa_upos
        and t.satzart = :new.satzart
        and t.res_id = v_res.res_id;

begin
    if inserting
    or updating then
        if not isi_p_base.get_resource_by_ext_name(:new.maschine,
                                                   v_res) then
            v_err_nr := 10;
            v_err_text := 'Maschine '
                          || :new.maschine
                          || ' nicht konfiguriert';
            raise v_error;
        end if;

        open c_fa_res;
        fetch c_fa_res into v_fa_res;
        v_found := c_fa_res%found;
        close c_fa_res;
        if not v_found then
            begin
                insert into s_rcv_fa_auf_res values ( '01',
                                                      :new.firma_nr,
                                                      :new.auf_id,
                                                      :new.auftrag,
                                                      :new.leitzahl,
                                                      :new.fa_ag,
                                                      :new.fa_upos,
                                                      :new.satzart,
                                                      v_res.res_id,
                                                      :new.minuten,
                                                      :new.minuten_ruesten );

                return;
            exception
                when dup_val_on_index then
                    null;
            end;
        end if;

        update s_rcv_fa_auf_res t
        set
            t.minuten = :new.minuten,
            t.minuten_ruesten = :new.minuten_ruesten
        where
                t.sid = '01'
            and t.firma_nr = :new.firma_nr
            and t.leitzahl = :new.leitzahl
            and t.fa_ag = :new.fa_ag
            and t.fa_upos = :new.fa_upos
            and t.satzart = :new.satzart
            and t.res_id = v_res.res_id;

    end if;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
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
end tr_s_erp_rcv_fa_auf_res_buid;
/

alter trigger dirkspzm32.tr_s_erp_rcv_fa_auf_res_buid enable;


-- sqlcl_snapshot {"hash":"c38a2e8d248c071fb6a3e0afb1845cc672429719","type":"TRIGGER","name":"TR_S_ERP_RCV_FA_AUF_RES_BUID","schemaName":"DIRKSPZM32","sxml":""}