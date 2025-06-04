-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Jún 04. 15:45
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
-- Tábla szerkezet ehhez a táblához `albums`
--

CREATE TABLE `albums` (
  `album_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `artist_id` int(11) DEFAULT NULL,
  `release_year` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `albums`
--

INSERT INTO `albums` (`album_id`, `title`, `artist_id`, `release_year`) VALUES
(1, 'Abbey Road', 1, 1969),
(2, 'The Marshall Mathers LP', 2, 2000),
(3, 'Random Access Memories', 3, 2013),
(4, 'A Night at the Opera', 4, 1975),
(5, 'Scorpion', 5, 2018),
(6, 'Inception Soundtrack', 6, 2010);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `artists`
--

CREATE TABLE `artists` (
  `artist_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `genre` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `artists`
--

INSERT INTO `artists` (`artist_id`, `name`, `genre`, `country`) VALUES
(1, 'The Beatles', 'Rock', 'UK'),
(2, 'Eminem', 'Hip-Hop', 'USA'),
(3, 'Daft Punk', 'Electronic', 'France'),
(4, 'Queen', 'Rock', 'UK'),
(5, 'Drake', 'Hip-Hop', 'Canada'),
(6, 'Hans Zimmer', 'Classical', 'Germany');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `songs`
--

CREATE TABLE `songs` (
  `song_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `album_id` int(11) DEFAULT NULL,
  `duration` time DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `songs`
--

INSERT INTO `songs` (`song_id`, `title`, `album_id`, `duration`, `image`) VALUES
(1, 'Come Together', 1, '04:20:00', NULL),
(2, 'Stan', 2, '06:44:00', NULL),
(3, 'Get Lucky', 3, '06:09:00', 'dp-lucky-847684837'),
(4, 'Bohemian Rhapsody', 4, '05:55:00', NULL),
(5, 'God\'s Plan', 5, '03:19:00', NULL),
(6, 'Time', 6, '04:35:00', NULL),
(7, 'Something', 1, '03:03:00', NULL),
(8, 'The Real Slim Shady', 2, '04:44:00', NULL),
(9, 'Lose Yourself', 2, '05:20:00', NULL),
(10, 'Instant Crush', 3, '05:37:00', NULL),
(11, 'We Will Rock You', 4, '02:02:00', NULL),
(12, 'In My Feelings', 5, '03:38:00', NULL),
(13, 'Let It Be', 1, '04:03:00', NULL),
(14, 'Without Me', 2, '04:50:00', NULL),
(15, 'Harder, Better, Faster, Stronger', 3, '03:45:00', NULL),
(16, 'Don\'t Stop Me Now', 4, '03:30:00', NULL),
(17, 'Nonstop', 5, '03:58:00', NULL),
(18, 'Dream is Collapsing', 6, '02:24:00', NULL),
(19, 'Hey Jude', 1, '07:11:00', NULL),
(20, 'Beautiful', 2, '04:23:00', NULL),
(21, 'One More Time', 3, '05:20:00', NULL),
(22, 'Radio Ga Ga', 4, '05:48:00', NULL),
(23, 'Hotline Bling', 5, '04:27:00', NULL),
(24, 'Cornfield Chase', 6, '02:06:00', NULL);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `albums`
--
ALTER TABLE `albums`
  ADD PRIMARY KEY (`album_id`),
  ADD KEY `artist_id` (`artist_id`);

--
-- A tábla indexei `artists`
--
ALTER TABLE `artists`
  ADD PRIMARY KEY (`artist_id`);

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
-- AUTO_INCREMENT a táblához `albums`
--
ALTER TABLE `albums`
  MODIFY `album_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `artists`
--
ALTER TABLE `artists`
  MODIFY `artist_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `songs`
--
ALTER TABLE `songs`
  MODIFY `song_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `albums`
--
ALTER TABLE `albums`
  ADD CONSTRAINT `albums_ibfk_1` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`artist_id`);

--
-- Megkötések a táblához `songs`
--
ALTER TABLE `songs`
  ADD CONSTRAINT `songs_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
