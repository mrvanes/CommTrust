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

$cid = restore('cid', 0);

$r = get_claim_for_user($cid, $user_id);
$evidence = $r['evidence'];
$source = $r['source'];
$proved_at = $r['proved_at'];
$claim = new $r['handler']($r['config']);

if ($action=='retract') {
    retract_evidence($user_id, $cid);
    $evidence = Null;
    $claim->clear($_SERVER['PHP_SELF']);
}

if (!$evidence) {
    if ($action == 'start') {
        $claim->start();
        $evidence = json_encode($claim->get_attributes());
        $source = json_encode($claim->get_source());
        complete_evidence($user_id, $cid, $evidence, $source);
        $claim->clear($_SERVER['PHP_SELF']);
    }
}

$vars = [
    'name' => $uid,
    'user_id' => $user_id,
    'type' => $r['name'],
    'id' => $claim->get_id()
];

$vars['evidence'] =  json_decode($evidence, true);
$vars['source'] = $source;
$vars['proved_at'] = $proved_at;
$vars['url'] = $_SERVER['PHP_SELF'];
$vars['cid'] = $cid;
$vars['action'] = $action;
$vars['claim'] = $r;
$vars['attestations'] = get_attestations_for_claim($cid);

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('complete.twig', $vars);
