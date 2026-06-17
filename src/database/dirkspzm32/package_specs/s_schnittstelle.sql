create or replace 
package DIRKSPZM32.S_SCHNITTSTELLE is

  -- Author  : HJGOEDEKE
  -- Created : 25.07.2004 10:59:06
  -- Purpose :

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  v_send_host_aktiv boolean;

  procedure WRITE_HOST_BEW(in_order_pos   in isi_order_pos%rowtype,
                          in_lam         in lvs_lam%rowtype,
                          in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                          in_lam_bh_bus  in lvs_lam_bh.bus%type,
                          in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                          in_tabelle     in varchar2,
                          in_status      in s_send_bew.status%type,
                          in_quell_lgr   in lvs_lgr%rowtype,
                          in_ziel_lgr    in lvs_lgr%rowtype,
                          in_login_id    in isi_user.login_id%type,
                          in_menge       in number default NULL
                         );

  procedure WRITE_HOST_BEW_MENGE(in_order_pos   in isi_order_pos%rowtype,
                                 in_lam         in lvs_lam%rowtype,
                                 in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                                 in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                 in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                 in_tabelle     in varchar2,
                                 in_status      in s_send_bew.status%type,
                                 in_quell_lgr   in lvs_lgr.lgr_platz%type,
                                 in_ziel_lgr    in lvs_lgr.lgr_platz%type,
                                 in_login_id    in isi_user.login_id%type,
                                 in_menge       in number
                               );

  procedure SEND_HOST_BEW(io_bew    in out s_send_bew%rowtype
                         );

  procedure write_host_platz_lte_update (in_lte      in  lvs_lte%rowtype
                                        );

  procedure WRITE_AUFTR_UPDATE(in_auf_id      in s_rcv_auftr.auf_id%type,
                               in_status      in s_rcv_auftr.status%type,
                               in_lvs_info    in s_rcv_auftr.lvs_info%type,
                               in_ist_menge   in s_rcv_auftr.ist_menge%type
                              );

  function WRITE_HOST_PROD_BEW(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_fa_auftrag  in bde_fa_auftrag%rowtype,
                               in_lam         in lvs_lam%rowtype,
                               in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                               in_lam_bh_bus  in lvs_lam_bh.bus%type,
                               in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                               in_tabelle     in varchar2,
                               in_status      in s_send_bew.status%type
                              ) return number;

  procedure WRITE_HOST_PROD_BEW_MENGE(in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_fa_auftrag  in bde_fa_auftrag%rowtype,
                                      in_lam         in lvs_lam%rowtype,
                                      in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                                      in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                      in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                      in_tabelle     in varchar2,
                                      in_status      in s_send_bew.status%type,
                                      in_menge       in number,
                                      in_login_id    in number
                                    );

  function c_write_mfr_auftrag(in_firma           in     s_mfr_rcv_auftr.FIRMA_NR%type,
                               in_auf_id          in     s_mfr_rcv_auftr.AUF_ID%type,
                               in_satzart         in     s_mfr_rcv_auftr.SATZART%type,
                               in_funktion        in     s_mfr_rcv_auftr.FUNKTION%type,
                               in_auftrag         in     s_mfr_rcv_auftr.AUFTRAG%type,
                               in_lte_id          in     s_mfr_rcv_auftr.LTE_ID%type,
                               in_quelle          in     s_mfr_rcv_auftr.QUELLE%type,
                               in_ziel            in     s_mfr_rcv_auftr.ZIEL%type,
                               in_telegramm       in     s_mfr_rcv_auftr.TELEGRAMM%type)
                               return s_mfr_rcv_auftr.auf_id%type;

  function c_write_mfr_send_offline(in_firma           in     s_mfr_send_offline.FIRMA_NR%type,
                                    in_auf_id          in     s_mfr_send_offline.AUF_ID%type,
                                    in_satzart         in     s_mfr_send_offline.SATZART%type,
                                    in_funktion        in     s_mfr_send_offline.FUNKTION%type,
                                    in_auftrag         in     s_mfr_send_offline.AUFTRAG%type,
                                    in_lte_id          in     s_mfr_send_offline.LTE_ID%type,
                                    in_quelle          in     s_mfr_send_offline.QUELLE%type,
                                    in_ziel            in     s_mfr_send_offline.ZIEL%type,
                                    in_telegramm       in     s_mfr_send_offline.TELEGRAMM%type,
                                    in_gruppe          in     s_mfr_send_offline.gruppe%type)
                                    return s_mfr_send_offline.offline_id%type;

end;
/



-- sqlcl_snapshot {"hash":"234e7c45f83f7e76c18e09053397cd7d6afd2452","type":"PACKAGE_SPEC","name":"S_SCHNITTSTELLE","schemaName":"DIRKSPZM32","sxml":""}