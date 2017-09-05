class profile::mysql (

  $root_password = lookup(mysql::root_password),
  $databases     = hiera_hash('mysql::databases'),

  ){

  class{ '::mysql::server':
    root_password           => $root_password,
    remove_default_accounts => true,
    override_options        => {
      mysqld => {
        bind-address                        => '0.0.0.0',
        init_connect                        => ["'SET collation_connection=utf8_general_ci'","'SET NAMES utf8'"],
        character-set-server                => 'utf8',
        collation-server                    => 'utf8_general_ci',
        skip-character-set-client-handshake => '1',
        max_allowed_packet                  => '16M',
        innodb_file_per_table               => '1',
        innodb_flush_method                 => 'O_DIRECT',
        innodb_buffer_pool_size             => '1G',
        innodb_buffer_pool_instances        => '1',
        sql_mode                            => 'NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES',
        sort_buffer_size                    => '25M',
        key_buffer_size                     => '4M',
        max_heap_table_size                 => '64M',
        tmp_table_size                      => '64M',
        max_connections                     => '151',
        interactive_timeout                 => '900',
        wait_timeout                        => '900',
      }
    }
  }

  create_resources('mysql::db', $databases)

}
