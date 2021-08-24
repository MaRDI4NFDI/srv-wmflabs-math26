<?php
$srv = $_SERVER['SERVER_NAME'];
if ( preg_match( '/([a-z-]+)\.beta\.(physikerwelt\.de|math\.wmflabs.org)/', $srv, $match ) == 1 ) {
	$wgWBRepoSettings['siteLinkGroups'] = [ 'wikipedia', 'drmfgroup' ];
	$wgWBClientSettings['siteGlobalID'] = $match[1];
}
