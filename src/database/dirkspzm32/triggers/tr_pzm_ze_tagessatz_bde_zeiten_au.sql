create or replace editionable trigger dirkspzm32.tr_pzm_ze_tagessatz_bde_zeiten_au after
    update on dirkspzm32.pzm_ze_tagessatz
    for each row
declare
    v_result number;
begin
    if
        :new.ts_datum < trunc(sysdate)
        and :new.ts_day_wert_ende is not null
    then
        begin
            v_result := pzm_bde_utils.pzm_pers_nr_zeit_fa_buchen(
                in_pers_nr      => :new.ts_pers_nr,
                in_sa_kurz_name => :new.ts_sa_kurzname,
                in_datum_beg    => :new.ts_day_wert_start,
                in_datum_ende   => :new.ts_day_wert_ende -(:new.ts_day_abw_std / 24),
                in_zeit_std     => :new.ts_day_arb_std + :new.ts_day_ueb_std + :new.ts_day_flex_std,
                in_datum        => :new.ts_datum
            );

        exception
            when others then
                null;
        end;

    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_ze_tagessatz_bde_zeiten_au enable;


-- sqlcl_snapshot {"hash":"2564a11d46d5c9e35758eb5d4cf0dd1373920e02","type":"TRIGGER","name":"TR_PZM_ZE_TAGESSATZ_BDE_ZEITEN_AU","schemaName":"DIRKSPZM32","sxml":""}