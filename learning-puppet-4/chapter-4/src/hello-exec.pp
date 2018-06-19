exec { 'echo-hello-exec':
  path => ['/bin'],
  cwd => '/tmp',
  command => 'echo "hello exec" > testfile.txt',
  creates => '/tmp/testfile.txt',
  returns => [0],
  logoutput => on_failure
}
