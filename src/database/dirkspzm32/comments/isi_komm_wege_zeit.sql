comment on table dirkspzm32.isi_komm_wege_zeit is
    'Benötigte Zeit für KOMM-Aufträge von nach Ziel über KOMM-PLatz oder direkt';

comment on column dirkspzm32.isi_komm_wege_zeit.komm_platz_liste is
    'Liste der KOMM-Plätze, über die gefahren wird DT = Direkter Tansport';

comment on column dirkspzm32.isi_komm_wege_zeit.lgr_ort_quelle is
    'Referenz zum Lagerort';

comment on column dirkspzm32.isi_komm_wege_zeit.transp_zeit_sec is
    'Benötigte Zeit in Secunden';

comment on column dirkspzm32.isi_komm_wege_zeit.transp_zeit_sec_add_lte is
    'Zusätzliche zeit je Palette für den Transport';

comment on column dirkspzm32.isi_komm_wege_zeit.ziel_liste is
    'Liste der Ziele (Ziellagerplatz bzw. Ziele im MFR)';


-- sqlcl_snapshot {"hash":"c329a3c11e4667808a7d196bd6398b06b1ac8766","type":"COMMENT","name":"isi_komm_wege_zeit","schemaName":"dirkspzm32","sxml":""}