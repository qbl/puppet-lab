notify { 'md5_hash':
  message => md5($facts['fqdn'])
}

$result = "The MD5 hash for the node name is ${md5( $facts['fqdn'] )}"
notify { 'result':
  message => $result
}
