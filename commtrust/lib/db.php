<?php
$db_user = 'admin';
$db_password = 'admin';
$db_schema = 'commtrust';
$db_server = 'localhost';

db_connect($db_server, $db_schema, $db_user, $db_password);

function db_connect($server, $schema, $user, $pwd) {
  global $db;
  $returnval = FALSE;
  $db = mysqli_connect($server, $user, $pwd, $schema, 3306);
  if (mysqli_connect_error()) {
      die('Connect Error (' . mysqli_connect_errno() . ') '
              . mysqli_connect_error());
  }
}

function db_close($res) {
  global $db;
  @mysqli_close($db);
}

function db_select($query, &$result, $index = null) {
  global $db;
  global $Q_DELAY;
  global $Q_ERROR;

  $res = FALSE;
  $row = FALSE;
  $rows = FALSE;

  $T1 = getmicrotime();
  $res = mysqli_query($db, $query);
  if ($res) $rows = mysqli_num_rows($res);
  else $Q_ERROR[$query]=mysqli_error($db);

  while ($res && $row=mysqli_fetch_assoc($res)) $result[] = $row;
  $T2 = getmicrotime();
  $Q_DELAY[$query] = $T2-$T1;

  if ($index && $rows) {
    foreach($result as $row) {
      $r[$row[$index]] = $row;
    }
    $result = $r;
  }
  return $rows;
}

function db_exec($query) {
  global $db;
  global $Q_DELAY;
  global $Q_ERROR;

  $rows = FALSE;

  $T1 = getmicrotime();
  if (mysqli_query($db, $query)) $rows = mysqli_affected_rows($db);
  if ($rows === FALSE) {
    $Q_ERROR[$query]=mysqli_error($db);
  }
  $T2 = getmicrotime();
  $Q_DELAY[$query] = $T2-$T1;

  if (!$rows && $rows !== FALSE) $rows = TRUE;
  return $rows;
}


function getmicrotime() {
  list ($usec, $sec) = explode(" ", microtime());
  return ((float)$usec + (float)$sec);
}
