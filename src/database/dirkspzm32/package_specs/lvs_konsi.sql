create or replace package dirkspzm32.lvs_konsi is
  /*
  __________________________________________________
  Author
  wkroeker (-WK-)  21.11.2013
  __________________________________________________
  Description
  Funktionen die zur Verwaltung von Konsignationswaren
  in Konsignationlägern erforderlich sind.
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        Author   Comment
  -----------  ---------   ------   ----------------
  21.11.2013   3.5.7       (-WK-)   package created
  */

  -------------------------------------------------------------------------------------------------------
  -- Release handling
  -------------------------------------------------------------------------------------------------------
    v_release_major constant number := 3;
    v_release_minor constant number := 5;
    v_revision constant number := 7;
  -- the build number is counted in the package body
    v_rev_date constant varchar2(20) := '21.11.2013';
    v_release_str constant varchar2(20) := to_char(v_release_major)
                                           || '.'
                                           || to_char(v_release_minor)
                                           || '.'
                                           || to_char(v_revision)
                                           || ' / '
                                           || v_rev_date;

  -- v_version_str    constant  varchar2(20) := '3.5.7.5 / 21.11.2013';
    function get_release return varchar2;

    function get_version return varchar2;

    procedure get_version_ex (
        out_rel_major   out number,
        out_rel_minor   out number,
        out_revision    out number,
        out_buid_number out number,
        out_rev_date    out varchar2
    );

  -------------------------------------------------------------------------------------------------------
  -- Public declarations
  -------------------------------------------------------------------------------------------------------

  /* procedure c_change_goods_owner
     Eigentümer der Ware auf einer LTE umbuchen.
     Abschließend Transaktion mit 'commit' abschliessen.

     ---- HISTORY ---
     21.11.2013 -WK- Erstellt

     @param in_lte_id           ID der Transporteinheit, deren Eigentümer umgebucht wird
     @param in_owner_address_id NULL = Von KONSI in den verfügbaren Bestand,
                                NOT NULL (gültige Adresse) = Von den verfügbaren in den KONSI Bestand
     @param in_login_id         Benutzer ID des Benutzers der die Buchung ausführt
     @param in_res_id           Resource ID mit der die Buchung ausgeführt wird
   */
    procedure c_change_goods_owner (
        in_lte_id           in lvs_lte.lte_id%type,
        in_owner_address_id in lvs_lam.owner_address_id%type,
        in_login_id         in isi_user.login_id%type,
        in_res_id           in isi_resource.res_id%type
    );

  /* procedure change_goods_owner
     Eigentümer der Ware auf einer LTE umbuchen

     ---- HISTORY ---
     21.11.2013 -WK- Erstellt

     @param in_lte_id           ID der Transporteinheit, deren Eigentümer umgebucht wird
     @param in_owner_address_id NULL = Von KONSI in den verfügbaren Bestand,
                                NOT NULL (gültige Adresse) = Von den verfügbaren in den KONSI Bestand
     @param in_login_id         Benutzer ID des Benutzers der die Buchung ausführt
     @param in_res_id           Resource ID mit der die Buchung ausgeführt wird
   */
    procedure change_goods_owner (
        in_lte_id           in lvs_lte.lte_id%type,
        in_owner_address_id in lvs_lam.owner_address_id%type,
        in_login_id         in isi_user.login_id%type,
        in_res_id           in isi_resource.res_id%type
    );

  /* procedure c_reverse_changed_goods_owner
     Stornierung der Umbuchung des Eigentümers der Ware auf einer LTE.
     Abschließend Transaktion mit 'commit' abschliessen.

     ---- HISTORY ---
     26.11.2013 -WK- Erstellt

     @param in_lte_id           ID der Transporteinheit, deren Eigentümer-Umbuchung storniert werden soll
     @param in_lam_bh_id        ID des Buchungssatzes der Eigentümer-Umbuchung
     @param in_login_id         Benutzer ID des Benutzers der die Buchung ausführt
   */
    procedure c_reverse_changed_goods_owner (
        in_lte_id    in lvs_lte.lte_id%type,
        in_lam_bh_id in lvs_lam_bh.lam_bh_id%type,
        in_login_id  in isi_user.login_id%type
    );

  /* procedure reverse_changed_goods_owner
     Stornierung der Umbuchung des Eigentümers der Ware auf einer LTE.

     ---- HISTORY ---
     26.11.2013 -WK- Erstellt

     @param in_lte_id           ID der Transporteinheit, deren Eigentümer-Umbuchung storniert werden soll
     @param in_lam_bh_id        ID des Buchungssatzes der Eigentümer-Umbuchung
     @param in_login_id         Benutzer ID des Benutzers der die Buchung ausführt
   */
    procedure reverse_changed_goods_owner (
        in_lte_id    in lvs_lte.lte_id%type,
        in_lam_bh_id in lvs_lam_bh.lam_bh_id%type,
        in_login_id  in isi_user.login_id%type
    );

end;
/


-- sqlcl_snapshot {"hash":"d457871089b2c0f8828cf68351c69ba019d9a254","type":"PACKAGE_SPEC","name":"LVS_KONSI","schemaName":"DIRKSPZM32","sxml":""}