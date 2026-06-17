create or replace 
package body DIRKSPZM32.lc is
  /*
	*  Versionsverlauf
	*   - V3.4.0.0: > (-WK-) Package erstellt
  */

  CP_TRENNER constant varchar2(1) := '@';
  PP_TRENNER constant varchar2(1) := '|';

  ------------------------------------------------------------------------------------------------------------------------
  -- Gibt die Version dieses Package zurück
  ------------------------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
  function ec(in_const_name in varchar2) return varchar2 is
  begin
    return in_const_name;
  end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 1 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
  function ec_p1(in_const_name in varchar2,
                 in_p1 in varchar2) return varchar2 is
  begin
    return ec(in_const_name) || CP_TRENNER || '[' || nvl(in_p1, '') || ']';
  end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 2 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
  function ec_p2(in_const_name in varchar2,
                 in_p1 in varchar2,
                 in_p2 in varchar2) return varchar2 is
  begin
    return ec(in_const_name) || CP_TRENNER || '[' || nvl(in_p1, '') || PP_TRENNER
                                                  || nvl(in_p2, '') || ']';
  end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 3 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
  function ec_p3(in_const_name in varchar2,
                 in_p1 in varchar2,
                 in_p2 in varchar2,
                 in_p3 in varchar2) return varchar2 is
  begin
    return ec(in_const_name) || CP_TRENNER || '[' || nvl(in_p1, '') || PP_TRENNER
                                                  || nvl(in_p2, '') || PP_TRENNER
                                                  || nvl(in_p3, '') || ']';
  end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 4 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
  function ec_p4(in_const_name in varchar2,
                 in_p1 in varchar2,
                 in_p2 in varchar2,
                 in_p3 in varchar2,
                 in_p4 in varchar2) return varchar2 is
  begin
    return ec(in_const_name) || CP_TRENNER || '[' || nvl(in_p1, '') || PP_TRENNER
                                                  || nvl(in_p2, '') || PP_TRENNER
                                                  || nvl(in_p3, '') || PP_TRENNER
                                                  || nvl(in_p4, '') || ']';
  end;

  ------------------------------------------------------------------------------------------------------------------------
  -- Baut eine Errorkonstante mit 5 Parameter für raise..., und gibt sie zurück
  ------------------------------------------------------------------------------------------------------------------------
  function ec_p5(in_const_name in varchar2,
                 in_p1 in varchar2,
                 in_p2 in varchar2,
                 in_p3 in varchar2,
                 in_p4 in varchar2,
                 in_p5 in varchar2) return varchar2 is
  begin
    return ec(in_const_name) || CP_TRENNER || '[' || nvl(in_p1, '') || PP_TRENNER
                                                  || nvl(in_p2, '') || PP_TRENNER
                                                  || nvl(in_p3, '') || PP_TRENNER
                                                  || nvl(in_p4, '') || PP_TRENNER
                                                  || nvl(in_p5, '') || ']';
  end;
end lc;
/



-- sqlcl_snapshot {"hash":"095c14abe4c62214e1b303984a245f3fce5d6dd5","type":"PACKAGE_BODY","name":"LC","schemaName":"DIRKSPZM32","sxml":""}