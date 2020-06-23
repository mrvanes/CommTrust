<?php
require_once('../lib/handlers.php');

function add_log($actor_id, $subject_id, $ass_id, $msg) {
    $query  = "INSERT INTO audit_log (actor_id, subject_id, assertion_id, message) ";
    $query .= "VALUES ($actor_id, $subject_id, $ass_id, '$msg')";
//     if ($subject_id) $query .= "$subject_id ";
//     else $query .= "NULL, ";
//     if ($ass_id) $query .= "$ass_id, ";
//     else $query .= "NULL, ";
//     $query .= "'$msg')";
    db_exec($query);
}

function read_logs($user_id, $from) {
    $query  = "SELECT al.timestamp, al.actor_id, al.subject_id, al.assertion_id, al.message, ua.display_name, us.display_name, c.name ";
    $query .= "FROM audit_log al ";
    $query .= "LEFT JOIN users ua ON al.actor_id=ua.user_id ";
    $query .= "LEFT JOIN users us ON al.subject_id=us.user_id ";
    $query .= "LEFT JOIN assertions ass ON ass.assertion_id=al.assertion_id ";
    $query .= "LEFT JOIN claims c ON c.claim_id=ass.claim_id ";
    $query .= "WHERE (actor_id=$user_id OR subject_id=$user_id) AND al.timestamp > '$from'";
    $r = db_select($query, $result);
    return $result;
}

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

function find_claims_for_attestation($user_id, $att_id) {
    $query  = "SELECT ass.assertion_id, ass.proved_at, c.name, c.config, c.claim_id, app.approved_by, u.display_name AS ra, app.approved_at, app.approved_with, ass.evidence, ass.source, ct.handler ";
    $query .= "FROM assertions ass ";
    $query .= "LEFT JOIN claims c ON ass.claim_id=c.claim_id ";
    $query .= "LEFT JOIN claim_types ct ON c.type_id=ct.type_id ";
    $query .= "LEFT JOIN approvals app ON ass.assertion_id=app.assertion_id ";
    $query .= "LEFT JOIN users u ON app.approved_by=u.user_id ";
    $query .= "JOIN att2claims a2c ON a2c.claim_id=ass.claim_id ";
    $query .= "JOIN attestations att ON att.attestation_id=a2c.attestation_id ";
    $query .= "WHERE ass.user_id=$user_id AND att.attestation_id=$att_id ";
    $query .= "AND app.approved_by IS NOT NULL";

    db_select($query, $result);
    if ($result) foreach ($result as &$a) {
        $a['card'] = $a['handler']::get_card($a['evidence'], $a['config']);
    }
    return $result;
}

function get_claims_for_attestations() {
    $query  = "SELECT att.attestation_id, c.claim_id, c.name ";
    $query .= "FROM attestations att ";
    $query .= "LEFT JOIN att2claims a2c ON a2c.attestation_id=att.attestation_id ";
    $query .= "LEFT JOIN claims c ON c.claim_id=a2c.claim_id";

    db_select($query, $result);

    $atts = [];
    foreach ($result as $row) {
        $atts[$row['attestation_id']][$row['claim_id']] = $row['name'];
    }
    return $atts;
}

function find_unapproved_assertions($search) {
    $query  = "SELECT ass.assertion_id, c.name, c.type_id, c.config, ct.handler, ass.assertion_id, ass.evidence, ass.source, ass.proved_at, u.user_id, u.display_name ";
    $query .= "FROM assertions ass ";
    $query .= "LEFT JOIN approvals app ON app.assertion_id=ass.assertion_id ";
    $query .= "LEFT JOIN claims c ON c.claim_id=ass.claim_id ";
    $query .= "LEFT JOIN claim_types ct ON ct.type_id=c.type_id ";
    $query .= "LEFT JOIN users u ON ass.user_id=u.user_id ";
    $query .= "WHERE app.approved_by IS NULL";
    if ($search) $query .= " AND u.display_name LIKE '%$search%'";

    db_select($query, $result);
    if ($result) foreach ($result as &$a) {
        $a['card'] = $a['handler']::get_card($a['evidence'], $a['config']);
    }

    return $result;
}

function find_approved_assertions($user_id, $search) {
    $query  = "SELECT ass.assertion_id, c.name, c.type_id, ct.handler, c.config, app.approved_at, ass.evidence, ass.source, ass.proved_at, u.user_id, u.display_name ";
    $query .= "FROM assertions ass ";
    $query .= "LEFT JOIN approvals app ON app.assertion_id=ass.assertion_id ";
    $query .= "LEFT JOIN claims c ON c.claim_id=ass.claim_id ";
    $query .= "LEFT JOIN claim_types ct ON ct.type_id=c.type_id ";
    $query .= "LEFT JOIN users u ON ass.user_id=u.user_id ";
    $query .= "WHERE app.approved_by=$user_id";
    if ($search) $query .= " AND u.display_name LIKE '%$search%'";

    db_select($query, $result);
    if ($result) foreach ($result as &$a) {
        $a['card'] = $a['handler']::get_card($a['evidence'], $a['config']);
    }

    return $result;
}

function find_unlocked_attestations($user_id) {
    $query  = "SELECT DISTINCT att.name, att.attestation_id ";
    $query .= "FROM approvals app ";
    $query .= "JOIN assertions ass ON ass.assertion_id=app.assertion_id ";
    $query .= "JOIN att2claims a2c ON a2c.claim_id=ass.claim_id ";
    $query .= "JOIN attestations att ON att.attestation_id=a2c.attestation_id ";
    $query .= "WHERE ass.user_id=$user_id";

    db_select($query, $result);
    return $result;
}

function find_locked_attestations($user_id) {
    $query  = "SELECT att.name, att.attestation_id ";
    $query .= "FROM attestations att ";
    $query .= "WHERE att.attestation_id NOT IN(";
    $query .= "SELECT DISTINCT att.attestation_id ";
    $query .= "FROM approvals app ";
    $query .= "JOIN assertions ass ON ass.assertion_id=app.assertion_id ";
    $query .= "JOIN att2claims a2c ON a2c.claim_id=ass.claim_id ";
    $query .= "JOIN attestations att ON att.attestation_id=a2c.attestation_id ";
    $query .= "WHERE ass.user_id=$user_id";
    $query .= ")";

    db_select($query, $result);
    return $result;
}

function get_claim_for_user($user_id, $claim_id) {
    $query  = "SELECT c.name, ct.handler, c.config, ass.evidence, ass.assertion_id, ass.source, ass.proved_at, app.approved_by, u.uid, app.approved_at, app.approved_with ";
    $query .= "FROM claims c ";
    $query .= "LEFT JOIN assertions ass ON ass.claim_id=c.claim_id AND ass.user_id=$user_id ";
    $query .= "LEFT JOIN claim_types ct ON c.type_id=ct.type_id ";
    $query .= "LEFT JOIN approvals app ON ass.assertion_id=app.assertion_id ";
    $query .= "LEFT JOIN users u ON app.approved_by=u.user_id ";
    $query .= "WHERE c.claim_id=$claim_id ";
    $query .= "ORDER BY ass.proved_at DESC LIMIT 1";

    $r = [];

    if (db_select($query, $result)) {
        $r = $result[0];
    } else {
        $r['name'] = 'Empty';
        $r['handler'] = 'empty_handler';
        $r['config'] = '{}';
        $r['evidence'] = "";
        $r['assertion_id'] = 0;
    }

    return $r;
}

function get_claim_for_assertion($assertion_id) {
    $query  = "SELECT ass.user_id, ass.evidence, ass.proved_at, app.approved_by, app.approved_at, app.approved_with, ass.source, c.name, c.claim_id, ct.handler, for_user.display_name AS for_user_name, by_user.display_name AS by_user_name ";
    $query .= "FROM assertions  ass ";
    $query .= "LEFT JOIN claims  c ON c.claim_id=ass.claim_id ";
    $query .= "LEFT JOIN claim_types ct ON ct.type_id=c.type_id ";
    $query .= "LEFT JOIN approvals app ON app.assertion_id=ass.assertion_id ";
    $query .= "LEFT JOIN users for_user ON for_user.user_id=ass.user_id ";
    $query .= "LEFT JOIN users by_user ON by_user.user_id=app.approved_by ";
    $query .= "WHERE ass.assertion_id=$assertion_id";

    $r = [];
    if (db_select($query, $result)) {
        $r['user_id'] = $result[0]['user_id'];
        $handler = $result[0]['handler'];
        $r['evidence'] = $handler::render_evidence(json_decode($result[0]['evidence'], true));
        $r['source'] = $result[0]['source'];
        $r['approved_by'] = $result[0]['approved_by'];
        $r['approved_at'] = $result[0]['approved_at'];
        $r['approved_with'] = json_decode($result[0]['approved_with'], true);
        $r['claim_name'] = $result[0]['name'];
        $r['claim_id'] = $result[0]['claim_id'];
        $r['proved_at'] = $result[0]['proved_at'];
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

function complete_evidence($user_id, $claim_id, $ass_id, $evidence, $source) {
    $query  = "SELECT ass.assertion_id ";
    $query .= "FROM assertions ass ";
    $query .= "LEFT JOIN approvals app ON app.assertion_id=ass.assertion_id ";
    $query .= "WHERE ass.user_id=$user_id AND ass.claim_id=$claim_id ";
    $query .= "AND app.approved_by IS NULL ";
    $query .= "LIMIT 1";
    $r = db_select($query, $result);
    if ($r && $result[0]['assertion_id'] == $ass_id) {
        $query  = "UPDATE assertions ";
        $query .= "SET evidence='$evidence', source='$source', proved_at=now() ";
        $query .= "WHERE assertion_id=$ass_id";
    } else {
        $query = "INSERT INTO assertions (user_id, claim_id, evidence, source, proved_at) ";
        $query .= "VALUES ($user_id, $claim_id, '$evidence', '$source', now())";
    }
    db_exec($query, $id);
    if ($id) $ass_id = $id;

    $user = get_user($user_id);
    $assertion = get_assertion($ass_id);
    add_log($user_id, 'NULL', $ass_id, "User " . $user['display_name'] . " completed evidence on assertion " . $assertion['name'] . " from source $source");
}

function get_assertion($aid) {
    $query  = "SELECT c.name ";
    $query .= "FROM assertions a LEFT JOIN claims c ON a.claim_id = c.claim_id ";
    $query .= "WHERE a.assertion_id=$aid";
    db_select($query, $result);
    return $result[0];
}

function retract_evidence($aid) {
    // This DELETE relies on CASCADE to approvals
    $query  = "DELETE ass ";
    $query .= "FROM assertions ass ";
//     $query .= "WHERE user_id=$user_id AND claim_id=$claim_id";
    $query .= "WHERE ass.assertion_id=$aid";
    db_exec($query);
}

function approve_assertion($assertion_id, $user_id, $with) {
    $c = get_claim_for_assertion($assertion_id);
    $cid = $c['claim_id'];
    $ctime = $c['proved_at'];
    $cuser = $c['user_id'];
    $query  = "DELETE FROM assertions ";
    $query .= "WHERE user_id=$cuser AND claim_id=$cid ";
    $query .= "AND proved_at < '$ctime'";
    db_exec($query);
    $query  = "INSERT INTO approvals (assertion_id, approved_by, approved_at, approved_with) ";
    $query .= "VALUES ($assertion_id, $user_id, now(), '$with')";
    db_exec($query, $id);


    $user = get_user($user_id);
    $claim_user = get_user($cuser);
    $assertion = get_assertion($assertion_id);
    add_log($user_id, $cuser, $assertion_id, "User " . $user['display_name'] . " approved assertion " . $assertion['name'] . " for user " . $claim_user['display_name']);
}

function disapprove_assertion($assertion_id) {
    $query  = "DELETE FROM approvals ";
    $query .= "WHERE assertion_id=$assertion_id";
    db_exec($query);
}
