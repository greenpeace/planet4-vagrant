#
class profile::php (
  $version = '7.0'
){

	class{'::php::globals':
		php_version => $version
	}->

	class{'::php':
		manage_repos => true,
    fpm          => true
	}

}
