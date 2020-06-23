<?php
$ra = false;
$idp = "https://idp1.incubator.geant.org/saml2/idp/metadata.php";
require_once('../simplesaml/lib/_autoload.php');
require_once('../lib/db.php');
require_once('../lib/utils.php');
require_once('../lib/queries.php');
require_once('../lib/login.php');
require_once '../lib/ga.php';

$loader = new \Twig\Loader\FilesystemLoader('../templates');
$twig = new \Twig\Environment($loader);
$ga = new PHPGangsta_GoogleAuthenticator();
$secret = restore('secret', $ga->createSecret());
$name = $_SERVER['SERVER_NAME'];


$vars['name'] = $cn;
$vars['url'] =  $_SERVER['PHP_SELF'];

$totp_action = isset($_POST['totp_action'])?$_POST['totp_action']:'';
$totp_check = isset($_POST['totp_check'])?$_POST['totp_check']:'';

$verified = $ga->verifyCode($secret, $totp_check, 2);

remove('totp:secret', '');
if ($totp_action == 'submit' && $verified) {
    restore('totp:secret', $secret);
    remove('secret', '');
    header('Location: /complete.php?action=start');
    exit;

}

$vars['totp'] = $totp = $ga->getCode($secret);
$vars['name'] = $name;
// $vars['secret'] = 'BDWP34HAGUCQAHSC';
$vars['secret'] = $secret;
$vars['qrcode'] = $ga->getQRCodeGoogleUrl($name, $secret);
$vars['time'] = 30 - (time() % 30);

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('totp.twig', $vars);
