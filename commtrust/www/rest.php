<?php
$ra = false;
$idp = "https://idp1.incubator.geant.org/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');

$user_id = $_GET['id'];

$open_claims = find_open_claims($user_id);
$completed_claims = find_completed_claims($user_id);
$approved_claims = find_approved_claims($user_id);
$unlocked = find_unlocked_attestations($user_id);
$locked = find_locked_attestations($user_id);
$claims = get_claims_for_attestations();

$rclaims = array();
foreach ($claims as $aid => $ac) {
    foreach ($ac as $cid => $c) {
        $rclaims[$cid][] = $aid;
    }
}

$approved = array();
foreach ($approved_claims as $ac) {
    $approved[$ac['claim_id']] = $ac;
}

$json = array();

foreach ($unlocked as $ul) {
    $aid = $ul['attestation_id'];
    $json[$aid]['name'] = $ul['name'];
    foreach ($approved as $cid => $claim) {
        if (array_key_exists($cid, $claims[$aid]))
            $json[$aid][$cid] = $claim;
    }
}

echo "<pre>\n";

echo json_encode($json, JSON_PRETTY_PRINT);
/*
echo "<br><br>\n";


echo json_encode($unlocked, JSON_PRETTY_PRINT);
echo "<br><br>\n";

echo json_encode($claims, JSON_PRETTY_PRINT);
echo "<br><br>\n";

echo json_encode($rclaims, JSON_PRETTY_PRINT);
echo "<br><br>\n";

echo json_encode($approved, JSON_PRETTY_PRINT);
echo "<br><br>\n";
 */

echo "</pre>\n";
