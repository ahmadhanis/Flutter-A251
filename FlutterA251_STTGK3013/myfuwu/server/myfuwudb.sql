-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 22, 2025 at 04:22 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myfuwudb`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_otp` varchar(6) NOT NULL,
  `user_regdate` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_password`, `user_otp`, `user_regdate`) VALUES
(1, 'hanis@gmail.com', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '415948', '2025-10-22 10:00:17.181262'),
(2, 'slumberjer@gmail.com', 'c27121bb0633356b86ec1914790d60dc10a0e4bb', '137534', '2025-10-22 10:01:26.693776'),
(3, 'abu@gmail.com', 'a5b61cef3205c1bb1c6dfaa61f3c431212ed21cc', '903712', '2025-10-22 10:08:09.975530'),
(4, 'ahmad@gmail.com', 'a5b61cef3205c1bb1c6dfaa61f3c431212ed21cc', '285108', '2025-10-22 10:16:01.572859'),
(5, 'john@gmail.com', 'a5b61cef3205c1bb1c6dfaa61f3c431212ed21cc', '115044', '2025-10-22 10:16:52.101066');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
