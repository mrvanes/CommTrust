<?php
$ra = true;
$idp = "http://idp.commtrust.local/simplesaml/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');

$loader = new \Twig\Loader\FilesystemLoader('../templates-ra');
$twig = new \Twig\Environment($loader);

$aid = restore('aid', 0);

$vars['name'] = $cn;

if (!$user) {
    echo $twig->render('error.twig', $vars);
    exit;
}

if ($action == 'approve') {
    $with = isset($_POST['with'])?$_POST['with']:[];
    $with = json_encode($with);
    approve_assertion($aid, $user_id, $with);
}

if ($action == 'disapprove') {
    disapprove_assertion($aid, $user_id);
}

$claim = get_claim_for_assertion($aid);
$vars['claim'] = $claim;
$vars['attestations'] = get_attestations_for_claim($claim['claim_id']);
$vars['url'] =  $_SERVER['PHP_SELF'];
$vars['aid'] = $aid;

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('approve.twig', $vars);
