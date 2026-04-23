create or replace function dirkspzm32.bde_c_barcode_buch
/*
  Zu einem Barcode werden Arbeitsgaenge etc. gebucht.
  Die Funktion fuehrt ein Commit durch
  Autor: ?
  ---- HISTORY ---
  21.10.2013 -MM- Kommentare in JavaDoc-Style geändert
  @param in_sid
  @param in_firma_nr
  @param in_barcode
  @param in_res_id
  @param in_ls_login_id
  @param in_menge_a
  @param in_menge_b
  @param in_schrott
  @param in_aufgabe
  @param in_fae_id
  @param in_fae_id_position
  @param out_leitzahl
  @param out_fa_ag
  @param out_fa_upos
  @return 0 Im Fehlerfall
*/ (
    in_sid             in isi_sid.sid%type,
    in_firma_nr        in isi_firma.firma_nr%type,
    in_barcode         in lvs_lte.lte_id%type,
    in_res_id          in isi_resource.res_id%type,
    in_ls_login_id     in isi_user.login_id%type,
    in_menge_a         in lvs_lam.menge%type,
    in_menge_b         in lvs_lam.menge%type,
    in_schrott         in lvs_lam.menge%type,
    in_aufgabe         in varchar2,
    in_fae_id          in bde_pd_prod.fae_id%type,
    in_fae_id_position in bde_pd_prod.fae_id_position%type,
    out_leitzahl       out bde_fa_auftrag.leitzahl%type,
    out_fa_ag          out bde_fa_auftrag.fa_ag%type,
    out_fa_upos        out bde_fa_auftrag.fa_upos%type
) return number is
    v_result number;
begin
    v_result := bde_barcode_buch(in_sid, in_firma_nr, in_barcode, in_res_id, in_ls_login_id,
                                 in_menge_a, in_menge_b, in_schrott, in_aufgabe, in_fae_id,
                                 in_fae_id_position, out_leitzahl, out_fa_ag, out_fa_upos);

    commit;
    return ( v_result );
end bde_c_barcode_buch;
/


-- sqlcl_snapshot {"hash":"dcd8b8fb77b496b13d1fe33c1bdb9fa0df7921c0","type":"FUNCTION","name":"BDE_C_BARCODE_BUCH","schemaName":"DIRKSPZM32","sxml":""}