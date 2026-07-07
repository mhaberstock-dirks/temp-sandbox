@env/defaultProperties.sql
-- Kick off Install
prompt "Installing/updating schemas"
@releases/main.changelog.sql

--@utils/recompile.sql
@env/undefineDefaultProperties.sql