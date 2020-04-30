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

$pid = restore('pid', 0);

$vars['name'] = $cn;

if (!$user) {
    echo $twig->render('error.twig', $vars);
    exit();
}

if ($action == 'approve') {
    approve_attestation($pid, $user_id);
}

if ($action == 'disapprove') {
    disapprove_attestation($pid, $user_id);
}

$vars['attestation'] = get_attestation_for_proof($pid);
$vars['url'] =  $_SERVER['PHP_SELF'];
$vars['pid'] = $pid;

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
echo $twig->render('approve.twig', $vars);
