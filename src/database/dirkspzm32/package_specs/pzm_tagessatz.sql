create or replace 
package DIRKSPZM32.PZM_TAGESSATZ is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  28.10.2003 12:53:14
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */


  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;
  /*
	*  Versionsverlauf
	*   - V3.3.2.0: > Einbau der Versionierung
  *               > Flexible Arbeitszeiten eingeführt
  */

  procedure ueberstd_genehmigen(p_pers_nr in number, p_ts_datum in date, p_korr_pers_nr in number);
  procedure ueberstd_stornieren(p_pers_nr in number, p_ts_datum in date, p_korr_pers_nr in number);
  procedure abschliessen(p_pers_nr in number,
                         p_ts_datum in date,
                         p_ueb_std in number,
                         p_korr_std in number,
                         p_flex_std in number,
                         p_korr_pers_nr in number);

  function get_abwes_liste_fuer_tag(p_pers_nr in number,
                                    p_datum in date,
                                    p_spalte in number DEFAULT 1,
                                    p_separator in varchar2 DEFAULT CHR(13)) return varchar2;

end PZM_TAGESSATZ;
/



-- sqlcl_snapshot {"hash":"17f6e3bcd588479eb5a3d96e3e2c9c001f1c931c","type":"PACKAGE_SPEC","name":"PZM_TAGESSATZ","schemaName":"DIRKSPZM32","sxml":""}