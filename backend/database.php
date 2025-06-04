<?php
    $host = 'localhost';
    $db   = 'musicdb';
    $user = 'root';
    $pass = 'test123';

    $dsn = "mysql:host=$host;dbname=$db";

    try {
        $pdo = new PDO($dsn, $user, $pass);
    } catch (\PDOException $e) {
        exit('Nem lehet csatlakozni az adatbázishoz.');
    }
?>