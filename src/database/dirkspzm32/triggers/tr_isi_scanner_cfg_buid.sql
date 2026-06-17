
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_SCANNER_CFG_BUID" 
  before insert or update or delete on DIRKSPZM32.isi_scanner_cfg
  for each row
declare
  v_sc_funk               isi_scanner_funk_cfg%rowtype;
  v_found                 boolean;
  CURSOR c_sc_funk is
    select *
      from isi_scanner_funk_cfg t
     where t.sid = :new.sid
       and t.firma_nr = :new.firma_nr
       and t.scanner_funk_name = :new.scanner_funk_name;
begin
  if not deleting then
    if :new.scanner_funk_name is NULL then
      :new.scanner_funk_name := :new.scanner_name;
    end if;

    OPEN c_sc_funk;
    FETCH c_sc_funk into v_sc_funk;
    v_found := c_sc_funk%FOUND;
    CLOSE c_sc_funk;
  end if;

  if inserting then
    if :new.com_name is not null then

      update isi_com_server cs
         set cs.com_geraet_name = :new.scanner_name,
             cs.com_geraet_typ = 'SCANNER',
             cs.com_computername = nvl(:new.computername, cs.com_computername)
       where cs.sid = :new.sid
         and cs.firma_nr = :new.firma_nr
         and cs.com_name = :new.com_name;
    end if;
    if not v_found
    then
      insert into isi_scanner_funk_cfg
        values (:new.sid,                   -- SID                       VARCHAR2(2) not null,
                :new.firma_nr,              -- FIRMA_NR                  NUMBER not null,
                :new.scanner_funk_name,     -- SCANNER_FUNK_NAME         VARCHAR2(15) not null,
                :new.scanner_prae,          -- SCANNER_FUNK_PRAE         VARCHAR2(15),
                :new.scanner_post,          -- SCANNER_FUNK_POST         VARCHAR2(15),
                decode (:new.scanner_typ,
                        'DRAGON',
                        '<EOT>',
                        NULL),              -- SCANNER_FUNK_DELIMITER    VARCHAR2(15),
                :new.scanner_typ,           -- SCANNER_FUNK_TYP          VARCHAR2(15),
                :new.com_name,              -- COM_NAME                  VARCHAR2(15),
                :new.scanner_visuname,      -- SCANNER_FUNK_VISUNAME     VARCHAR2(15),
                :new.appli_modul,           -- APPLI_MODUL               VARCHAR2(10),

                NULL,                       -- APPLI_FUNKTION            VARCHAR2(10),
                :new.appli_service,         -- APPLI_SERVICE             VARCHAR2(10),
                '<CR>',                     -- SCANNER_FUNK_INIT_STR     VARCHAR2(50),
                NULL,                       -- SCANNER_FUNK_INIT_ANTWORT NUMBER,
                :new.scanner_enabled);      -- SCANNER_FUNK_ENABLED      VARCHAR2(1)
    else

      update isi_scanner_funk_cfg t
         set t.scanner_funk_delimiter = decode (:new.scanner_typ,
                                                'DRAGON', '<EOT>',
                                                NULL),
             t.scanner_funk_prae = :new.scanner_prae,
             t.scanner_funk_post = :new.scanner_post,
             t.scanner_funk_typ = :new.scanner_typ,
             t.com_name = :new.com_name,
             t.appli_modul = :new.appli_modul,
             t.appli_service = :new.appli_service,
             t.scanner_funk_enabled = decode (:new.scanner_typ,
                                              'DRAGON', t.scanner_funk_enabled,
                                              :new.scanner_enabled)
       where t.sid               = :new.sid                   -- SID                       VARCHAR2(2) not null,
         and t.firma_nr          = :new.firma_nr              -- FIRMA_NR                  NUMBER not null,
         and t.scanner_funk_name = :new.scanner_funk_name     -- SCANNER_FUNK_NAME         VARCHAR2(15) not null,
         and t.scanner_funk_name = :new.scanner_name;
    end if;

  elsif updating then
    if not v_found then
      insert into isi_scanner_funk_cfg
        values (:new.sid,                   -- SID                       VARCHAR2(2) not null,
                :new.firma_nr,              -- FIRMA_NR                  NUMBER not null,
                :new.scanner_funk_name,     -- SCANNER_FUNK_NAME         VARCHAR2(15) not null,
                :new.scanner_prae,          -- SCANNER_FUNK_PRAE         VARCHAR2(15),
                :new.scanner_post,          -- SCANNER_FUNK_POST         VARCHAR2(15),
                decode (:new.scanner_typ,
                        'DRAGON',
                        '<EOT>',
                        NULL),              -- SCANNER_FUNK_DELIMITER    VARCHAR2(15),
                :new.scanner_typ,           -- SCANNER_FUNK_TYP          VARCHAR2(15),
                :new.com_name,              -- COM_NAME                  VARCHAR2(15),
                :new.scanner_visuname,      -- SCANNER_FUNK_VISUNAME     VARCHAR2(15),
                :new.appli_modul,           -- APPLI_MODUL               VARCHAR2(10),

                NULL,                       -- APPLI_FUNKTION            VARCHAR2(10),
                :new.appli_service,         -- APPLI_SERVICE             VARCHAR2(10),
                '<CR>',                     -- SCANNER_FUNK_INIT_STR     VARCHAR2(50),
                NULL,                       -- SCANNER_FUNK_INIT_ANTWORT NUMBER,
                :new.scanner_enabled);      -- SCANNER_FUNK_ENABLED      VARCHAR2(1)
    else
      update isi_scanner_funk_cfg t
         set t.scanner_funk_delimiter = decode (t.scanner_funk_delimiter,
                                                NULL,  decode (:new.scanner_typ,
                                                                'DRAGON', '<EOT>',
                                                                NULL),
                                                NULL),
             t.scanner_funk_prae = nvl(:new.scanner_prae, t.scanner_funk_prae),
             t.scanner_funk_post = nvl(:new.scanner_post, t.scanner_funk_post),
             t.scanner_funk_typ = nvl(:new.scanner_typ, t.scanner_funk_typ),
             t.com_name = nvl(:new.com_name, t.com_name),
             t.appli_modul = decode(:old.appli_modul, null, nvl(:new.appli_modul, t.appli_modul), :new.appli_modul),
             t.appli_service = nvl(:new.appli_service, t.appli_service),
             t.scanner_funk_enabled = decode (:new.scanner_typ,
                                              'DRAGON', t.scanner_funk_enabled,
                                              :new.scanner_enabled)
       where t.sid               = :new.sid                   -- SID                       VARCHAR2(2) not null,
         and t.firma_nr          = :new.firma_nr              -- FIRMA_NR                  NUMBER not null,
         and t.scanner_funk_name = :new.scanner_funk_name     -- SCANNER_FUNK_NAME         VARCHAR2(15) not null,
         and t.scanner_funk_name = :new.scanner_name;
    end if;
    if :old.com_name is not null then
      update isi_com_server cs
         set cs.com_geraet_name = NULL,
             cs.com_geraet_typ = NULL
       where cs.sid = :old.sid
         and cs.firma_nr = :old.firma_nr
         and cs.com_name = :old.com_name;
    end if;
    if :new.com_name is not null then
      update isi_com_server cs
         set cs.com_geraet_name = :new.scanner_name,
             cs.com_geraet_typ = 'SCANNER',
             cs.com_computername = nvl(:new.computername, cs.com_computername)
       where cs.sid = :new.sid
         and cs.firma_nr = :new.firma_nr
         and cs.com_name = :new.com_name;
    end if;

    if :new.ls_login_id is NULL then
      isi_message_board.c_send_raw_message('scanner_abmelden', :old.ls_login_id);
      --dbms_alert.signal('scanner_abmelden', :old.ls_login_id);
    else
      isi_message_board.c_send_raw_message('scanner_anmelden', :new.ls_login_id);
      --dbms_alert.signal('scanner_anmelden', :new.ls_login_id);
    end if;
  else
    if :old.scanner_typ != 'DRAGON'
    then
      delete isi_scanner_funk_cfg t
       where t.sid               = :old.sid                   -- SID                       VARCHAR2(2) not null,
         and t.firma_nr          = :old.firma_nr              -- FIRMA_NR                  NUMBER not null,
         and t.scanner_funk_name = :old.scanner_funk_name;    -- SCANNER_FUNK_NAME         VARCHAR2(15) not null,
    end if;
    if :old.com_name is not null then
      update isi_com_server cs
         set cs.com_geraet_name = NULL,
             cs.com_geraet_typ = NULL
       where cs.sid = :old.sid
         and cs.firma_nr = :old.firma_nr
         and cs.com_name = :old.com_name;
    end if;
  end if;
end TR_SCANNER_TOR_CFG_BUID;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_SCANNER_CFG_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"55c22b64abc88532126f150de9dd642089e5d4b8","type":"TRIGGER","name":"TR_ISI_SCANNER_CFG_BUID","schemaName":"DIRKSPZM32","sxml":""}