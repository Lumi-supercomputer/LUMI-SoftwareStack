function cpar {

    sed -e 's|versionsuffix|version_suffix|' \
        -e 's|docurls|doc_urls|' \
        -e 's|toolchainopts|toolchain_opts|' \
        -e 's|preconfigopts|pre_configure_opts|' \
        -e 's|prebuildopts|pre_build_opts|' \
        -e 's|pretestopts|pre_test_opts|' \
        -e 's|preinstallopts|pre_install_opts|' \
        -e 's|configopts|configure_opts|' \
        -e 's|buildopts|build_opts|' \
        -e 's|testopts|test_opts|' \
        -e 's|installopts|install_opts|' \
        -e 's|postinstallcmds|post_install_cmds|' \
        -e 's|runtest|run_test|' \
        -e 's|sanity_check_commands|sanity_check_cmds|' \
        -e 's|skipsteps|skip_steps|' \
        -e 's|versionprefix|version_prefix|' \
        -e 's|builddependencies|build_deps|' \
        -e 's|osdependencies|os_deps|' \
        -e 's|dependencies|deps|' \
        -e 's|exts_defaultclass|exts_default_class|' \
        -e 's|exts_default_options|exts_default_opts|' \
        -e 's|modaliases|env_mod_aliases|' \
        -e 's|modextrapaths|env_mod_extra_paths|' \
        -e 's|modextravars|env_mod_extra_vars|' \
        -e 's|modluafooter|env_mod_lua_footer|' \
        -e 's|moduleclass|env_mod_category|' \
        -i.bak $1

}
