create or replace 
procedure DIRKSPZM32.pzm_bde_schicht_abmelden(in_pers_nr in number) is
  v_user isi_user%rowtype;
  v_resource_zust_akt isi_resource_zust_akt%rowtype;

  cursor c_user is
    select *
      from isi_user t
     where t.pers_nr = in_pers_nr;

  cursor c_resource_zust_akt is
    select *
      from isi_resource_zust_akt t
     where t.pers_nr = in_pers_nr;

  v_found boolean;
begin
  open c_user;
  fetch c_user into v_user;
  v_found := c_user%found;
  close c_user;

  open c_resource_zust_akt;
  loop
    fetch c_resource_zust_akt into v_resource_zust_akt;
    exit when c_resource_zust_akt%notfound;

    bde_pd_kopf_schicht_e(v_resource_zust_akt.sid,
                          v_resource_zust_akt.firma_nr,
                          v_resource_zust_akt.res_id,
                          in_pers_nr,
                          v_user.login_id);
  end loop;
  close c_resource_zust_akt;

end pzm_bde_schicht_abmelden;
/



-- sqlcl_snapshot {"hash":"ca8c8f0a0592f4e47cc6bb2f4ea012f188fff7f1","type":"PROCEDURE","name":"PZM_BDE_SCHICHT_ABMELDEN","schemaName":"DIRKSPZM32","sxml":""}