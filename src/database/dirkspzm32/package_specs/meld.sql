create or replace 
package DIRKSPZM32.MELD is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  14.09.2005 11:04:31
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  08.06.2010   3.5.1.2     (-BW-)   Erweiterung c_meldung_buchen_ausloes
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */



  -- Public function and procedure declarations
  procedure c_alle_meldungen_gehen(in_sid in varchar2,
                                   in_firma_nr in number,
                                   in_bereich in varchar2,
                                   in_engine_id in number default null);
  procedure alle_meldungen_gehen(in_sid in varchar2,
                                 in_firma_nr in number,
                                 in_bereich in varchar2,
                                 in_engine_id in number default null);

  procedure c_meldung_buchen(in_sid in varchar2,
                             in_firma_nr in number,
                             in_gruppe in number,
                             in_md_ix in number,
                             in_bereich in varchar2,
                             in_status in varchar2,
                             in_hilfstext in varchar2,
                             in_engine_id in number default null);

  procedure c_meldung_buchen_47x(in_sid in varchar2,
                                 in_firma_nr in number,
                                 in_gruppe in number,
                                 in_md_ix in number,
                                 in_bereich in varchar2,
                                 in_status in varchar2,
                                 in_hilfstext in varchar2,
                                 in_engine_id in number default null,
                                 in_param_1 in  varchar2,
                                 in_param_2 in varchar2,
                                 in_typ in varchar2);

 procedure c_meldung_buchen_ausloes(in_sid in varchar2,
                                    in_firma_nr in number,
                                    in_gruppe in number,
                                    in_md_ix in number,
                                    in_bereich in varchar2,
                                    in_status in varchar2,
                                    in_hilfstext in varchar2,
                                    in_engine_id in number default null,
                                    in_md_ausloes_md_id in number default null,
                                    out_md_id out number);

  procedure meldung_buchen(in_sid in varchar2,
                           in_firma_nr in number,
                           in_gruppe in number,
                           in_md_ix in number,
                           in_bereich in varchar2,
                           in_status in varchar2,
                           in_hilfstext in varchar2,
                           in_engine_id in number default null,
                           in_md_ausloes_md_id in number default null,
                           out_md_id out number);

  procedure meldung_buchen_47x(in_sid in varchar2,
                           in_firma_nr in number,
                           in_gruppe in number,
                           in_md_ix in number,
                           in_bereich in varchar2,
                           in_status in varchar2,
                           in_hilfstext in varchar2,
                           in_engine_id in number default null,
                           in_md_ausloes_MD_id in number default null,
                           in_Param_1 varchar2,
                           in_Param_2 varchar2,
                           in_typ in varchar2,
                           out_md_id out number);

  procedure meldung_statistik_gen(in_von_datum     in meldung_daten.md_kommt%type,
                                  in_bis_datum     in meldung_daten.md_kommt%type);

  procedure meldung_statistik_gen_31(in_von_datum     in meldung_daten.md_kommt%type,
                                     in_bis_datum     in meldung_daten.md_kommt%type,
                                     in_sprach_id     in meldung_texte.mt_sprache%type);

  function Meldung_Anzeige_Text(in_text       in meldung_texte.mt_fehlertext%type,
                            in_help_text      in meldung_daten.md_hilfstext%type,
                            in_Param_1        in meldung_daten.md_param_1%type,
                            in_param_2        in meldung_daten.md_param_2%type)
                              return varchar2;


end MELD;
/



-- sqlcl_snapshot {"hash":"980e2f2bdb218051e39149f3dd0da0e3ab2156cf","type":"PACKAGE_SPEC","name":"MELD","schemaName":"DIRKSPZM32","sxml":""}