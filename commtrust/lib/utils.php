<?php

function db_register($uid, $cn, $ra) {
    $query  = "INSERT INTO users (uid, display_name) ";
    $query .= "VALUES ('$uid', '$cn') ";
    $query .= "ON DUPLICATE KEY UPDATE display_name='$cn'";
    db_exec($query);

    $query  = "SELECT user_id, ra FROM users ";
    $query .= "WHERE uid='$uid'";
    if ($ra) $query .= " AND ra=1";
    db_select($query, $user);

    return $user[0];
}
