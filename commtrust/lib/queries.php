<?php
require_once('../lib/handlers.php');

function find_open_claims($user_id) {
    $query  = "SELECT c.claim_id, c.name, c.type_id, c.config ";
    $query .= "FROM claims c ";
    $query .= "LEFT JOIN assertions ass ON ass.claim_id=c.claim_id AND ass.user_id=$user_id ";
    $query .= "WHERE ass.user_id IS NULL";

    db_select($query, $result);
    return $result;
}

function find_completed_claims($user_id) {
    $query  = "SELECT ass.assertion_id, ass.proved_at, c.name, c.config, c.claim_id, app.approved_by, u.display_name AS ra, app.approved_at, app.approved_with, ass.evidence, ass.source, ct.handler ";
    $query .= "FROM assertions ass ";
    $query .= "LEFT JOIN claims c ON ass.claim_id=c.claim_id ";
    $query .= "LEFT JOIN claim_types ct ON c.type_id=ct.type_id ";
    $query .= "LEFT JOIN approvals app ON ass.assertion_id=app.assertion_id ";
    $query .= "LEFT JOIN users u ON app.approved_by=u.user_id ";
    $query .= "WHERE ass.user_id=$user_id ";
    $query .= "AND app.approved_by IS NULL";

    db_select($query, $result);
    if ($result) foreach ($result as &$a) {
        $a['card'] = $a['handler']::get_card($a['evidence'], $a['config']);
    }
    return $result;
}

function find_approved_claims($user_id) {
    $query  = "SELECT ass.assertion_id, ass.proved_at, c.name, c.config, c.claim_id, app.approved_by, u.display_name AS ra, app.approved_at, app.approved_with, ass.evidence, ass.source, ct.handler ";
    $query .= "FROM assertions ass ";
    $query .= "LEFT JOIN claims c ON ass.claim_id=c.claim_id ";
    $query .= "LEFT JOIN claim_types ct ON c.type_id=ct.type_id ";
    $query .= "LEFT JOIN approvals app ON ass.assertion_id=app.assertion_id ";
    $query .= "LEFT JOIN users u ON app.approved_by=u.user_id ";
    $query .= "WHERE ass.user_id=$user_id ";
    $query .= "AND app.approved_by IS NOT NULL";

    db_select($query, $result);
    if ($result) foreach ($result as &$a) {
        $a['card'] = $a['handler']::get_card($a['evidence'], $a['config']);
    }
    return $result;
}


function find_unapproved_assertions($uid=0) {
    $query  = "SELECT ass.assertion_id, c.name, c.type_id, c.config, ct.handler, ass.assertion_id, ass.evidence, ass.source, ass.proved_at, u.user_id, u.display_name ";
    $query .= "FROM assertions ass ";
    $query .= "LEFT JOIN approvals app ON app.assertion_id=ass.assertion_id ";
    $query .= "LEFT JOIN claims c ON c.claim_id=ass.claim_id ";
    $query .= "LEFT JOIN claim_types ct ON ct.type_id=c.type_id ";
    $query .= "LEFT JOIN users u ON ass.user_id=u.user_id ";
    $query .= "WHERE app.approved_by IS NULL";

    if ($uid) $query .= " AND ass.user_id=$uid";

    db_select($query, $result);
    if ($result) foreach ($result as &$a) {
        $a['card'] = $a['handler']::get_card($a['evidence'], $a['config']);
    }

    return $result;
}

function find_approved_assertions($user_id, $uid=0) {
    $query  = "SELECT ass.assertion_id, c.name, c.type_id, ct.handler, c.config, app.approved_at, ass.evidence, ass.source, ass.proved_at, u.user_id, u.display_name ";
    $query .= "FROM assertions ass ";
    $query .= "LEFT JOIN approvals app ON app.assertion_id=ass.assertion_id ";
    $query .= "LEFT JOIN claims c ON c.claim_id=ass.claim_id ";
    $query .= "LEFT JOIN claim_types ct ON ct.type_id=c.type_id ";
    $query .= "LEFT JOIN users u ON ass.user_id=u.user_id ";
    $query .= "WHERE app.approved_by=$user_id";
    if ($uid) $query .= " and ass.user_id=$uid";

    db_select($query, $result);
    if ($result) foreach ($result as &$a) {
        $a['card'] = $a['handler']::get_card($a['evidence'], $a['config']);
    }

    return $result;
}

function find_unlocked_attestations($user_id) {
    $query  = "SELECT DISTINCT att.name ";
    $query .= "FROM approvals app ";
    $query .= "JOIN assertions ass ON ass.assertion_id=app.assertion_id ";
    $query .= "JOIN att2claims a2c ON a2c.claim_id=ass.claim_id ";
    $query .= "JOIN attestations att ON att.attestation_id=a2c.attestation_id ";
    $query .= "WHERE ass.user_id=$user_id";

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

function get_claim_for_user($claim_id, $user_id) {
    $query  = "SELECT c.name, ct.handler, c.config, ass.evidence, ass.assertion_id, ass.source, ass.proved_at, app.approved_by, u.uid, app.approved_at, app.approved_with ";
    $query .= "FROM claims c ";
    $query .= "LEFT JOIN assertions ass ON ass.claim_id=c.claim_id AND ass.user_id=$user_id ";
    $query .= "LEFT JOIN claim_types ct ON c.type_id=ct.type_id ";
    $query .= "LEFT JOIN approvals app ON ass.assertion_id=app.assertion_id ";
    $query .= "LEFT JOIN users u ON app.approved_by=u.user_id ";
    $query .= "WHERE c.claim_id=$claim_id";

    $r = [];

    if (db_select($query, $result)) {
        $r = $result[0];
    } else {
        $r['name'] = 'Empty';
        $r['handler'] = 'empty_handler';
        $r['config'] = '{}';
        $r['evidence'] = "";
    }

    return $r;
}

function get_claim_for_assertion($assertion_id) {
    $query  = "SELECT ass.user_id, ass.evidence, app.approved_by, app.approved_at, app.approved_with, ass.source, c.name, c.claim_id, for_user.display_name AS for_user_name, by_user.display_name AS by_user_name ";
    $query .= "FROM assertions  ass ";
    $query .= "LEFT JOIN claims  c ON c.claim_id=ass.claim_id ";
    $query .= "LEFT JOIN approvals app ON app.assertion_id=ass.assertion_id ";
    $query .= "LEFT JOIN users for_user ON for_user.user_id=ass.user_id ";
    $query .= "LEFT JOIN users by_user ON by_user.user_id=app.approved_by ";
    $query .= "WHERE ass.assertion_id=$assertion_id";

    $r = [];
    if (db_select($query, $result)) {
        $r['user_id'] = $result[0]['user_id'];
        $r['evidence'] = json_decode($result[0]['evidence'], true);
        $r['source'] = $result[0]['source'];
        $r['approved_by'] = $result[0]['approved_by'];
        $r['approved_at'] = $result[0]['approved_at'];
        $r['approved_with'] = json_decode($result[0]['approved_with'], true);
        $r['claim_name'] = $result[0]['name'];
        $r['claim_id'] = $result[0]['claim_id'];
        $r['by_user'] = $result[0]['by_user_name'];
        $r['for_user'] = $result[0]['for_user_name'];
    }

    return $r;
}

function get_attestations_for_claim($claim_id) {
    $query  = "SELECT name ";
    $query .= "FROM attestations att ";
    $query .= "JOIN att2claims a2c ON a2c.attestation_id=att.attestation_id ";
    $query .= "WHERE a2c.claim_id=$claim_id";

    db_select($query, $result);
    return $result;
}

function complete_evidence($user_id, $claim_id, $evidence, $source) {
    $query = "INSERT INTO assertions (user_id, claim_id, evidence, source, proved_at) ";
    $query .= "VALUES ($user_id, $claim_id, '$evidence', '$source', now()) ";
    $query .= "ON DUPLICATE KEY UPDATE evidence='$evidence'";
    db_exec($query);
}

function retract_evidence($user_id, $claim_id) {
    // This DELETE relies on CASCADE to approvals
    $query  = "DELETE ass ";
    $query .= "FROM assertions ass ";
    $query .= "WHERE user_id=$user_id AND claim_id=$claim_id";
    db_exec($query);
}

function approve_assertion($assertion_id, $user_id, $with) {
    $query  = "INSERT INTO approvals (assertion_id, approved_by, approved_at, approved_with) ";
    $query .= "VALUES ($assertion_id, $user_id, now(), '$with')";
    db_exec($query);
}

function disapprove_assertion($assertion_id) {
    $query  = "DELETE FROM approvals ";
    $query .= "WHERE assertion_id=$assertion_id";
    db_exec($query);
}
