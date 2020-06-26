<?php
$ra = true;
$idp = "https://idp2.incubator.geant.org/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');

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

$vars['logs'] = read_logs($user_id, $last_seen);
$vars['search'] = $search;

clear_db();

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('cleardb.twig', $vars);
