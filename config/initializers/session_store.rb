require 'action_dispatch/middleware/session/dalli_store'
# Be sure to restart your server when you modify this file.

Relayfan::Application.config.session_store :dalli_store,:memcache_server => ['localhost'], key: '_Relayfan_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Relayfan::Application.config.session_store :active_record_store
