create or replace editionable trigger dirkspzm32.tr_s_qs_babtec_art_rcv_biu before
    insert or update on dirkspzm32.s_qs_babtec_art_rcv
    for each row
declare begin
    update s_rcv_artikel art
    set                                                       -- ARTIKEL              VARCHAR2(20) not null,
        art.artikel_p1 = :new.artikel_p1                    -- Prüftext aus QS
    where
        art.artikel = :new.artikel;

end;
/

alter trigger dirkspzm32.tr_s_qs_babtec_art_rcv_biu enable;


-- sqlcl_snapshot {"hash":"aa955a5b5f76e1209c9522e4c9871f0a4a877b68","type":"TRIGGER","name":"TR_S_QS_BABTEC_ART_RCV_BIU","schemaName":"DIRKSPZM32","sxml":""}