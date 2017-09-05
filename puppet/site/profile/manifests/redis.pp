class profile::redis {

  class{'::redis':
    bind        => '0.0.0.0',
    manage_repo => true
  }

}
