<?php 
	$dynamic_app1= getenv("DYNAMIC_APP1");
	$dynamic_app2= getenv("DYNAMIC_APP2");
	$static_app1= getenv("STATIC_APP1");
	$static_app1= getenv("STATIC_APP2");
?>
<VirtualHost *:80>
	ServerName demo.res.ch

	ProxyPass 			'/api/students/' 'http://<?php print "$dynamic_app"?>/'
	ProxyPassReverse 	'/api/students/' 'http://<?php print "$dynamic_app"?>/'

	ProxyPass 			'/' 'http://<?php print "$static_app"?>/'
	ProxyPassReverse 	'/' 'http://<?php print "$static_app"?>/'
</VirtualHost>