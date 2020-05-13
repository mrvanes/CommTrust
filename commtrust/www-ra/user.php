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

$id = restore('id', 0);

$vars['name'] = $cn;

if (!$user) {
    echo $twig->render('error.twig', $vars);
    exit;
}

$unapproved_assertions = find_unapproved_assertions($id);
$approved_assertions = find_approved_assertions($user_id, $id);

$vars['unapproved'] = $unapproved_assertions;
$vars['approved'] = $approved_assertions;
$vars['ra'] = $cn;
$vars['user'] = get_user($id);
$vars['url'] =  $_SERVER['PHP_SELF'];

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('user.twig', $vars);
