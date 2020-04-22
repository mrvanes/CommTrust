<?php

function find_open_attestations($user_id) {
    $query  = "SELECT att.attestation_id, att.name, att.type_id, att.config FROM commtrust.attestations att ";
    $query .= "LEFT JOIN commtrust.proofs prfs ON att.attestation_id=prfs.attestation_id ";
    $query .= "AND prfs.user_id=$user_id ";
    $query .= "WHERE prfs.user_id IS NULL ";

    db_select($query, $result);
    return $result;
}

function find_completed_attestations($user_id) {
    $query  = "SELECT att.attestation_id, att.name, prfs.approved_by, prfs.approved_at, u.user_id, u.display_name AS ra FROM proofs prfs ";
    $query .= "LEFT JOIN attestations att ON prfs.attestation_id=att.attestation_id ";
    $query .= "LEFT JOIN users u ON prfs.approved_by=u.user_id ";
    $query .= "WHERE prfs.user_id=$user_id";

    db_select($query, $result);
    return $result;
}

function find_unapproved_attestations($uid=0) {
    $query  = "SELECT att.attestation_id, att.name, att.type_id, prfs.proof_id, u.user_id, u.display_name FROM proofs prfs ";
    $query .= "LEFT JOIN attestations att ON prfs.attestation_id=att.attestation_id ";
    $query .= "LEFT JOIN users u ON prfs.user_id=u.user_id ";
    $query .= "WHERE prfs.approved_by IS NULL";
    if ($uid) $query .= " and prfs.user_id=$uid";
    db_select($query, $result);
    return $result;
}

function find_approved_attestations($user_id, $uid=0) {
    $query  = "SELECT att.attestation_id, att.name, att.type_id, prfs.proof_id, u.user_id, u.display_name FROM proofs prfs ";
    $query .= "LEFT JOIN attestations att ON prfs.attestation_id=att.attestation_id ";
    $query .= "LEFT JOIN users u ON prfs.user_id=u.user_id ";
    $query .= "WHERE prfs.approved_by=$user_id";
    if ($uid) $query .= " and prfs.user_id=$uid";

    db_select($query, $result);
    return $result;
}

function get_user($user_id) {
    $query  = "SELECT uid, display_name, ra ";
    $query .= "FROM users ";
    $query .= "WHERE user_id=$user_id";
    db_select($query, $result);

    if (db_select($query, $result)) {
        $r['uid'] = $result[0]['uid'];
        $r['display_name'] = $result[0]['display_name'];
        $r['ra'] = $result[0]['ra'];
    } else {
        $r = [];
    }

    return $r;
}

function get_attestation_for_user($attestation_id, $user_id) {
    $query  = "SELECT att.name, handler, config, prfs.proof, prfs.proof_id, prfs.source FROM attestations att ";
    $query .= "LEFT JOIN attestation_types attt ON att.type_id=attt.type_id ";
    $query .= "LEFT JOIN proofs prfs ON att.attestation_id=prfs.attestation_id AND prfs.user_id=$user_id ";
    $query .= "WHERE att.attestation_id = $attestation_id";

    if (db_select($query, $result)) {
        $r['name'] = $result[0]['name'];
        $r['handler'] = $result[0]['handler'];
        $r['config'] = $result[0]['config'];
        $r['proof'] = $result[0]['proof'];
        $r['source'] = $result[0]['source'];
    } else {
        $r['name'] = 'Empty';
        $r['handler'] = 'empty_handler';
        $r['config'] = '{}';
        $r['proof'] = "";
    }

    return $r;
}

function get_attestation_for_proof($proof_id) {
    $query  = "SELECT prfs.user_id, prfs.proof, prfs.approved_by, prfs.approved_at, prfs.source, ";
    $query .= "att.name, for_user.display_name AS for_user_name, by_user.display_name AS by_user_name FROM proofs prfs ";
    $query .= "LEFT JOIN attestations att ON prfs.attestation_id=att.attestation_id ";
    $query .= "LEFT JOIN users for_user ON prfs.user_id=for_user.user_id ";
    $query .= "LEFT JOIN users by_user ON prfs.approved_by=by_user.user_id ";
    $query .= "WHERE proof_id=$proof_id";

    if (db_select($query, $result)) {
        $r['user_id'] = $result[0]['user_id'];
        $r['proof'] = print_r(json_decode($result[0]['proof']), true);
        $r['source'] = $result[0]['source'];
        $r['approved_by'] = $result[0]['approved_by'];
        $r['approved_at'] = $result[0]['approved_at'];
        $r['attestation_name'] = $result[0]['name'];
        $r['by_user'] = $result[0]['by_user_name'];
        $r['for_user'] = $result[0]['for_user_name'];
    } else {
        $r = [];
    }

    return $r;
}

function complete_attestation($user_id, $attestation_id, $proof, $source) {
    $query = "INSERT INTO proofs (user_id, attestation_id, proof, source) ";
    $query .= "VALUES ($user_id, $attestation_id, '$proof', '$source') ";
    $query .= "ON DUPLICATE KEY UPDATE proof='$proof'";
    db_exec($query);
}

function retract_proof($user_id, $attestation_id) {
    $query  = "DELETE FROM proofs ";
    $query .= "WHERE user_id=$user_id AND attestation_id=$attestation_id";
    db_exec($query);
}

function approve_attestation($proof_id, $user_id) {
    $query  = "UPDATE proofs SET ";
    $query .= "approved_by=$user_id, approved_at=now() ";
    $query .= "WHERE proof_id=$proof_id";
    db_exec($query);
}

function disapprove_attestation($proof_id, $user_id) {
    $query  = "UPDATE proofs SET ";
    $query .= "approved_by=NULL, approved_at=NULL ";
    $query .= "WHERE proof_id=$proof_id";
    db_exec($query);
}
