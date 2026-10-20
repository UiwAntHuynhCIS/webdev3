<?php
// WAMP defaults: user "root", empty password. Change these if yours differ.
const DB_HOST = 'localhost', DB_USER = 'root', DB_PASS = '';

function connect($dbname) {
    return new PDO("mysql:host=" . DB_HOST . ";dbname=$dbname;charset=utf8mb4", DB_USER, DB_PASS,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]);
}
function champDb() { return connect('tft_champions'); }
function compDb()  { return connect('tft_comps'); }
