<?php
// Saved team comps API (tft_comps database). ?action=list | save | delete
require 'config.php';
header('Content-Type: application/json');
$db = compDb();
$action = $_GET['action'] ?? 'list';
$in = json_decode(file_get_contents('php://input'), true) ?? [];

try {
    if ($action === 'save' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $name = trim($in['name'] ?? '');
        $team = array_values(array_unique($in['champions'] ?? []));
        if ($name === '' || mb_strlen($name) > 60) throw new Exception('Enter a comp name (max 60 characters).');
        if (!$team) throw new Exception('Drag at least one champion into the team zone first.');

        // Check names against the OTHER database so only real champions are saved.
        $valid = champDb()->query("SELECT name FROM champions")->fetchAll(PDO::FETCH_COLUMN);
        if (array_diff($team, $valid)) throw new Exception('Unknown champion in team.');

        $db->beginTransaction();
        $db->prepare("INSERT INTO comps (name) VALUES (?)")->execute([$name]);
        $id = $db->lastInsertId();
        $ins = $db->prepare("INSERT INTO comp_champions (comp_id, champion_name) VALUES (?, ?)");
        foreach ($team as $c) $ins->execute([$id, $c]);
        $db->commit();
        echo json_encode(['ok' => true, 'id' => $id]);
    } elseif ($action === 'delete' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $db->prepare("DELETE FROM comps WHERE id = ?")->execute([(int)($in['id'] ?? 0)]); // members cascade
        echo json_encode(['ok' => true]);
    } else {
        $rows = $db->query("SELECT c.id, c.name, c.created_at, GROUP_CONCAT(cc.champion_name) AS champs
                            FROM comps c LEFT JOIN comp_champions cc ON cc.comp_id = c.id
                            GROUP BY c.id ORDER BY c.id DESC")->fetchAll();
        foreach ($rows as &$r) { $r['champions'] = $r['champs'] ? explode(',', $r['champs']) : []; unset($r['champs']); }
        echo json_encode($rows);
    }
} catch (Exception $e) {
    if ($db->inTransaction()) $db->rollBack();
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
