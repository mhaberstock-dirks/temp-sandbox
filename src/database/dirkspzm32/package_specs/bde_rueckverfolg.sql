create or replace 
package DIRKSPZM32.bde_rueckverfolg is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-HJG-)  09.03.2005
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  *            3.4.4.1     (-HJG-)  Package erstellt
  */

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  v_zeile                bde_pd_rueckverfolgung.abfr_zeile%type; -- Hier wird für die akt. Abfrage die Zeile gespeichert
  v_lam_letzte_id        lvs_lam.lam_id%type;
  v_lam_letzte_id_abgang lvs_lam.lam_id%type;
  v_anz_rueck            number;
  v_max_rueck            number;

  -- Public function and procedure declarations
  function rueckverfolg_create(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_lhm_id      in lvs_lam_bh.lhm_id%type,
                               in_lte_id      in lvs_lte.lte_id%type,
                               in_leitzahl    in lvs_lam_bh.leitzahl%type,
                               in_charge_bez  in lvs_charge.charge_bez%type,
                               in_artikel_id  in lvs_charge.artikel_id%type,
                               in_order_li_nr in isi_order_pos.li_nr%type)
    return number;

  function c_rueckverfolg_create_v2(in_sid         in isi_sid.sid%type,
                                    in_firma_nr    in isi_firma.firma_nr%type,
                                    in_lhm_id      in lvs_lam_bh.lhm_id%type,
                                    in_lte_id      in lvs_lte.lte_id%type,
                                    in_leitzahl    in lvs_lam_bh.leitzahl%type,
                                    in_charge_bez  in lvs_charge.charge_bez%type,
                                    in_artikel_id  in lvs_charge.artikel_id%type,
                                    in_order_li_nr in isi_order_pos.li_nr%type)
    return number;

  function c_rueckverfolg_create(in_sid        in isi_sid.sid%type,
                                 in_firma_nr   in isi_firma.firma_nr%type,
                                 in_lhm_id     in lvs_lam_bh.lhm_id%type,
                                 in_lte_id     in lvs_lte.lte_id%type,
                                 in_leitzahl   in lvs_lam_bh.leitzahl%type,
                                 in_charge_bez in lvs_charge.charge_bez%type,
                                 in_artikel_id in lvs_charge.artikel_id%type)
    return number;

  procedure rueckverfolg_weiter(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_lhm_id      in lvs_lam_bh.lhm_id%type,
                                in_lte_id      in lvs_lte.lte_id%type,
                                in_leitzahl    in lvs_lam_bh.leitzahl%type,
                                in_charge_bez  in lvs_charge.charge_bez%type,
                                in_artikel_id  in lvs_charge.artikel_id%type,
                                in_zeile       in bde_pd_rueckverfolgung.abfr_zeile%type,
                                in_abfr_id     in bde_pd_rueckverfolgung.abfr_id%type);
  function vorwaerts_create(in_sid         in isi_sid.sid%type,
                            in_firma_nr    in isi_firma.firma_nr%type,
                            in_lhm_id      in lvs_lam_bh.lhm_id%type,
                            in_lte_id      in lvs_lte.lte_id%type,
                            in_leitzahl    in lvs_lam_bh.leitzahl%type,
                            in_charge_bez  in lvs_charge.charge_bez%type,
                            in_artikel_id  in lvs_charge.artikel_id%type,
                            in_li_nr_lief  in lvs_lam.li_nr_lief%type)
    return number;

  function c_vorwaerts_create_v2(in_sid         in isi_sid.sid%type,
                                 in_firma_nr    in isi_firma.firma_nr%type,
                                 in_lhm_id      in lvs_lam_bh.lhm_id%type,
                                 in_lte_id      in lvs_lte.lte_id%type,
                                 in_leitzahl    in lvs_lam_bh.leitzahl%type,
                                 in_charge_bez  in lvs_charge.charge_bez%type,
                                 in_artikel_id  in lvs_charge.artikel_id%type,
                                 in_li_nr_lief  in lvs_lam.li_nr_lief%type)
    return number;

  function c_vorwaerts_create(in_sid        in isi_sid.sid%type,
                              in_firma_nr   in isi_firma.firma_nr%type,
                              in_lhm_id     in lvs_lam_bh.lhm_id%type,
                              in_lte_id     in lvs_lte.lte_id%type,
                              in_leitzahl   in lvs_lam_bh.leitzahl%type,
                              in_charge_bez in lvs_charge.charge_bez%type,
                              in_artikel_id in lvs_charge.artikel_id%type)
    return number;

  procedure vorwaerts_weiter(in_sid         in isi_sid.sid%type,
                             in_firma_nr    in isi_firma.firma_nr%type,
                             in_lhm_id      in lvs_lam_bh.lhm_id%type,
                             in_lte_id      in lvs_lte.lte_id%type,
                             in_leitzahl    in lvs_lam_bh.leitzahl%type,
                             in_charge_bez  in lvs_charge.charge_bez%type,
                             in_artikel_id  in lvs_charge.artikel_id%type,
                             in_zeile       in bde_pd_rueckverfolgung.abfr_zeile%type,
                             in_abfr_id     in bde_pd_rueckverfolgung.abfr_id%type);

  function find_lam_bh_buch(in_sid        in isi_sid.sid%type,
                            in_firma_nr   in isi_firma.firma_nr%type,
                            in_lhm_id     in lvs_lam_bh.lhm_id%type,
                            in_lte_id     in lvs_lte.lte_id%type,
                            in_leitzahl   in lvs_lam_bh.leitzahl%type,
                            in_charge_bez in lvs_charge.charge_bez%type,
                            in_artikel_id in lvs_charge.artikel_id%type,
                            in_vorg_type  in bde_pd_prod.vorg_typ%type,
                            in_li_nr_lief   in lvs_lam.li_nr_lief%type,
                            in_order_li_nr  in isi_order_pos.li_nr%type)
    return lvs_lam_bh%rowtype;

  function find_pd_vorgang_id(in_sid         in isi_sid.sid%type,
                              in_firma_nr    in isi_firma.firma_nr%type,
                              in_lhm_id      in lvs_lam_bh.lhm_id%type,
                              in_lte_id      in lvs_lte.lte_id%type,
                              in_leitzahl    in lvs_lam_bh.leitzahl%type,
                              in_charge_bez  in lvs_charge.charge_bez%type,
                              in_artikel_id  in lvs_charge.artikel_id%type,
                              in_li_nr_lief  in lvs_lam.li_nr_lief%type,
                              in_order_li_nr in isi_order_pos.li_nr%type,
                              in_vorg_id     in bde_pd_prod.vorg_id%type,
                              in_out_lam_bh  in out lvs_lam_bh%rowtype,
                              in_vorg_type   in bde_pd_prod.vorg_typ%type,
                              in_test_for_abgang in boolean)
    return number;

  function ret_lam_v(in_sid      in isi_sid.sid%type,
                     in_firma_nr in isi_firma.firma_nr%type,
                     in_lam_id   in lvs_lam.lam_id%type)
    return lvs_lam%rowtype;

  function ret_lam_bh_v(in_sid      in isi_sid.sid%type,
                        in_firma_nr in isi_firma.firma_nr%type,
                        in_lam_id   in lvs_lam.lam_id%type)
    return lvs_lam_bh%rowtype;

  function ret_lam_id_root(in_sid    in isi_sid.sid%type,
                           in_lam_id in lvs_lam.lam_id%type)
    return lvs_lam.lam_id%type;

  procedure get_komm_lte_by_vorgang_id(in_sid        in isi_sid.sid%type,
                                       in_firma_nr   in isi_firma.firma_nr%type,
                                       in_vorgang_id in lvs_lam_bh.vorg_id%type,
                                       in_zeile      in bde_pd_rueckverfolgung.abfr_zeile%type,
                                       in_abfr_id    in bde_pd_rueckverfolgung.abfr_id%type);

  procedure get_pick_lte_by_vorgang_id(in_sid        in isi_sid.sid%type,
                                       in_firma_nr   in isi_firma.firma_nr%type,
                                       in_vorgang_id in lvs_lam_bh.vorg_id%type,
                                       in_zeile      in bde_pd_rueckverfolgung.abfr_zeile%type,
                                       in_abfr_id    in bde_pd_rueckverfolgung.abfr_id%type,
                                       in_put_lte_id in lvs_lam_bh.lte_id%type);

  function ret_lam_bh_pick_by_vorgang_id(in_sid        in isi_sid.sid%type,
                                         in_firma_nr   in isi_firma.firma_nr%type,
                                         in_vorgang_id in lvs_lam_bh.vorg_id%type,
                                         in_put_lte_id in lvs_lam_bh.lte_id%type)
    return lvs_lam_bh%rowtype;

  function ret_lam_bh_v_abgang(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_lte_id      in lvs_lam.lte_id%type,
                               in_lhm_id      in lvs_lam.lhm_id%type,
                               in_lam_id      in lvs_lam_bh.lam_id%type,
                               in_vorg_type   in bde_pd_prod.vorg_typ%type)
    return lvs_lam_bh%rowtype;
end bde_rueckverfolg;
/



-- sqlcl_snapshot {"hash":"5878d7adb519fcf69322e315208048e685122233","type":"PACKAGE_SPEC","name":"BDE_RUECKVERFOLG","schemaName":"DIRKSPZM32","sxml":""}