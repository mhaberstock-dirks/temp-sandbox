create or replace force editionable view dirkspzm32.meldung_doku_output (
    nr,
    lieferant,
    name,
    details,
    pos_nr
) as
    select
        t.nr,
        t.lieferant,
        t.name,
        t.details,
        stradd_distinct(e.pos_nr) pos_nr
    from
        meldung_cfg     t,
        mfr_element_cfg e
    where
        e.telegr_sps_bereich_nr (+) = t.nr
    group by
        t.nr,
        t.lieferant,
        t.name,
        t.details
    order by
        t.nr;


-- sqlcl_snapshot {"hash":"f6c2a954153a19e10d851717769883eb9bf18ac7","type":"VIEW","name":"MELDUNG_DOKU_OUTPUT","schemaName":"DIRKSPZM32","sxml":""}