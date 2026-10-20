<?php
// Reads champions and traits from the tft_champions database.
require_once 'config.php';
$db = champDb();

$characters = $db->query("SELECT name FROM champions ORDER BY name")->fetchAll(PDO::FETCH_COLUMN);

$classTraits = []; $originTraits = [];
$rows = $db->query("SELECT t.name AS trait, t.type, c.name AS champ
                    FROM champion_traits ct
                    JOIN champions c ON c.id = ct.champion_id
                    JOIN traits t ON t.id = ct.trait_id
                    ORDER BY t.name, c.name");
foreach ($rows as $r) {
    if ($r['type'] === 'class') $classTraits[$r['trait']][] = $r['champ'];
    else                        $originTraits[$r['trait']][] = $r['champ'];
}

// Visiting data.php directly returns the data as JSON (app.js uses this).
if (basename($_SERVER['SCRIPT_FILENAME']) === 'data.php') {
    header('Content-Type: application/json');
    echo json_encode(compact('characters', 'classTraits', 'originTraits'));
}
