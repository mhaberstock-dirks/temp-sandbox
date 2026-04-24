comment on table dirkspzm32.rep_view_profiles is
    'stored individual view profiles per report';

comment on column dirkspzm32.rep_view_profiles.chart_setting is
    'NULL = no chart defined to show, ELSE various chart types';

comment on column dirkspzm32.rep_view_profiles.created_by is
    'username who has created this record';

comment on column dirkspzm32.rep_view_profiles.created_date is
    'creation date of this record';

comment on column dirkspzm32.rep_view_profiles.last_change_by is
    'username who has made last change on this record';

comment on column dirkspzm32.rep_view_profiles.last_change_date is
    'last change date of this record';

comment on column dirkspzm32.rep_view_profiles.print_layout_file is
    'NULL = as base configuration, filename for layout file';

comment on column dirkspzm32.rep_view_profiles.print_layout_name is
    'NULL = as base configuration, layoutname within the layout file';

comment on column dirkspzm32.rep_view_profiles.profile_caption is
    'a caption for the profile which the end user can see. if ''C_TXT_...'' is used, the system tries to load the caption from the lang file by this constant'
    ;

comment on column dirkspzm32.rep_view_profiles.rep_id is
    'the report id where this profile belongs to';

comment on column dirkspzm32.rep_view_profiles.rep_view_profile_name is
    'a unique name of a profile within the rep_id';

comment on column dirkspzm32.rep_view_profiles.show_detail_data is
    'NULL = as base configuration, ''T'' = true, ''F'' = false (used in master detail reports)';

comment on column dirkspzm32.rep_view_profiles.show_type is
    '0=stShowDlgNormal, 1=stShowDlgStayOnTop, 2=stShowModal, 3=stShowNormal (analog zu ISIFrame)';

comment on column dirkspzm32.rep_view_profiles.startup_view is
    'NULL = as base configuration, ''T'' = Table, ''P'' = print layout, ''C'' = chart, ''E'' = extension';


-- sqlcl_snapshot {"hash":"5d97dfe8b8e69d912b057a8e3d50cc2dc9b5bd3f","type":"COMMENT","name":"rep_view_profiles","schemaName":"dirkspzm32","sxml":""}