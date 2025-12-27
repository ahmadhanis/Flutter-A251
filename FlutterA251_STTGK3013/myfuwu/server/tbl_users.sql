-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 27, 2025 at 11:09 AM
-- Server version: 10.3.39-MariaDB-log-cll-lve
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `slumber6_myfuwudb`
--

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`, `user_address`, `user_latitude`, `user_longitude`, `user_regdate`, `user_credit`) VALUES
(1, 'ali@email.com', 'Ali bin Abu', '0194444555', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '432587', 'No. 12, Jalan Tanjung 3, 06000 Jitra, Kubang Pasu, Kedah', '6.4383', '100.1940', '2025-11-02 09:27:23.965748', 0),
(2, 'alice@email.com', 'Alice Tan', '0111234001', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '483920', 'No. 22, Jalan Harmoni 1, 06050 Bukit Kayu Hitam, Kedah', '6.4260', '100.4260', '2025-11-29 12:16:18.161896', 0),
(3, 'benjamin@email.com', 'Benjamin Lee', '0111234002', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '251734', 'No. 8, Jalan Bayu 5, 09100 Baling, Kedah', '5.6827', '100.9117', '2025-11-29 12:16:18.161896', 0),
(4, 'carmen@email.com', 'Carmen Wong', '0111234003', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '907162', 'No. 19, Taman Bahagia, 09600 Bandar Baharu, Kedah', '5.4943', '100.5080', '2025-11-29 12:16:18.161896', 0),
(5, 'daniel@email.com', 'Daniel Lim', '0111234004', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '642513', 'No. 77, Jalan Sultanah, 05100 Alor Setar, Kota Setar, Kedah', '6.1184', '100.3692', '2025-11-29 12:16:18.161896', 0),
(6, 'elena@email.com', 'Elena Ng', '0111234005', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '315890', 'No. 5, Lorong Dahlia, 08000 Sungai Petani, Kuala Muda, Kedah', '5.6470', '100.4870', '2025-11-29 12:16:18.161896', 0),
(7, 'farhan@email.com', 'Farhan Aziz', '0111234006', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '782640', 'No. 20, Jalan Merpati, 06300 Kuala Nerang, Padang Terap, Kedah', '6.2500', '100.6830', '2025-11-29 12:16:18.161896', 0),
(8, 'geetha@email.com', 'Geetha Devi', '0111234007', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '958123', 'No. 31, Jalan Sena Indah, 06400 Pokok Sena, Kedah', '6.1667', '100.4500', '2025-11-29 12:16:18.161896', 0),
(9, 'harris@email.com', 'Harris Tan', '0111234008', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '416872', 'No. 4, Taman Damai, 06900 Yan, Kedah', '5.8217', '100.4313', '2025-11-29 12:16:18.161896', 0),
(10, 'isabelle@email.com', 'Isabelle Lim', '0111234009', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '705243', 'No. 11, Jalan Cempaka, 08200 Sik, Kedah', '5.8024', '100.7340', '2025-11-29 12:16:18.161896', 0),
(11, 'jason@email.com', 'Jason Ong', '0111234010', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '624581', 'No. 9, Jalan Kenanga, 06000 Jitra, Kubang Pasu, Kedah', '6.4383', '100.1940', '2025-11-29 12:16:18.161896', 0),
(12, 'kimberly@email.com', 'Kimberly Teo', '0111234011', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '892367', 'No. 42, Taman Seri, 06050 Bukit Kayu Hitam, Kedah', '6.4260', '100.4260', '2025-11-29 12:16:18.161896', 0),
(13, 'leon@email.com', 'Leon Chua', '0111234012', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '349052', 'No. 15, Jalan Mawar, 09100 Baling, Kedah', '5.6827', '100.9117', '2025-11-29 12:16:18.161896', 0),
(14, 'maya@email.com', 'Maya Abdullah', '0111234013', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '760418', 'No. 28, Jalan Aman, 09600 Bandar Baharu, Kedah', '5.4943', '100.5080', '2025-11-29 12:16:18.161896', 0),
(15, 'nathan@email.com', 'Nathan Koh', '0111234014', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '237561', 'No. 6, Jalan Setar Muda, 05100 Alor Setar, Kota Setar, Kedah', '6.1184', '100.3692', '2025-11-29 12:16:18.161896', 0),
(16, 'olivia@email.com', 'Olivia Tan', '0111234015', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '548739', 'No. 33, Jalan Intan, 08000 Sungai Petani, Kuala Muda, Kedah', '5.6470', '100.4870', '2025-11-29 12:16:18.161896', 0),
(17, 'peter@email.com', 'Peter Chong', '0111234016', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '951672', 'No. 18, Jalan Sri Nerang, 06300 Kuala Nerang, Padang Terap, Kedah', '6.2500', '100.6830', '2025-11-29 12:16:18.161896', 0),
(18, 'qiara@email.com', 'Qiara Lee', '0111234017', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '124963', 'No. 2, Jalan Teratai, 06400 Pokok Sena, Kedah', '6.1667', '100.4500', '2025-11-29 12:16:18.161896', 0),
(19, 'raymond@email.com', 'Raymond Yap', '0111234018', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '689451', 'No. 7, Taman Ria, 06900 Yan, Kedah', '5.8217', '100.4313', '2025-11-29 12:16:18.161896', 0),
(20, 'sophia@email.com', 'Sophia Ahmad', '0111234019', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '305728', 'No. 12, Jalan Melur, 08200 Sik, Kedah', '5.8024', '100.7340', '2025-11-29 12:16:18.161896', 0),
(21, 'thomas@email.com', 'Thomas Goh', '0111234020', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '873194', 'No. 55, Jalan Tanjung 5, 06000 Jitra, Kubang Pasu, Kedah', '6.4383', '100.1940', '2025-11-29 12:16:18.161896', 0),
(22, 'azman@email.com', 'Azman Taa', '0112224445', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '416361', 'Bangunan Teknologi Maklumat,\nUUM College of Arts and Sciences,\n06010,Changlun,\nKedah,Malaysia', '6.46733', '100.5074567', '2025-12-03 08:54:49.646740', 0),
(24, 'slumberjer@gmail.com', 'Ahmad Hanis Shabli', '0194702493', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '1', 'Bangunan Pendidkan & Bahasa Moden (UUM-CAS), Bangunan Pendidkan & Bahasa Moden (UUM-CAS),\n06050 Changlun, Kedah, Malaysia', '6.4666', '100.506695', '2025-12-21 09:57:08.847968', 80);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
