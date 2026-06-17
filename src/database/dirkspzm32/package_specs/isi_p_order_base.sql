create or replace 
package DIRKSPZM32.isi_p_order_base is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  13.10.2006 12:25:36
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  06.12.2013   3.5.7       (-WK-)   New release handling and new functions
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
               3.3.4.0:             Package erstellt
  */

  -------------------------------------------------------------------------------------------------------
  -- Release handling
  -------------------------------------------------------------------------------------------------------
  v_release_major  constant number := 3;
  v_release_minor  constant number := 5;
  v_revision       constant number := 7;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '06.12.2013';
  v_release_str    constant  varchar2(20) := to_char(v_release_major) || '.' ||
                                             to_char(v_release_minor) || '.' ||
                                             to_char(v_revision) || ' / ' ||
                                             v_rev_date;

  -- v_version_str    constant  varchar2(20) := '3.5.7.5 / 21.11.2013';
  function get_release return varchar2;
  function get_version return varchar2;
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2);

  -------------------------------------------------------------------------------------------------------
  -- Public declarations
  -------------------------------------------------------------------------------------------------------

  /* procedure get_order_pos
     Positionsdatensatz eines Auftrags (ISI_ORDER) anhand des
     Primärschlüssels ermitteln und zurückliefern.

     ---- HISTORY ---
     13.10.2006 -WK- Erstellt

     @param in_sid        (optinal) SID ehem. Bestandteil des PK
     @param in_auf_id     Primärschlüssel der Auftragsposition
     @param io_order_pos  Record, in den der geladene Datensatz geschrieben wird

     @returns             True, wenn für den definierten Prümärschlüssel ein Datensatz gefunden wurde. Sonst False.
   */
  function get_order_pos(
    in_sid       in isi_order_pos.sid%type,
    in_auf_id    in isi_order_pos.auf_id%type,
    io_order_pos in out isi_order_pos%rowtype
  ) return boolean;

  /* procedure get_order_be_pos
     Positionsdatensatz eines Bestell-Auftrags (ISI_ORDER, Bestellung)
     anhand des Vorgangs, der Auftragsnummer und der Auftragsposition
     ermitteln und zurückliefern.

     ---- HISTORY ---
     13.10.2006 -WK- Erstellt

     @param in_sid        (optinal) SID ehem. Bestandteil des PK
     @param in_vorgang    Vorgangsnummer der Auftragsposition
     @param in_auftrag    Auftragsnummer der Auftragsposition
     @param in_pos        Positionsnummer der Auftragsposition
     @param io_order_pos  Record, in den der geladene Datensatz geschrieben wird

     @returns             True, wenn für den definierten Prümärschlüssel ein Datensatz gefunden wurde. Sonst False.
   */
  function get_order_be_pos(
    in_sid       in isi_order_pos.sid%type,
    in_vorgang   in isi_order_pos.vorgang_id%type,
    in_auftrag   in isi_order_pos.auftrag%type,
    in_pos       in isi_order_pos.pos_nr%type,
    io_order_pos in out isi_order_pos%rowtype
  ) return boolean;

  /* procedure get_order_pos_by_id_pos_type
     Positionsdatensatz eines Auftrags (ISI_ORDER) anhand des Vorgangs,
     der Vorgangsposition und des Vorgangstyps ermitteln und zurückliefern.

     ---- HISTORY ---
     06.12.2013 -WK- Erstellt

     @param in_vorgang_id   Vorgangsnummer der Auftragsposition
     @param in_vorgang_typ  Vorgangstyp der Auftragsposition
     @param in_vorgang_pos  Positionsnummer der Auftragsposition
     @param io_order_pos    Record, in den der geladene Datensatz geschrieben wird

     @returns               True, wenn für den definierten Prümärschlüssel
                            ein Datensatz gefunden wurde. Sonst False.
   */
  function get_order_pos_by_id_pos_type(
    in_vorgang_id in isi_order_pos.vorgang_id%type,
    in_vorgang_typ in isi_order_pos.vorgang_typ%type,
    in_vorgang_pos in isi_order_pos.vorgang_pos%type,
    io_order_pos in out isi_order_pos%rowtype
  ) return boolean;

  /* procedure get_order_kopf
     Auftragskopf (ISI_ORDER) anhand des Vorgangs, des Vorgangstyps
     und der Lieferschiennummer (PK) ermitteln und zurückliefern.

     ---- HISTORY ---
     13.10.2006 -WK- Erstellt

     @param in_vorgang_id   Vorgangsnummer des Auftragskopfes
     @param in_vorgang_typ  Vorgangtyp des Auftragskopfes
     @param in_li_nr        Lieferscheinnummer des Auftragskopfes
     @param in_firma_nr     (optinal) FirmaNr, ehem. Bestandteil des PK
     @param in_sid          (optinal) SID, ehem. Bestandteil des PK
     @param io_order_kopf   Record, in den der geladene Datensatz geschrieben wird

     @returns             True, wenn für den definierten Prümärschlüssel
                          ein Datensatz gefunden wurde. Sonst False.
   */
  function get_order_kopf(
    in_vorgang_id  in isi_order_kopf.vorgang_id%type,
    in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
    in_li_nr       in isi_order_kopf.li_nr%type,
    in_firma_nr    in isi_order_kopf.firma_nr%type,
    in_sid         in isi_order_kopf.sid%type,
    io_order_kopf  in out isi_order_kopf%rowtype
  ) return boolean;

  --------------------------------------------------------------------------------
  -- function prüft eine eine ISI_ORDER_POS auf Lieferschein, Vorgang_ID und Artikel
  --------------------------------------------------------------------------------
  /*
     Auftragspos (ISI_ORDER) anhand des Vorgangs, des Vorgangstyps
     und der Lieferschiennummer ermitteln und zurückliefern.

     ---- HISTORY ---
     30.10.2018 -HJG- Erstellt

     @param in_vorgang_id   Vorgangsnummer des Auftragskopfes
     @param in_vorgang_typ  Vorgangtyp des Auftragskopfes
     @param in_li_nr        Lieferscheinnummer des Auftragskopfes
     @param in_firma_nr     (optinal) FirmaNr, ehem. Bestandteil des PK
     @param in_sid          (optinal) SID, ehem. Bestandteil des PK
     @param out_order_pos   Record, in den der geladene Datensatz geschrieben wird

     @returns             True, wenn für den definierten Schlüssel
                          ein Datensatz gefunden wurde. Sonst False.
  */
  --******************************************************************************
  function get_order_pos_by_li_nr_artikel(in_sid                 in isi_sid.sid%type,
                                          in_firma_nr            in isi_firma.firma_nr%type,
                                          in_artikel_id          in isi_artikel.artikel_id%type,
                                          in_vorgang_id          in isi_order_kopf.vorgang_id%type,
                                          in_li_nr               in isi_order_kopf.li_nr%type,
                                          out_order_pos_row      out isi_order_pos%rowtype
                                         ) return boolean;

end;
/



-- sqlcl_snapshot {"hash":"b2b8e3846f80c1deb20d5328b529d24fcaaffce2","type":"PACKAGE_SPEC","name":"ISI_P_ORDER_BASE","schemaName":"DIRKSPZM32","sxml":""}