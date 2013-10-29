/*

== Definition: archive

Download and extract an archive.

Parameters:

- *$url:
- *$target: Destination directory
- *$checksum: Default value "true"
- *$digest_url: Default value ""
- *$digest_string: Default value ""
- *$digest_type: Default value "md5"
- *$src_target: Default value "/usr/src"
- *$root_dir: Default value ""
- *mk_root_dir: Creates ${root_dir} under ${target}. This useful for use in conjunction with $strip_leader or with archives that have no leading/root directory in the path. Default value false
- *$extension: Default value ".tar.gz"
- *$timeout: Default value 120
- *$allow_insecure: Default value false
- *$follow_redirects: TODO : missing documentation from upstream
- *$strip_leader: Strips the leading component of the extracted path (works with tar archives). Default value false
- *$version: Version of the archive.  This is used to determine whether to redeploy an archive. Default value ${name}

Example usage:

  archive {"apache-tomcat-6.0.26":
    ensure => present,
    url    => "http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.26/bin/apache-tomcat-6.0.26.tar.gz",
    target => "/opt",
  }

*/
define archive (
  $url,
  $target,
  $ensure=present,
  $checksum=true,
  $digest_url='',
  $digest_string='',
  $digest_type='md5',
  $timeout=120,
  $root_dir='',
  $mk_root_dir=false,
  $extension='tar.gz',
  $src_target='/usr/src',
  $allow_insecure=false,
  $follow_redirects=false,
  $strip_leader=false,
  $version=$name,
) {

  # TODO : add user/group targets for extracted contents of archive
  archive::download {"${name}.${extension}":
    ensure           => $ensure,
    url              => $url,
    checksum         => $checksum,
    digest_url       => $digest_url,
    digest_string    => $digest_string,
    digest_type      => $digest_type,
    timeout          => $timeout,
    src_target       => $src_target,
    allow_insecure   => $allow_insecure,
    follow_redirects => $follow_redirects,
  }

  archive::extract {$name:
    ensure       => $ensure,
    target       => $target,
    src_target   => $src_target,
    root_dir     => $root_dir,
    mk_root_dir  => $mk_root_dir,
    extension    => $extension,
    strip_leader => $strip_leader,
    version      => $version,
    timeout      => $timeout,
    require      => Archive::Download["${name}.${extension}"]
  }
}
