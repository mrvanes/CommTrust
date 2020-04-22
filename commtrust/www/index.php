<?php
$ra = false;
$idp = "http://idp1.commtrust.local/simplesaml/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');

$loader = new \Twig\Loader\FilesystemLoader('../templates');
$twig = new \Twig\Environment($loader);

$vars['name'] = $cn;

$open_attestations = find_open_attestations($user_id);
$completed_attestations = find_completed_attestations($user_id);

$vars['open'] = $open_attestations;
$vars['completed'] = $completed_attestations;

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
echo $twig->render('index.twig', $vars);

