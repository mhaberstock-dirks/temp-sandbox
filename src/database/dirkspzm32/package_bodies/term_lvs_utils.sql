create or replace package body dirkspzm32.term_lvs_utils is

    v_build_number constant number := 1;
  /*
  *  Build history
  *  date       | version    | info
  *  ---------------------------------------------------------------------------------
  *  07.03.2009 | 3.4.10.1   | (-WK-) package created
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

  /******************************************************************************************************
   * private functions
   ******************************************************************************************************/

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
    function check_storage_cell_valid (
        in_scan_data             in varchar2,
        in_expected_storage_cell in lvs_lgr.lgr_platz%type,
        out_found_storage_cell   out lvs_lgr.lgr_platz%type
    ) return number is

        v_result             number;
        v_lgr_platz          lvs_lgr.lgr_platz%type;
        v_lgr_platz_gruppe   lvs_lgr.lgr_platz_gruppe%type;
        v_verf_lgr_platz_csv varchar2(1000);
        cursor c_storage_cells is
        select
            min(t.lgr_platz)                                  lgr_platz,
            stradd_distinct(decode((t.lgr_max_te - t.lgr_akt_te),
                                   0,
                                   null,
                                   decode(t.lte_namen, 'Keine', null, t.lgr_platz))) verf_platz_csv,
            t.lgr_platz_gruppe
        from
            lvs_lgr t,
            (
                select
                    x.*
                from
                    lvs_lgr x
                where
                    x.lgr_platz like in_scan_data || '%'
            )       t1
        where
                t.lgr_platz_gruppe = t1.lgr_platz_gruppe
            and t.lgr_dim_g = t1.lgr_dim_g
            and t.lgr_dim_r = t1.lgr_dim_r
            and t.lgr_dim_p = t1.lgr_dim_p
            and t.lgr_dim_e = t1.lgr_dim_e
        group by
            t.lgr_platz_gruppe;

        cursor c_storage_cells_valid is
        select
            t.column_value
        from
            table ( strsplit(v_verf_lgr_platz_csv, ';') ) t
        order by
            t.column_value;

        cursor c_storage_cells_alt is
        select /*+ INDEX(ix_lvs_lgr_platz_o_punkte) lvs_lgr */
            t.lgr_platz
        from
            lvs_lgr t
        where
            replace(t.lgr_platz, '.') like in_scan_data;

    begin
        v_result := 0;
        out_found_storage_cell := null;
        open c_storage_cells;
        fetch c_storage_cells into
            v_lgr_platz,
            v_verf_lgr_platz_csv,
            v_lgr_platz_gruppe;
        if c_storage_cells%found then
      -- check, if we have more than one result
            fetch c_storage_cells into
                v_lgr_platz,
                v_verf_lgr_platz_csv,
                v_lgr_platz_gruppe;
            v_result := c_storage_cells%rowcount;
            if v_result = 1 then
                if
                    in_expected_storage_cell is not null
                    and ';'
                        || v_verf_lgr_platz_csv
                        || ';' like '%;'
                                    || in_expected_storage_cell
                                    || ';%'
                then
                    out_found_storage_cell := in_expected_storage_cell;
                else
          -- take the first item
                    open c_storage_cells_valid;
                    fetch c_storage_cells_valid into out_found_storage_cell;
                    if not c_storage_cells_valid%found then
                        v_result := 0;
                        out_found_storage_cell := null;
                    end if;

                    close c_storage_cells_valid;
                end if;
            end if;

        end if;

        close c_storage_cells;
        if out_found_storage_cell is null then
      -- if still nothhing found, try to escape '.' from storage cell
      -- sometimes barcodes don't contain '.'
            open c_storage_cells_alt;
            fetch c_storage_cells_alt into out_found_storage_cell;
            if c_storage_cells_alt%found then
                v_result := 1;
            end if;
            close c_storage_cells_alt;
        end if;

        return ( v_result );
    end;

end term_lvs_utils;
/


-- sqlcl_snapshot {"hash":"bf87ba975b2cc50859f27af2e16db22b81944ddd","type":"PACKAGE_BODY","name":"TERM_LVS_UTILS","schemaName":"DIRKSPZM32","sxml":""}