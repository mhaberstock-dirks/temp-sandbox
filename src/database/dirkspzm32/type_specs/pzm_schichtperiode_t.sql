create or replace type dirkspzm32.pzm_schichtperiode_t as object (
        schichtmodellname  varchar2(30),
        wochenr            integer,
        name               varchar2(30),
        wochentag          integer,
        gesamtstundenwoche integer
);
/


-- sqlcl_snapshot {"hash":"b21e0b6c8a5112277d32e6e3147e27f3ef879644","type":"TYPE_SPEC","name":"PZM_SCHICHTPERIODE_T","schemaName":"DIRKSPZM32","sxml":""}