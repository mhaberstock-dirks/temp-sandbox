create or replace editionable trigger dirkspzm32.tr_pzm_schicht_perioden_biu before
    insert or update on dirkspzm32.pzm_schicht_perioden
    for each row
declare
    v_sa_name    pzm_schichtarten.sa_name%type;
    v_schichtart pzm_schichtarten%rowtype;
    v_ges_std    pzm_schicht_perioden.sp_ges_std_pro_wo%type;
    cursor c_schicht_art is
    select
        t.*
    from
        pzm_schichtarten t
    where
        t.sa_kurzname = v_sa_name;

begin
    v_ges_std := 0;
    v_sa_name := :new.sp_sa_wot_mo;
    open c_schicht_art;
    fetch c_schicht_art into v_schichtart;
    if c_schicht_art%found then
        v_ges_std := v_ges_std + nvl(v_schichtart.sa_std_pro_tag, 0);
    end if;

    close c_schicht_art;
    v_sa_name := :new.sp_sa_wot_di;
    open c_schicht_art;
    fetch c_schicht_art into v_schichtart;
    if c_schicht_art%found then
        v_ges_std := v_ges_std + nvl(v_schichtart.sa_std_pro_tag, 0);
    end if;

    close c_schicht_art;
    v_sa_name := :new.sp_sa_wot_mi;
    open c_schicht_art;
    fetch c_schicht_art into v_schichtart;
    if c_schicht_art%found then
        v_ges_std := v_ges_std + nvl(v_schichtart.sa_std_pro_tag, 0);
    end if;

    close c_schicht_art;
    v_sa_name := :new.sp_sa_wot_do;
    open c_schicht_art;
    fetch c_schicht_art into v_schichtart;
    if c_schicht_art%found then
        v_ges_std := v_ges_std + nvl(v_schichtart.sa_std_pro_tag, 0);
    end if;

    close c_schicht_art;
    v_sa_name := :new.sp_sa_wot_fr;
    open c_schicht_art;
    fetch c_schicht_art into v_schichtart;
    if c_schicht_art%found then
        v_ges_std := v_ges_std + nvl(v_schichtart.sa_std_pro_tag, 0);
    end if;

    close c_schicht_art;
    v_sa_name := :new.sp_sa_wot_sa;
    open c_schicht_art;
    fetch c_schicht_art into v_schichtart;
    if c_schicht_art%found then
        v_ges_std := v_ges_std + nvl(v_schichtart.sa_std_pro_tag, 0);
    end if;

    close c_schicht_art;
    v_sa_name := :new.sp_sa_wot_so;
    open c_schicht_art;
    fetch c_schicht_art into v_schichtart;
    if c_schicht_art%found then
        v_ges_std := v_ges_std + nvl(v_schichtart.sa_std_pro_tag, 0);
    end if;

    close c_schicht_art;
    :new.sp_ges_std_pro_wo := v_ges_std;
end tr_pzm_schicht_perioden_biu;
/

alter trigger dirkspzm32.tr_pzm_schicht_perioden_biu enable;


-- sqlcl_snapshot {"hash":"a48e2b00544390263f5d9d002011ac9b25e8b61c","type":"TRIGGER","name":"TR_PZM_SCHICHT_PERIODEN_BIU","schemaName":"DIRKSPZM32","sxml":""}