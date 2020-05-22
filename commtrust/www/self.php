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

$inputs = restore('self:inputs', []);

$vars['name'] = $cn;
$vars['inputs'] = $inputs;
$vars['url'] =  $_SERVER['PHP_SELF'];

$self_action = isset($_POST['self_action'])?$_POST['self_action']:'';
if ($self_action == 'submit') {
    remove('self:attributes', '');
    foreach ($inputs as $input) {
        $self_attributes[$input] = [$_POST[$input]];
    }
    restore('self:attributes', $self_attributes);
    header('Location: /complete.php?action=start');
    exit;

}

// Debug
$vars['delays'] = print_r($Q_DELAY, true);
$vars['post'] = print_r($_POST, true);
$vars['get'] = print_r($_GET, true);
$vars['session'] = print_r($_SESSION, true);
echo $twig->render('self.twig', $vars);
