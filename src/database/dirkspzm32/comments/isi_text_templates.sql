comment on table dirkspzm32.isi_text_templates is
    'Textbausteine für unterschiedliche Kategorien/Module';

comment on column dirkspzm32.isi_text_templates.created_by_login_id is
    'Login ID of the user created the record';

comment on column dirkspzm32.isi_text_templates.created_date is
    'Creation date and time of the record';

comment on column dirkspzm32.isi_text_templates.language_code is
    'ISO 639-1 language code of the text template (two letter, lowercase)';

comment on column dirkspzm32.isi_text_templates.last_modified_by_login_id is
    'Login ID of the user who made last modifications on this record';

comment on column dirkspzm32.isi_text_templates.last_modified_date is
    'Last modification date and time of the record';

comment on column dirkspzm32.isi_text_templates.tags is
    'Free list of tags to help index full text search routines';

comment on column dirkspzm32.isi_text_templates.template_name is
    'Name or description of the text template to identify it e. g. in a lookup combobox';

comment on column dirkspzm32.isi_text_templates.text_category is
    'Category / Module for isolation of different target systems (WM, MM, PD, HR)';

comment on column dirkspzm32.isi_text_templates.text_group is
    'Individual grouping of text templates';

comment on column dirkspzm32.isi_text_templates.text_template is
    'Text template content as ascii characters / strings (not rich text)';

comment on column dirkspzm32.isi_text_templates.text_template_id is
    'Unique ID (GUID/UUID) of the text template';


-- sqlcl_snapshot {"hash":"e368b90cda691d5e4c61b520c056ce9fb25619f0","type":"COMMENT","name":"isi_text_templates","schemaName":"dirkspzm32","sxml":""}