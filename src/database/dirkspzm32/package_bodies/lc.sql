create or replace package body dirkspzm32.lc is
  /*
	*  Versionsverlauf
	*   - V3.4.0.0: > (-WK-) Package erstellt
  */

    cp_trenner constant varchar2(1) := '@';
    pp_trenner constant varchar2(1) := '|';

  ------------------------------------------------------------------------------------------------------------------------
  -- Gibt die Version dieses Package zurück
  ------------------------------------------------------------------------------------------------------------------------
    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end get_version;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
    function ec (
        in_const_name in varchar2
    ) return varchar2 is
    begin
        return in_const_name;
    end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 1 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
    function ec_p1 (
        in_const_name in varchar2,
        in_p1         in varchar2
    ) return varchar2 is
    begin
        return ec(in_const_name)
               || cp_trenner
               || '['
               || nvl(in_p1, '')
               || ']';
    end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 2 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
    function ec_p2 (
        in_const_name in varchar2,
        in_p1         in varchar2,
        in_p2         in varchar2
    ) return varchar2 is
    begin
        return ec(in_const_name)
               || cp_trenner
               || '['
               || nvl(in_p1, '')
               || pp_trenner
               || nvl(in_p2, '')
               || ']';
    end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 3 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
    function ec_p3 (
        in_const_name in varchar2,
        in_p1         in varchar2,
        in_p2         in varchar2,
        in_p3         in varchar2
    ) return varchar2 is
    begin
        return ec(in_const_name)
               || cp_trenner
               || '['
               || nvl(in_p1, '')
               || pp_trenner
               || nvl(in_p2, '')
               || pp_trenner
               || nvl(in_p3, '')
               || ']';
    end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 4 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
    function ec_p4 (
        in_const_name in varchar2,
        in_p1         in varchar2,
        in_p2         in varchar2,
        in_p3         in varchar2,
        in_p4         in varchar2
    ) return varchar2 is
    begin
        return ec(in_const_name)
               || cp_trenner
               || '['
               || nvl(in_p1, '')
               || pp_trenner
               || nvl(in_p2, '')
               || pp_trenner
               || nvl(in_p3, '')
               || pp_trenner
               || nvl(in_p4, '')
               || ']';
    end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 5 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
    function ec_p5 (
        in_const_name in varchar2,
        in_p1         in varchar2,
        in_p2         in varchar2,
        in_p3         in varchar2,
        in_p4         in varchar2,
        in_p5         in varchar2
    ) return varchar2 is
    begin
        return ec(in_const_name)
               || cp_trenner
               || '['
               || nvl(in_p1, '')
               || pp_trenner
               || nvl(in_p2, '')
               || pp_trenner
               || nvl(in_p3, '')
               || pp_trenner
               || nvl(in_p4, '')
               || pp_trenner
               || nvl(in_p5, '')
               || ']';
    end;

end lc;
/


-- sqlcl_snapshot {"hash":"9e027355f811aa117f4c646911885e84efc9ce36","type":"PACKAGE_BODY","name":"LC","schemaName":"DIRKSPZM32","sxml":""}