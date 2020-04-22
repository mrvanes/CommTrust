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

$aid = isset($_GET['aid'])?$_GET['aid']:0;

$r = get_attestation_for_user($aid, $user_id);
$proof = $r['proof'];
$source = $r['source'];
$attestion = new $r['handler']($r['config']);

if ($action=='retract') {
    retract_proof($user_id, $aid);
    $proof = Null;
    $attestion->clear($_SERVER['PHP_SELF'] . "?aid=$aid");
}

$vars = [
    'name' => $uid,
    'user_id' => $user_id,
    'type' => $r['name'],
    'id' => $attestion->get_id()
];

if (!$proof) {
    if ($action == 'start') {
        $attestion->start();

//         echo "Attestation completed<br>\n";
        $proof = json_encode($attestion->get_attributes());
        $source = json_encode($attestion->get_source());
//         echo "A: $attributes<br>\n";
        complete_attestation($user_id, $aid, $proof, $source);

    } else {
//         echo "<a href=" . $_SERVER['PHP_SELF'] . "?aid=$aid&action=start>Start</a> Attestation<br>\n";
    }
} else {
//     echo "Found proof:<br>\nAcquired from $source<br>\n<pre>" . print_r(json_decode($proof), true) . "</pre><br>\n";
//     echo "<a href=" . $_SERVER['PHP_SELF'] . "?aid=$aid&action=retract>Retract</a> proof<br>\n";

}

$vars['proof'] =  print_r(json_decode($proof), true);
$vars['source'] = $source;
$vars['url'] = $_SERVER['PHP_SELF'];
$vars['aid'] = $aid;
$vars['action'] = $action;

// Debug
$vars['delays'] = print_r($Q_DELAY, true);

echo $twig->render('complete.twig', $vars);
