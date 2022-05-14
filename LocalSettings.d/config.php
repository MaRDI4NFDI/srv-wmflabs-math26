<?php
$srv = $_SERVER['SERVER_NAME'];
if ( preg_match( '/([a-z-]+)\.beta\.(physikerwelt\.de|math\.wmflabs.org)/', $srv, $match ) == 1 ) {
	
	if ( $match[1] === 'mardi' ){
		$wgLanguageCode = 'en';
	}
	
	$wgWBRepoSettings['siteLinkGroups'] = [ 'wikipedia', 'drmfgroup' ];
	$wgLocalDatabases = [ 'wiki_mardi', 'wiki_en' ];
	$wgWBRepoSettings['localClientDatabases'] = array(
    		'mardi' => 'wiki_mardi',
    		'en' => 'wiki_en'
	);
	$wgWBClientSettings['siteLinkGroups'] = [ 'wikipedia', 'drmfgroup' ];
	$wgWBClientSettings['siteGlobalID'] = $match[1];
	$wgWBClientSettings['repoUrl'] = 'https://mardi.beta.math.wmflabs.org';
	$wgWBClientSettings['repoScriptPath'] = '';
	$wgWBClientSettings['repoArticlePath'] = '/wiki/$1';
	$wgWBClientSettings['repositories']['']['repoDatabase'] = 'wiki_mardi';
	$wgWBClientSettings['repositories']['']['changesDatabase'] = 'wiki_mardi';
}
