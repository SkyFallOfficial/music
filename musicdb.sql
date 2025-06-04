-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Jún 05. 00:33
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `musicdb`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `songs`
--

CREATE TABLE `songs` (
  `song_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `album_id` int(11) DEFAULT NULL,
  `duration` time DEFAULT NULL,
  `explicit` tinyint(1) NOT NULL DEFAULT 0,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `songs`
--

INSERT INTO `songs` (`song_id`, `title`, `album_id`, `duration`, `explicit`, `image`) VALUES
(1, 'Come Together', 1, '04:20:00', 0, NULL),
(2, 'Stan', 2, '06:44:00', 0, NULL),
(3, 'Get Lucky (radio edit)', 3, '04:07:00', 0, 'daft-punk-9f84a17b545a4a7cb1ca6b8e5a5a851a'),
(4, 'Bohemian Rhapsody', 4, '05:55:00', 0, NULL),
(5, 'God\'s Plan', 5, '03:19:00', 0, NULL),
(6, 'Time', 6, '04:35:00', 0, NULL),
(7, 'Something', 1, '03:03:00', 0, NULL),
(8, 'The Real Slim Shady', 2, '04:44:00', 0, NULL),
(9, 'Lose Yourself', 2, '05:20:00', 0, NULL),
(10, 'Instant Crush', 3, '05:37:00', 0, NULL),
(11, 'We Will Rock You', 4, '02:02:00', 0, NULL),
(12, 'In My Feelings', 5, '03:38:00', 0, NULL),
(13, 'Let It Be', 1, '04:03:00', 0, NULL),
(14, 'Without Me', 2, '04:57:00', 1, 'eminem-42c492d7ff2449c7ac9f74794f9e7f37'),
(15, 'Harder, Better, Faster, Stronger', 3, '03:45:00', 0, NULL),
(16, 'Don\'t Stop Me Now', 4, '03:30:00', 0, NULL),
(17, 'Nonstop', 5, '03:58:00', 0, NULL),
(18, 'Dream is Collapsing', 6, '02:24:00', 0, NULL),
(19, 'Hey Jude', 1, '07:11:00', 0, NULL),
(20, 'Beautiful', 2, '04:23:00', 0, NULL),
(21, 'One More Time', 3, '05:20:00', 0, NULL),
(22, 'Radio Ga Ga', 4, '05:48:00', 0, NULL),
(23, 'Hotline Bling', 5, '04:27:00', 0, NULL),
(24, 'Cornfield Chase', 6, '02:06:00', 0, NULL);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `songs`
--
ALTER TABLE `songs`
  ADD PRIMARY KEY (`song_id`),
  ADD KEY `album_id` (`album_id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `songs`
--
ALTER TABLE `songs`
  MODIFY `song_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `songs`
--
ALTER TABLE `songs`
  ADD CONSTRAINT `songs_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
