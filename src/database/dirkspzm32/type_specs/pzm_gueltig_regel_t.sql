create or replace type dirkspzm32.pzm_gueltig_regel_t as object (
        schluessel varchar2(255),  -- generischer Schlüssel (z.B. tarif_name, sa_kurzname, kst_id als String)
        gueltig    number(1)       -- 1 = erlaubt (Allowlist), 0 = gesperrt (Blocklist)
);
/


-- sqlcl_snapshot {"hash":"d6d78d214ed2f144ee6bec1dd6fcf980fc687812","type":"TYPE_SPEC","name":"PZM_GUELTIG_REGEL_T","schemaName":"DIRKSPZM32","sxml":""}