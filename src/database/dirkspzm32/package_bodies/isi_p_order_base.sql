create or replace package body dirkspzm32.isi_p_order_base is
  /*
  __________________________________________________
  Author
  wkroeker (-WK-)  13.10.2006
  __________________________________________________
  Description
  ...
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        Author   Comment
  -----------  ---------   ------   ----------------
  21.11.2013   3.5.7.3     (-WK-)   Header created
  */

    v_build_number constant number := 3;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr       number;
    v_err_text     varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
    procedure raise_isi_error (
        in_err_nr   in number,
        in_err_text in varchar2
    ) is
    begin
        v_err_nr := in_err_nr;
        v_err_text := in_err_text;
        raise v_error;
    end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
    procedure reset_isi_error is
    begin
        v_err_nr := null;
        v_err_text := null;
    end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
    function get_release return varchar2 is
    begin
        return ( v_release_str );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_version return varchar2 is
    begin
        return ( to_char(v_release_major)
                 || '.'
                 || to_char(v_release_minor)
                 || '.'
                 || to_char(v_revision)
                 || '.'
                 || to_char(v_build_number)
                 || ' / ' || v_rev_date );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    procedure get_version_ex (
        out_rel_major   out number,
        out_rel_minor   out number,
        out_revision    out number,
        out_buid_number out number,
        out_rev_date    out varchar2
    ) is
    begin
        out_rel_major := v_release_major;
        out_rel_minor := v_release_minor;
        out_revision := v_revision;
        out_buid_number := v_build_number;
        out_rev_date := v_rev_date;
    end;

  -------------------------------------------------------------------------------------------------------
  -- Function and procedure implementations
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
    function get_order_pos (
        in_sid       in isi_order_pos.sid%type,
        in_auf_id    in isi_order_pos.auf_id%type,
        io_order_pos in out isi_order_pos%rowtype
    ) return boolean is
        v_result boolean;
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos t
        where
            t.auf_id = in_auf_id;

    begin
        open c_order_pos;
        fetch c_order_pos into io_order_pos;
        v_result := c_order_pos%found;
        close c_order_pos;
        return ( v_result );
    end;

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
    function get_order_be_pos (
        in_sid       in isi_order_pos.sid%type,
        in_vorgang   in isi_order_pos.vorgang_id%type,
        in_auftrag   in isi_order_pos.auftrag%type,
        in_pos       in isi_order_pos.pos_nr%type,
        io_order_pos in out isi_order_pos%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_order_pos is
        select
            *
        from
            isi_order_pos t
        where
                t.vorgang_id = in_vorgang
            and t.vorgang_typ = 'WEE'
            and t.auftrag = in_auftrag
            and t.pos_nr = in_pos;

    begin
        open c_order_pos;
        fetch c_order_pos into io_order_pos;
        v_result := c_order_pos%found;
        close c_order_pos;
        return v_result;
    end;

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
    function get_order_pos_by_id_pos_type (
        in_vorgang_id  in isi_order_pos.vorgang_id%type,
        in_vorgang_typ in isi_order_pos.vorgang_typ%type,
        in_vorgang_pos in isi_order_pos.vorgang_pos%type,
        io_order_pos   in out isi_order_pos%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_order_pos is                           -- Lesen der Order-Pos bei Bestellung
        select
            *
        from
            isi_order_pos pos
        where
                pos.vorgang_id = in_vorgang_id
            and pos.vorgang_typ = in_vorgang_typ
            and pos.vorgang_pos = in_vorgang_pos;

    begin
        open c_order_pos;
        fetch c_order_pos into io_order_pos;
        v_result := c_order_pos%found;
        close c_order_pos;
        return v_result;
    end;

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
    function get_order_kopf (
        in_vorgang_id  in isi_order_kopf.vorgang_id%type,
        in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
        in_li_nr       in isi_order_kopf.li_nr%type,
        in_firma_nr    in isi_order_kopf.firma_nr%type,
        in_sid         in isi_order_kopf.sid%type,
        io_order_kopf  in out isi_order_kopf%rowtype
    ) return boolean is

        v_result boolean;
        cursor c_order_kopf is
        select
            *
        from
            isi_order_kopf t
        where
                t.vorgang_id = in_vorgang_id
            and t.vorgang_typ = nvl(in_vorgang_typ, t.vorgang_typ)
            and t.li_nr = in_li_nr;

    begin
        open c_order_kopf;
        fetch c_order_kopf into io_order_kopf;
        v_result := c_order_kopf%found;
        close c_order_kopf;
        return v_result;
    end;

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
    function get_order_pos_by_li_nr_artikel (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_artikel_id     in isi_artikel.artikel_id%type,
        in_vorgang_id     in isi_order_kopf.vorgang_id%type,
        in_li_nr          in isi_order_kopf.li_nr%type,
        out_order_pos_row out isi_order_pos%rowtype
    ) return boolean is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
    -------------------------------------------------------------------------------------------------------

        v_found    boolean;
        cursor c_order_pos is
        select
            op.*
        from
            isi_order_pos op
        where
                op.sid = in_sid
            and op.firma_nr = in_firma_nr
            and op.vorgang_id = in_vorgang_id
            and op.li_nr = in_li_nr
            and op.artikel_id = in_artikel_id;

    begin
        v_err_nr := null;
        open c_order_pos;
        fetch c_order_pos into out_order_pos_row;
        v_found := c_order_pos%found;
        close c_order_pos;
        return v_found;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt
        when v_error then
            rollback;
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            rollback;
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;

    end;

end;
/


-- sqlcl_snapshot {"hash":"00332b08196620ebcc97222dcb13d53433f1ca28","type":"PACKAGE_BODY","name":"ISI_P_ORDER_BASE","schemaName":"DIRKSPZM32","sxml":""}