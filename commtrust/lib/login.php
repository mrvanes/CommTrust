<?php
$action = isset($_GET['action'])?$_GET['action']:'';
$asp = new \SimpleSAML\Auth\Simple('default-sp');

if ($action=='logout') {
    $asp->logout(['ReturnTo' => $_SERVER['PHP_SELF']]);
}

$asp->requireAuth([
    'saml:idp' => $idp,
]);
$a = $asp->getAttributes();

$uid = $a['uid'][0];
$cn = $a['cn'][0];

$user = db_register($uid, $cn, $ra);
$user_id = $user['user_id'];
