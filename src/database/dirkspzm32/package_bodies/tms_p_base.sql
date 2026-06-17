create or replace 
package body DIRKSPZM32.tms_p_base is

  v_build_number constant number := 1;
  /*
   *  Build history
   *  date       | version    | info
   *  ---------------------------------------------------------------------------------
   *  27.02.2009 | 3.4.10.1   | (-WK-) package created
   */

  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr   := in_err_nr;
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
    return(v_release_str);
  end;

  function get_version return varchar2 is
  begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
  end;

  procedure get_version_ex(out_rel_major   out number,
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

  /******************************************************************************************************
   * private functions
   ******************************************************************************************************/


  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
  function get_loading_point(in_lgr_platz         in tms_loading_points.lgr_platz%type,
                             in_firma_nr          in tms_loading_points.firma_nr%type,
                             in_sid               in tms_loading_points.sid%type,
                             io_tms_loading_point in out tms_loading_points%rowtype
                            ) return boolean is
    cursor c_tms_loading_points is
      select t.*
        from tms_loading_points t
       where t.lgr_platz = in_lgr_platz
         and t.firma_nr  = in_firma_nr
         and t.sid       = in_sid;
    v_found boolean;
  begin
    open c_tms_loading_points;
    fetch c_tms_loading_points into io_tms_loading_point;
    v_found := c_tms_loading_points%found;
    close c_tms_loading_points;
    return (v_found);
  end;

  function get_kunden_auftr_pos(in_kunden_auftr_pos_id in tms_kunden_auftr_pos.kunden_auftr_pos_id%type,
                                in_firma_nr            in tms_kunden_auftr_pos.firma_nr%type,
                                in_sid                 in tms_kunden_auftr_pos.sid%type,
                                io_kunden_auftr_pos    in out tms_kunden_auftr_pos%rowtype
                               ) return boolean is
    cursor c_kunden_auftr_pos is
      select t.*
        from tms_kunden_auftr_pos t
       where t.kunden_auftr_pos_id = in_kunden_auftr_pos_id
         and t.firma_nr            = in_firma_nr
         and t.sid                 = in_sid;
    v_found boolean;
  begin
    open c_kunden_auftr_pos;
    fetch c_kunden_auftr_pos into io_kunden_auftr_pos;
    v_found := c_kunden_auftr_pos%found;
    close c_kunden_auftr_pos;
    return (v_found);
  end;

  function get_kunden_auftr_pos_by_uix(in_auftrag_nr       in tms_kunden_auftr_pos.auftrag_nr%type,
                                       in_pos_nr           in tms_kunden_auftr_pos.pos_nr%type,
                                       in_upos_nr          in tms_kunden_auftr_pos.upos_nr%type,
                                       in_firma_nr         in tms_kunden_auftr_pos.firma_nr%type,
                                       in_sid              in tms_kunden_auftr_pos.sid%type,
                                       io_kunden_auftr_pos in out tms_kunden_auftr_pos%rowtype
                                      ) return boolean is
    cursor c_kunden_auftr_pos is
      select t.*
        from tms_kunden_auftr_pos t
       where t.auftrag_nr = in_auftrag_nr
         and t.pos_nr     = in_pos_nr
         and t.upos_nr    = in_upos_nr
         and t.firma_nr   = in_firma_nr
         and t.sid        = in_sid;
    v_found boolean;
  begin
    open c_kunden_auftr_pos;
    fetch c_kunden_auftr_pos into io_kunden_auftr_pos;
    v_found := c_kunden_auftr_pos%found;
    close c_kunden_auftr_pos;
    return (v_found);
  end;

end tms_p_base;
/



-- sqlcl_snapshot {"hash":"17d2d5ce38e2ed906d40a0bf598467da5ebfaa78","type":"PACKAGE_BODY","name":"TMS_P_BASE","schemaName":"DIRKSPZM32","sxml":""}