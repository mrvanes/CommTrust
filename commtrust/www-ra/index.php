<?php
$ra = true;
$idp = "http://idp.commtrust.local/simplesaml/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');

remove('pid');

$loader = new \Twig\Loader\FilesystemLoader('../templates-ra');
$twig = new \Twig\Environment($loader);

$vars['name'] = $cn;
$vars['url'] = $_SERVER['PHP_SELF'];

if (!$user) {
    echo $twig->render('error.twig', $vars);
    exit();
}

$approved_attestations = find_approved_attestations($user_id, 0);
$unapproved_attestations = find_unapproved_attestations(0);

$vars['approved'] = $approved_attestations;
$vars['unapproved'] = $unapproved_attestations;
$vars['ra'] = $cn;

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('index.twig', $vars);