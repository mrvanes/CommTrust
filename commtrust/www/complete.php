<?php
$ra = false;
$idp = "http://idp1.commtrust.local/simplesaml/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/handlers.php');
require_once('../lib/login.php');

$loader = new \Twig\Loader\FilesystemLoader('../templates');
$twig = new \Twig\Environment($loader);

$aid = restore('aid', 0);

$r = get_attestation_for_user($aid, $user_id);
$proof = $r['proof'];
$source = $r['source'];
$date = $r['date'];
$attestion = new $r['handler']($r['config']);

if ($action=='retract') {
    retract_proof($user_id, $aid);
    $proof = Null;
//     $attestion->clear($_SERVER['PHP_SELF'] . "?aid=$aid");
    $attestion->clear($_SERVER['PHP_SELF']);
}

if (!$proof) {
    if ($action == 'start') {
        $attestion->start();
        $proof = json_encode($attestion->get_attributes());
        $source = json_encode($attestion->get_source());
        complete_attestation($user_id, $aid, $proof, $source);
//         $attestion->clear($_SERVER['PHP_SELF'] . "?aid=$aid");
        $attestion->clear($_SERVER['PHP_SELF']);
    }
}

$vars = [
    'name' => $uid,
    'user_id' => $user_id,
    'type' => $r['name'],
    'id' => $attestion->get_id()
];

$vars['proof'] =  json_decode($proof, true);
$vars['source'] = $source;
$vars['date'] = $date;
$vars['url'] = $_SERVER['PHP_SELF'];
$vars['aid'] = $aid;
$vars['action'] = $action;
$vars['attestation'] = $r;

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('complete.twig', $vars);
