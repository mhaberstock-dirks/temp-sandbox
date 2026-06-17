create or replace 
package DIRKSPZM32.lvs_serie is

  /*
  __________________________________________________
  Author    : CMe
  Created   : 04.11.2019 15:27:55
  __________________________________________________
  Description
  Funktionen und Prozeduren für die Verwaltung von Serien
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  04.11.2019   DB31_1      (-CMe-)  Package erstellt mit folgenden Logiken:
                                    - LVS_SERIE_ID_KOPF_ERZEUGEN
                                    - LVS_SERIE_ID_POS_ERZEUGEN
                                    - LVS_C_SERIE_ERZEUGEN
                                    - GET_NEXT_SERIE_ID_BY_FA

                                    Ticket: E20DB-37
  */

  procedure LVS_SERIE_ID_KOPF_ERZEUGEN (in_sid              in lvs_serie_id_kopf.sid%type,
                                        in_firma_nr         in lvs_serie_id_kopf.firma_nr%type,
                                        in_leitzahl         in lvs_serie_id_kopf.leitzahl%type,
                                        in_leitzahl_extern  in lvs_serie_id_kopf.abnr%type,
                                        in_id_maske         in lvs_serie_id_kopf.serie_maske%type,
                                        in_externe_id_maske in lvs_serie_id_kopf.serie_extern_maske%type,
                                        in_start_id         in lvs_serie_id_kopf.serie_start_id%type,
                                        in_start_externe_id in lvs_serie_id_kopf.serie_extern_start_id%type,
                                        in_serie_gen_richtung in lvs_serie_id_kopf.serie_gen_richtung%type,
                                        out_serie_id        out lvs_serie_id_kopf.serie_id%type);

  procedure LVS_SERIE_ID_POS_ERZEUGEN (in_sid      in lvs_serie_id_pos.sid%type,
                                       in_firma_nr in lvs_serie_id_pos.firma_nr%type,
                                       in_serie_id in lvs_serie_id_pos.serie_id%type);

  procedure LVS_C_SERIE_ERZEUGEN (in_sid              in lvs_serie_id_kopf.sid%type,
                                  in_firma_nr         in lvs_serie_id_kopf.firma_nr%type,
                                  in_leitzahl         in lvs_serie_id_kopf.leitzahl%type,
                                  in_leitzahl_extern  in lvs_serie_id_kopf.abnr%type,
                                  in_id_maske         in lvs_serie_id_kopf.serie_maske%type,
                                  in_externe_id_maske in lvs_serie_id_kopf.serie_extern_maske%type,
                                  in_start_id         in lvs_serie_id_kopf.serie_start_id%type,
                                  in_start_externe_id in lvs_serie_id_kopf.serie_extern_start_id%type,
                                  in_serie_gen_richtung in lvs_serie_id_kopf.serie_gen_richtung%type);

  function GET_NEXT_SERIE_NR_BY_FA (in_sid              in lvs_serie_id_kopf.sid%type,
                                    in_firma_nr         in lvs_serie_id_kopf.firma_nr%type,
                                    in_leitzahl         in lvs_serie_id_kopf.leitzahl%type,
                                    in_lam_id           in lvs_lam.lam_id%type,
                                    in_login_id         in lvs_serie_id_pos.last_change_login_id%type) return varchar2;

  function GET_SERIE_NR_EXT_BY_SERIE_NR (in_sid              in lvs_serie_id_kopf.sid%type,
                                         in_firma_nr         in lvs_serie_id_kopf.firma_nr%type,
                                         in_serie_nr         in lvs_serie_id_pos.serie_nr%type) return varchar2;

  procedure RESET_SERIE_NR (in_sid              in lvs_serie_id_kopf.sid%type,
                            in_firma_nr         in lvs_serie_id_kopf.firma_nr%type,
                            in_serie_nr         in lvs_serie_id_pos.serie_nr%type,
                            in_login_id         in lvs_serie_id_pos.last_change_login_id%type);
end lvs_serie;
/



-- sqlcl_snapshot {"hash":"2cc051e867da22a1a57efe4fc78df832519095c7","type":"PACKAGE_SPEC","name":"LVS_SERIE","schemaName":"DIRKSPZM32","sxml":""}