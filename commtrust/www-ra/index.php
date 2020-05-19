<?php
$ra = true;
$idp = "http://idp.commtrust.local/simplesaml/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');

remove('aid', 0);
if ($action == 'clear') $search = remove('search', '');
$search = restore('search', '');

$loader = new \Twig\Loader\FilesystemLoader('../templates-ra');
$twig = new \Twig\Environment($loader);

$vars['name'] = $cn;
$vars['url'] = $_SERVER['PHP_SELF'];

if (!$user) {
// Debug
    $vars['delays'] = print_r($Q_DELAY, true);
    $vars['post'] = print_r($_POST, true);
    $vars['get'] = print_r($_GET, true);
    $vars['session'] = print_r($_SESSION, true);
    echo $twig->render('error.twig', $vars);
    exit();
}

$approved_assertions = find_approved_assertions($user_id, $search);
$unapproved_assertions = find_unapproved_assertions($search);

$vars['approved'] = $approved_assertions;
$vars['unapproved'] = $unapproved_assertions;
$vars['ra'] = $cn;
$vars['search'] = $search;

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('index.twig', $vars);
