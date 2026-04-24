create or replace package body dirkspzm32.lvs_lager_abrechnung is

    v_build_number constant number := 1;
  /*
  *  Build history
  *  date       | version    | info
  *  ---------------------------------------------------------------------------------
  *  15.03.2012 | 3.5.3   | (-AG-) package created
  */
    v_error exception;
    v_err_nr       number;
    v_err_text     varchar2(255);

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
  -- Private variable declarations

  -- Function and procedure implementations
  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die eingelagert wurden (Im Lagerort)
  -------------------------------------------------------------------------------------*/
    function get_lte_we (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lte_we_m_eti is
        select
            count(sel.lte_id)
        from
            (
                select
                    bh.lte_id
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and ( bh.vorg_typ = 'LZ' )
                    and bh.menge > 0
                    and bh.bus = 4
                    and bh.lhm_id = lhm.lhm_id
                    and bh.lam_id = lam.lam_id
                    and lhm.komm_quell_lte_id is null
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                group by
                    bh.lte_id
                union
                select
                    bh.lte_id
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and ( bh.vorg_typ = 'LZ' )
                    and bh.menge > 0
                    and bh.bus = 4
                    and bh.lhm_id = lhm.lhm_id
                    and bh.lam_id = lam.lam_id
                    and lhm.komm_quell_lte_id is null
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                group by
                    bh.lte_id
            ) sel;

    begin
        v_return := 0;
        open c_get_lte_we_m_eti;
        fetch c_get_lte_we_m_eti into v_return;
        close c_get_lte_we_m_eti;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die ausgelagert wurden und nicht kommissioniert wurden mit
    Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lte_wa (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lte_wa_m_eti is
        select
            count(sel.lte_id)
        from
            (
                select
                    bh.lte_id
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and ( bh.vorg_typ = 'LA' )
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                group by
                    bh.lte_id
                union
                select
                    bh.lte_id
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and ( bh.vorg_typ = 'LA' )
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                group by
                    bh.lte_id
            ) sel;

    begin
        v_return := 0;
        open c_get_lte_wa_m_eti;
        fetch c_get_lte_wa_m_eti into v_return;
        close c_get_lte_wa_m_eti;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die ausgelagert wurden und nicht kommissioniert wurden mit
    Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lte_wa_o_komm_o_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lte_wa_m_eti is
        select
            count(sel.lte_id)
        from
            (
                select
                    bh.lte_id
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and ( bh.vorg_typ = 'LA' )
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and not exists (
                        select
                            lhm.lhm_id
                        from
                            lvs_lhm    lhm,
                            lvs_lam_bh bhx
                        where
                                bhx.lte_id = bh.lte_id
                            and lhm.lhm_id = bhx.lhm_id
                            and lhm.lhm_eti_druck_status = 'V'
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                group by
                    bh.lte_id
                union
                select
                    bh.lte_id
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and ( bh.vorg_typ = 'LA' )
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and not exists (
                        select
                            lhm.lhm_id
                        from
                            lvs_lhm_hist    lhm,
                            lvs_lam_bh_hist bhx
                        where
                                bhx.lte_id = bh.lte_id
                            and lhm.lhm_id = bhx.lhm_id
                            and lhm.lhm_eti_druck_status = 'V'
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                group by
                    bh.lte_id
            ) sel;

    begin
        v_return := 0;
        open c_get_lte_wa_m_eti;
        fetch c_get_lte_wa_m_eti into v_return;
        close c_get_lte_wa_m_eti;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die ausgelagert wurden und nicht kommissioniert wurden ohne
    Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lte_wa_ohne_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lte_wa_o_eti is
        select
            count(sel.lte_id)
        from
            (
                select
                    bh.lte_id
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and ( bh.vorg_typ = 'LA' )
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            lhm.lhm_id
                        from
                            lvs_lhm    lhm,
                            lvs_lam_bh bhx
                        where
                                bhx.lte_id = bh.lte_id
                            and lhm.lhm_id = bhx.lhm_id
                            and lhm.lhm_eti_druck_status = 'V'
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                group by
                    bh.lte_id
                union
                select
                    bh.lte_id
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and ( bh.vorg_typ = 'LA' )
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            lhm.lhm_id
                        from
                            lvs_lhm_hist    lhm,
                            lvs_lam_bh_hist bhx
                        where
                                bhx.lte_id = bh.lte_id
                            and lhm.lhm_id = bhx.lhm_id
                            and lhm.lhm_eti_druck_status = 'V'
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                group by
                    bh.lte_id
            ) sel;

    begin
        v_return := 0;
        open c_get_lte_wa_o_eti;
        fetch c_get_lte_wa_o_eti into v_return;
        close c_get_lte_wa_o_eti;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die ausgelagert und kommissioniert wurden Etikett egal
  -------------------------------------------------------------------------------------*/
    function get_lte_wa_mit_komm (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lte_wa_mit_komm is
        select
            count(sel.lte_id)
        from
            (
                select
                    bh.lte_id
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                group by
                    bh.lte_id
                union
                select
                    bh.lte_id
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                group by
                    bh.lte_id
            ) sel;

    begin
        v_return := 0;
        open c_get_lte_wa_mit_komm;
        fetch c_get_lte_wa_mit_komm into v_return;
        close c_get_lte_wa_mit_komm;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert wurden mit Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_m_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lhm_wa_komm_m_eti is
        select
            count(sel.lhm_id)
             --sel.lhm_id,
             --sel.vorg_typ,
             --sel.lte_id,
             --sel.artikel_id,
             --sel.bbk,
             --sel.menge,
             --sel.lgr_platz
        from
            (
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status != 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                union
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status != 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
            ) sel;

    begin
        v_return := 0;
        open c_get_lhm_wa_komm_m_eti;
        fetch c_get_lhm_wa_komm_m_eti into v_return;
        close c_get_lhm_wa_komm_m_eti;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert wurden Etiketendruck egal
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lhm_wa_komm is
        select
            count(sel.lhm_id)
             --sel.lhm_id,
             --sel.vorg_typ,
             --sel.lte_id,
             --sel.artikel_id,
             --sel.bbk,
             --sel.menge,
             --sel.lgr_platz
        from
            (
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                union
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
            ) sel;

    begin
        v_return := 0;
        open c_get_lhm_wa_komm;
        fetch c_get_lhm_wa_komm into v_return;
        close c_get_lhm_wa_komm;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert wurden mit Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_m_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lhm_wa_komm_m_eti is
        select
            count(sel.lhm_id)
             --sel.lhm_id,
             --sel.vorg_typ,
             --sel.lte_id,
             --sel.artikel_id,
             --sel.bbk,
             --sel.menge,
             --sel.lgr_platz
        from
            (
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status != 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                union
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status != 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
            ) sel;

    begin
        v_return := 0;
        open c_get_lhm_wa_komm_m_eti;
        fetch c_get_lhm_wa_komm_m_eti into v_return;
        close c_get_lhm_wa_komm_m_eti;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert wurden ohne Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_o_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lhm_wa_komm_o_eti is
        select
            count(sel.lhm_id)
             --sel.lhm_id,
             --sel.vorg_typ,
             --sel.lte_id,
             --sel.artikel_id,
             --sel.bbk,
             --sel.menge,
             --sel.lgr_platz
        from
            (
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status = 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                union
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status = 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
            ) sel;

    begin
        v_return := 0;
        open c_get_lhm_wa_komm_o_eti;
        fetch c_get_lhm_wa_komm_o_eti into v_return;
        close c_get_lhm_wa_komm_o_eti;
        return ( v_return );
    end;
  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert ohne umpacken wurden
    Etiketendruck egal
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_oup (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lhm_wa_komm is
        select
            count(sel.lhm_id)
             --sel.lhm_id,
             --sel.vorg_typ,
             --sel.lte_id,
             --sel.artikel_id,
             --sel.bbk,
             --sel.menge,
             --sel.lgr_platz
        from
            (
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lte_id = bh.lte_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                union
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lte_id = bh.lte_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
            ) sel;

    begin
        v_return := 0;
        open c_get_lhm_wa_komm;
        fetch c_get_lhm_wa_komm into v_return;
        close c_get_lhm_wa_komm;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert ohne Umpacken wurden mit
    Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_oup_m_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lhm_wa_komm_m_eti is
        select
            count(sel.lhm_id)
             --sel.lhm_id,
             --sel.vorg_typ,
             --sel.lte_id,
             --sel.artikel_id,
             --sel.bbk,
             --sel.menge,
             --sel.lgr_platz
        from
            (
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status != 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lte_id = bh.lte_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                union
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status != 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lte_id = bh.lte_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
            ) sel;

    begin
        v_return := 0;
        open c_get_lhm_wa_komm_m_eti;
        fetch c_get_lhm_wa_komm_m_eti into v_return;
        close c_get_lhm_wa_komm_m_eti;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert ohne Umpacken wurden
    ohne Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_oup_o_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_get_lhm_wa_komm_o_eti is
        select
            count(sel.lhm_id)
             --sel.lhm_id,
             --sel.vorg_typ,
             --sel.lte_id,
             --sel.artikel_id,
             --sel.bbk,
             --sel.menge,
             --sel.lgr_platz
        from
            (
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh bh,
                    lvs_lgr    lgr,
                    lvs_lhm    lhm,
                    lvs_lam    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status = 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lte_id = bh.lte_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh xbh,
                            lvs_lgr    xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                union
                select
                    bh.lhm_id,
                    bh.vorg_typ,
                    bh.lte_id,
                    bh.artikel_id,
                    lhm.lhm_eti_druck_status bbk,
                    bh.menge,
                    bh.lgr_platz
                from
                    lvs_lam_bh_hist bh,
                    lvs_lgr         lgr,
                    lvs_lhm_hist    lhm,
                    lvs_lam_hist    lam
                where
                        bh.sid = in_sid
                    and bh.firma_nr = in_firma_nr
                    and bh.lhm_id = lhm.lhm_id
                    and lhm.lhm_eti_druck_status = 'V'
                    and ( bh.vorg_typ = 'LA' )
                    and bh.lam_id = lam.lam_id
                    and decode(bh.vorg_typ, 'LA', bh.menge * -1, bh.menge) > 0
                    and bh.bus = 4
                    and bh.lgr_platz = lgr.lgr_platz
                    and ( ';'
                          || in_lgr_ort_liste
                          || ';' like ( '%;'
                                        || to_char(nvl(lgr.lgr_ort, 0)) || ';%' )
                          or in_lgr_ort_liste is null )
                    and bh.buch_datum > in_ausw_start
                    and bh.buch_datum < in_ausw_ende
                    and exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lte_id = bh.lte_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
                    and not exists (
                        select
                            xbh.lhm_id
                        from
                            lvs_lam_bh_hist xbh,
                            lvs_lgr         xlgr
                        where
                                xbh.lam_id = bh.lam_id
                            and xbh.menge > 0
                            and xbh.bus = 6
                            and xlgr.lgr_platz = xbh.lgr_platz
                            and xlgr.lgr_ort = (
                                select
                                    ylgr.lgr_ort
                                from
                                    lvs_lgr ylgr
                                where
                                    ylgr.lgr_platz = bh.lgr_platz
                            )
                    )
            ) sel;

    begin
        v_return := 0;
        open c_get_lhm_wa_komm_o_eti;
        fetch c_get_lhm_wa_komm_o_eti into v_return;
        close c_get_lhm_wa_komm_o_eti;
        return ( v_return );
    end;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die Benutzten Plätze in Tage für Lte-Name
  -------------------------------------------------------------------------------------*/
    function get_lte_platz_tage (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_lte_name      in lvs_lte_cfg.lte_name%type,
        in_lte_status    in lvs_lte.lte_status%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number is

        v_return number;
        cursor c_lvs_bestand is
        select
            sum(nvl(dw.anz_lte, 0)) lte_anz
        from
            dw_lvs_bestand dw
        where
                dw.sid = in_sid
            and dw.firma_nr = in_firma_nr
            and dw.stat_name = 'DW_LTE_TYP_STATUS_IM_LAGER'
            and ( nvl(dw.basis_lte_name, dw.lte_name) = in_lte_name
                  or dw.lte_name = in_lte_name )
            and dw.erfasst_am >= in_ausw_start
            and dw.erfasst_am <= in_ausw_ende
            and ( ';'
                  || in_lte_status
                  || ';' like ( '%;'
                                || dw.lte_status || ';%' )
                  or in_lte_status is null )
            and ( ';'
                  || in_lgr_ort_liste
                  || ';' like ( '%;'
                                || to_char(nvl(dw.lgr_ort, 0)) || ';%' )
                  or in_lgr_ort_liste is null )
        group by
            nvl(dw.basis_lte_name, dw.lte_name);

    begin
        open c_lvs_bestand;
        fetch c_lvs_bestand into v_return;
        close c_lvs_bestand;
        return ( v_return );
    end;

end lvs_lager_abrechnung;
/


-- sqlcl_snapshot {"hash":"f9e34c5ef6373bd8270f19cb0111ad13df1b9a75","type":"PACKAGE_BODY","name":"LVS_LAGER_ABRECHNUNG","schemaName":"DIRKSPZM32","sxml":""}