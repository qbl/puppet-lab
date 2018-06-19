file { '/tmp/testfile.txt':
  ensure => present,
  mode => '0644',
  replace => true,
  content => 'hello file resource'
}
