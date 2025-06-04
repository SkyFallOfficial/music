<?php
    require_once 'database.php';

    header('Content-Type: application/json');

    if (isset($_GET['album_id'])) {
        $album_id = $_GET['album_id'];

        $stmt = $pdo->prepare('
            SELECT songs.*, albums.title AS album_title, artists.name AS artist
            FROM songs
            JOIN albums ON songs.album_id = albums.album_id
            JOIN artists ON albums.artist_id = artists.artist_id
            WHERE songs.album_id = ?
        ');

        $stmt->execute([$album_id]);
        $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode($data ? $data : []);
    } else {
        $stmt = $pdo->prepare('
            SELECT songs.*, albums.title AS album_title, artists.name AS artist
            FROM songs
            JOIN albums ON songs.album_id = albums.album_id
            JOIN artists ON albums.artist_id = artists.artist_id
        ');

        $stmt->execute();
        $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode($data ? $data : []);
    }
?>