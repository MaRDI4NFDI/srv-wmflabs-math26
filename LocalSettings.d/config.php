<?php
$srv = $_SERVER['SERVER_NAME'];
if ( preg_match( '/([a-z-]+)\.beta\.(physikerwelt\.de|math\.wmflabs.org)/', $srv, $match ) == 1 ) {
	$wgWBRepoSettings['siteLinkGroups'] = [ 'wikipedia', 'drmfgroup' ];
	$wgWBClientSettings['siteLinkGroups'] = [ 'wikipedia', 'drmfgroup' ];
	$wgLocalDatabases = [ 'wiki_mardi', 'wiki_en' ];
	$wgWBRepoSettings['localClientDatabases'] = array(
    		'mardi' => 'wiki_mardi',
    		'en' => 'wiki_en'
	);
	$wgWBClientSettings['siteGlobalID'] = $match[1];
	if ( $match[1] === 'mardi' ){
		$wgLanguageCode = 'en';
	}
}
