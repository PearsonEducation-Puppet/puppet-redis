# Exec['/usr/bin/apt-get update || true'] -> Package <| |>
# Exec {
#   path => '/usr/bin:/usr/sbin:/bin'
# }

#include redis

class { 'redis':
	conf_bind             => '0.0.0.0',
	conf_maxmemory        => '2500000000', 
	conf_maxmemory_policy => 'allkeys-lru',
}
