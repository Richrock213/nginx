class exercise(
) {
	class { 'nginx': }

	file { 'github key':
		path	=> '/home/ec2-user/.ssh/github.key',
		source	=> 'puppet:///modules/exercise/github.key',
		owner	=> 'ec2-user',
		group	=> 'ec2-user',
		mode	=> 0600,
		before	=> Vcsrepo['/var/www/exercise-webpage'],
	}

	file { 'ssh config':
		path	=> '/home/ec2-user/.ssh/config',
		source	=> 'puppet:///modules/exercise/ssh_config',
		owner	=> 'ec2-user',
		group	=> 'ec2-user',
		before	=> Vcsrepo['/var/www/exercise-webpage'],
	}	

	file { "/var/www/exercise-webpage":
		ensure	=> directory,
		owner	=> 'ec2-user',
		group	=> 'ec2-user',
	}

	vcsrepo { "/var/www/exercise-webpage":
		ensure   => latest,
		provider => git,
		source	=> 'git@github.com:puppetlabs/exercise-webpage.git',
		owner	=> 'ec2-user',
		user	=> 'ec2-user',
		require	=> File['/var/www/exercise-webpage'],
	}
	
	nginx::resource::vhost { 'exercise-webpage':
		www_root 	=> '/var/www/exercise-webpage',
		listen_port	=> 8000,
		require		=> Vcsrepo['/var/www/exercise-webpage'],	
		owner		=> 'ec2-user',
		group		=> 'ec2-user',
		mode		=> 0644,
		server_name	=> [$ipaddress_eth0],
	}
}
