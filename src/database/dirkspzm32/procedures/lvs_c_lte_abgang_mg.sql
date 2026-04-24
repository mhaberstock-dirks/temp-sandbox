create or replace procedure dirkspzm32.lvs_c_lte_abgang_mg (
    in_sid      in isi_sid.sid%type,
    in_firma_nr in isi_firma.firma_nr%type,
    in_lte_id   in lvs_lte.lte_id%type,
    in_user_id  in isi_user.login_id%type,
    in_menge    in lvs_lam_bh.menge%type
) is

    result       number;
    v_artikel_id isi_artikel.artikel_id%type;
    v_sysdate    date;
    v_lam_bh     lvs_lam_bh%rowtype;
    cursor c_lam_bh is
    select
        *
    from
        lvs_lam_bh bh
    where
        bh.buch_datum = v_sysdate;

begin
    v_sysdate := sysdate;

  -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
    result := lvs_ausl.lvs_lam_abgang(in_sid, in_firma_nr, v_artikel_id, in_lte_id, null,
                                      null, null, v_sysdate, in_user_id, null,
                                      null, null, null, null, null,
                                      3, null, null, null);

    open c_lam_bh;
    fetch c_lam_bh into v_lam_bh;
    close c_lam_bh;
    update lvs_lam_bh bh
    set
        bh.menge = in_menge
    where
            bh.sid = in_sid
        and bh.firma_nr = in_firma_nr
        and bh.lam_bh_id = v_lam_bh.lam_bh_id;

    commit;
end lvs_c_lte_abgang_mg;
/


-- sqlcl_snapshot {"hash":"bd5727172aef02b90fc35d2ab6dc5da92a310aae","type":"PROCEDURE","name":"LVS_C_LTE_ABGANG_MG","schemaName":"DIRKSPZM32","sxml":""}