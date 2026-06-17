create or replace 
function DIRKSPZM32.GET_PERS_ZK_ZUG_LOA(in_pers_nr in pzm_personal.pers_nr%type
                                               ) return varchar2 is

  Result                                       pzm_lohnarten.lz_lohnart%type;
  v_schicht_modell                             pzm_schicht_modelle%rowtype;
  v_lohnart                                    pzm_lohnarten%rowtype;
  CURSOR c_loa is
    select t.*
      from pzm_lohnarten t
     where t.lz_id = (select lz.lz_id
                        from pzm_abwesenheitsarten a,
                             pzm_lohnarten l,
                             pzm_lohnarten lz
                       where a.aa_id = v_schicht_modell.standard_aa_id
                         and l.lz_id = a.lz_id
                         and lz.lz_link_loa_id = l.lz_id);
                              
begin
  if not pzm_p_base.get_schicht_modell(in_pers_nr, v_schicht_modell)
  then
    Result := NULL;
  else
    OPEN c_loa;
    fetch c_loa into v_lohnart;
    CLOSE c_loa;
    result := nvl(v_lohnart.lz_lohnart, pzm_p_base.get_allg_parameter_mandant(in_pers_nr, 'FLEX_STD_ZUGANG_LOA'));
  end if;
  return Result;
exception
  when others then
    return(NULL);
end GET_PERS_ZK_ZUG_LOA;
/



-- sqlcl_snapshot {"hash":"050926d1ac587acb9b55966f1edd42939c23687c","type":"FUNCTION","name":"GET_PERS_ZK_ZUG_LOA","schemaName":"DIRKSPZM32","sxml":""}