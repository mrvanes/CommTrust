<?php
$ra = false;
$idp = "http://idp1.commtrust.local/simplesaml/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');

$loader = new \Twig\Loader\FilesystemLoader('../templates');
$twig = new \Twig\Environment($loader);

$aid = $_GET['aid'];

$attestations = find_unlocked_attestations($user_id);
foreach ($attestations as $att) {
    $atts[$att['attestation_id']] = $att['name'];
}

$vars['name'] = $cn;

$vars['claims']= find_claims_for_attestation($user_id, $aid);
$vars['attestation'] = $atts[$aid];

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('attestation.twig', $vars);

