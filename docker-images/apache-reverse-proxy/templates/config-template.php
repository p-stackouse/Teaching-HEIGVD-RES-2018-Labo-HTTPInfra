<?php 
	$dynamic_app1= getenv("DYNAMIC_APP1");
	$dynamic_app2= getenv("DYNAMIC_APP2");
	$static_app1= getenv("STATIC_APP1");
	$static_app2= getenv("STATIC_APP2");
?>
<VirtualHost *:80>
	ServerName demo.res.ch

	<Proxy "balancer://dynamic_balancer">
    	BalancerMember 'http://<?php print "$dynamic_app1"?>'
    	BalancerMember 'http://<?php print "$dynamic_app2"?>'
	</Proxy>

	<Proxy "balancer://static_balancer">
    	BalancerMember 'http://<?php print "$static_app1"?>'
    	BalancerMember 'http://<?php print "$static_app2"?>'
	</Proxy>


	ProxyPass        '/api/cities/' 'balancer://dynamic_balancer/'
	ProxyPassReverse '/api/cities/' 'balancer://dynamic_balancer/'

	ProxyPass        '/' 'balancer://static_balancer/'
	ProxyPassReverse '/' 'balancer://static_balancer/'

</VirtualHost>