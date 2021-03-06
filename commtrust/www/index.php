<?php
$ra = false;
$idp = "http://idp1.commtrust.local/simplesaml/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');

remove('aid', 0);
if ($action == 'clear') $search = remove('search', '');
else $search = restore('search', '');

$loader = new \Twig\Loader\FilesystemLoader('../templates');
$twig = new \Twig\Environment($loader);

$vars['name'] = $cn;

$open_claims = find_open_claims($user_id);
$completed_claims = find_completed_claims($user_id);
$approved_claims = find_approved_claims($user_id);
$unlocked = find_unlocked_attestations($user_id);
$locked = find_locked_attestations($user_id);


$vars['logs'] = read_logs($user_id, $last_seen);

$vars['open'] = $open_claims;
$vars['completed'] = $completed_claims;
$vars['approved'] = $approved_claims;
$vars['unlocked'] = $unlocked;
$vars['locked'] = $locked;
$vars['url'] =  $_SERVER['PHP_SELF'];
$vars['search'] =  $search;
$vars['attclaims'] = get_claims_for_attestations();

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('index.twig', $vars);

