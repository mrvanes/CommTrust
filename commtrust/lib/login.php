<?php
$action = isset($_POST['action'])?$_POST['action']:(isset($_GET['action'])?$_GET['action']:'');
$asp = new \SimpleSAML\Auth\Simple('default-sp');

if ($action=='login') {
    remove('user_id', 0);
    $asp->requireAuth([
        'saml:idp' => $idp,
    ]);
    $a = $asp->getAttributes();
    $uid = $a['uid'][0];
    $cn = $a['cn'][0];
    $user = register_user($uid, $cn, $ra);
    $user_id = restore('user_id', $user['user_id']);
} else {
    $user_id = restore('user_id', 0);
}

// $user = get_user($uid, $ra);
$user = get_user($user_id, $ra);
$cn = $user['display_name'];
$uid = $user['uid'];

if ($action=='logout') {
    $user_id = remove('user_id', 0);
    $cn = remove('cn', '');
    $user = Null;
    $uid = Null;
    $asp->logout(['ReturnTo' => $_SERVER['PHP_SELF']]);
}


