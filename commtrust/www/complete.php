<?php
$ra = false;
$idp = "https://idp1.incubator.geant.org/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/handlers.php');
require_once('../lib/login.php');

$loader = new \Twig\Loader\FilesystemLoader('../templates');
$twig = new \Twig\Environment($loader);

$cid = restore('cid', 0);
$completed = restore('completed', false);

$r = get_claim_for_user($user_id, $cid);
$handler = $r['handler'];
$ass_id = $r['assertion_id'];
$evidence = $r['evidence'];
$source = $r['source'];
$proved_at = $r['proved_at'];
$claim = new $handler($r['config']);

if ($action=='retract') {
    $aid = restore('aid', $ass_id);
    retract_evidence($aid);
    $evidence = Null;
    $claim->clear($_SERVER['PHP_SELF']);
}

if ($action=='start') {
    remove('completed');
    $claim->start();
    $evidence = json_encode($claim->get_attributes());
    $source = json_encode($claim->get_source());
    complete_evidence($user_id, $cid, $ass_id, $evidence, $source);
    $completed = restore('completed', true);
    $claim->clear($_SERVER['PHP_SELF']);
}

$vars = [
    'name' => $uid,
    'user_id' => $user_id,
    'type' => $r['name'],
    'id' => $claim->get_id()
];

if ($completed) {
    $vars['completed'] = true;
    remove('completed');
}

$vars['aid'] = $ass_id;
$vars['evidence'] =  $handler::render_evidence(json_decode($evidence, true));
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
