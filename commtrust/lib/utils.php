<?php

function clear_db() {
    $query  = "TRUNCATE TABLE `audit_log`;";
    $query .= "TRUNCATE TABLE `approvals`;";
    $query .= "SET FOREIGN_KEY_CHECKS = 0;";
    $query .= "TRUNCATE TABLE `assertions`;";
    $query .= "SET FOREIGN_KEY_CHECKS = 1;";
    db_multi_exec($query);
}

function register_user($uid, $cn, $ra) {
    $query  = "INSERT INTO users (uid, display_name) ";
    $query .= "VALUES ('$uid', '$cn') ";
    $query .= "ON DUPLICATE KEY UPDATE display_name='$cn'";
    db_exec($query);

    $query  = "SELECT user_id, uid, display_name, ra, last_seen FROM users ";
    $query .= "WHERE uid='$uid'";
    if ($ra) $query .= " AND ra=1";
    db_select($query, $user);

    return $user[0];
}

function get_user($user_id, $ra=0, $set_last_seen=0) {
    if ($set_last_seen) {
        $query  = "UPDATE users ";
        $query .= "SET last_seen=now() ";
        $query .= "WHERE user_id=$user_id";
        db_exec($query);
    }
    $query  = "SELECT user_id, uid, display_name, ra, last_seen FROM users ";
    $query .= "WHERE user_id=$user_id";
    if ($ra) $query .= " AND ra=1";
    db_select($query, $user);

    return $user[0];
}

function restore($var, $default='') {
    if (isset($_GET[$var])) {
        $r = $_GET[$var];
    } else if (isset($_POST[$var])) {
        $r = $_POST[$var];
    } else if (isset($_SESSION[$var])) {
        $r = $_SESSION[$var];
    } else {
        $r = $default;
    }
    $_SESSION[$var] = $r;
    return $r;
}

function remove($var, $default='') {
    unset($_GET[$var]);
    unset($_POST[$var]);
    unset($_SESSION[$var]);
    return $default;
}
