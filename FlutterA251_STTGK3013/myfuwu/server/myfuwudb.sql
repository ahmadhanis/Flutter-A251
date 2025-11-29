-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2025 at 08:19 AM
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
-- Table structure for table `tbl_services`
--

CREATE TABLE `tbl_services` (
  `service_id` int(5) NOT NULL,
  `user_id` varchar(5) NOT NULL,
  `service_title` varchar(100) NOT NULL,
  `service_desc` varchar(500) NOT NULL,
  `service_district` varchar(50) NOT NULL,
  `service_type` varchar(50) NOT NULL,
  `service_rate` float(4,2) NOT NULL,
  `service_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_services`
--

INSERT INTO `tbl_services` (`service_id`, `user_id`, `service_title`, `service_desc`, `service_district`, `service_type`, `service_rate`, `service_date`) VALUES
(1, '1', 'Sofa Cleaning Service', 'We clean your sofa at the comfort of your home', 'Bukit Kayu Hitam', 'Cleaning', 30.00, '2025-11-09 09:46:11.916272'),
(2, '1', 'Walking Dog', 'Don\'t have time, let us walk your dog.', 'Bukit Kayu Hitam', 'Cleaning', 30.00, '2025-11-09 09:49:51.219117'),
(3, '1', 'House Cleaning', 'General house cleaning service for residential homes.', 'Kubang Pasu', 'Cleaning', 80.00, '2025-11-29 12:20:38.719770'),
(4, '2', 'Pipe Repair', 'Fixing leaking and damaged pipes for home and shops.', 'Bukit Kayu Hitam', 'Plumbing', 99.99, '2025-11-29 12:20:38.719770'),
(5, '3', 'Electrical Checkup', 'Inspection of wiring, sockets, and electrical faults.', 'Baling', 'Electrical', 90.00, '2025-11-29 12:20:38.719770'),
(6, '4', 'Wall Painting', 'Interior wall painting using high-quality paint.', 'Bandar Baru', 'Painting', 99.99, '2025-11-29 12:20:38.719770'),
(7, '5', 'Car Maintenance', 'Basic car service including oil change.', 'Kota Setar', 'Car Service', 99.99, '2025-11-29 12:20:38.719770'),
(8, '6', 'Garden Care', 'Grass cutting and garden maintenance for homes.', 'Kuala Muda', 'Gardening', 70.00, '2025-11-29 12:20:38.719770'),
(9, '7', 'Home Helper', 'General assistance with simple household tasks.', 'Padang Terap', 'Other', 50.00, '2025-11-29 12:20:38.719770'),
(10, '8', 'Deep Cleaning', 'Full house deep cleaning including kitchen and toilets.', 'Pokok Sena', 'Cleaning', 99.99, '2025-11-29 12:20:38.719770'),
(11, '9', 'Toilet Plumbing', 'Unclogging toilet and bathroom pipes.', 'Yan', 'Plumbing', 99.99, '2025-11-29 12:20:38.719770'),
(12, '10', 'Electrical Installation', 'Installation of ceiling fan and lighting fixtures.', 'Sik', 'Electrical', 99.99, '2025-11-29 12:20:38.719770'),
(13, '11', 'Room Painting', 'Painting a small to medium sized room.', 'Kubang Pasu', 'Painting', 99.99, '2025-11-29 12:20:38.719770'),
(14, '12', 'Full Car Wash', 'Exterior and interior cleaning for cars.', 'Bukit Kayu Hitam', 'Car Service', 40.00, '2025-11-29 12:20:38.719770'),
(15, '13', 'Tree Trimming', 'Small tree and hedge trimming.', 'Baling', 'Gardening', 90.00, '2025-11-29 12:20:38.719770'),
(16, '14', 'Handyman Service', 'General home fixing tasks and small repairs.', 'Bandar Baru', 'Other', 60.00, '2025-11-29 12:20:38.719770'),
(17, '15', 'Weekly Cleaning', 'Weekly scheduled home or room cleaning.', 'Kota Setar', 'Cleaning', 70.00, '2025-11-29 12:20:38.719770'),
(18, '16', 'Sink Repair', 'Fixing clogged kitchen or bathroom sinks.', 'Kuala Muda', 'Plumbing', 80.00, '2025-11-29 12:20:38.719770'),
(19, '17', 'Power Socket Repair', 'Fixing burnt or faulty power outlets.', 'Padang Terap', 'Electrical', 75.00, '2025-11-29 12:20:38.719770'),
(20, '18', 'Fence Painting', 'Painting outdoor fences and small gates.', 'Pokok Sena', 'Painting', 99.99, '2025-11-29 12:20:38.719770'),
(21, '19', 'Engine Check', 'General engine inspection and minor tuning.', 'Yan', 'Car Service', 99.99, '2025-11-29 12:20:38.719770'),
(22, '20', 'Planting Service', 'Planting flowers and small plants for home gardens.', 'Sik', 'Gardening', 50.00, '2025-11-29 12:20:38.719770'),
(23, '1', 'Kitchen Cleaning', 'Full kitchen cleaning including stove, sink, and floor.', 'Kubang Pasu', 'Cleaning', 95.00, '2025-11-29 13:28:20.000000'),
(24, '2', 'Water Heater Repair', 'Repairing faulty water heaters and minor pipe fittings.', 'Bukit Kayu Hitam', 'Plumbing', 99.99, '2025-11-29 13:28:20.000000'),
(25, '3', 'Fan & Light Setup', 'Installing ceiling fans and LED lights in homes.', 'Baling', 'Electrical', 85.00, '2025-11-29 13:28:20.000000'),
(26, '4', 'Exterior House Painting', 'Repainting exterior walls with weatherproof coating.', 'Bandar Baru', 'Painting', 99.99, '2025-11-29 13:28:20.000000'),
(27, '5', 'Brake Service', 'Brake pad inspection and replacement for cars.', 'Kota Setar', 'Car Service', 99.99, '2025-11-29 13:28:20.000000'),
(28, '6', 'Garden Soil Preparation', 'Preparing soil for planting and removing weeds.', 'Kuala Muda', 'Gardening', 60.00, '2025-11-29 13:28:20.000000'),
(29, '7', 'Minor Fix & Repairs', 'Fixing loose hinges, door handles, and small repairs.', 'Padang Terap', 'Other', 55.00, '2025-11-29 13:28:20.000000'),
(30, '8', 'Apartment Cleaning', 'Cleaning small apartments including bedroom and toilet.', 'Pokok Sena', 'Cleaning', 80.00, '2025-11-29 13:28:20.000000'),
(31, '9', 'Bathroom Leakage Fix', 'Detecting and fixing bathroom pipe leaks.', 'Yan', 'Plumbing', 99.99, '2025-11-29 13:28:20.000000'),
(32, '10', 'Circuit Breaker Repair', 'Repairing or installing new circuit breakers.', 'Sik', 'Electrical', 99.99, '2025-11-29 13:28:20.000000'),
(33, '11', 'Room Repainting', 'Repainting single room with two color options.', 'Kubang Pasu', 'Painting', 99.99, '2025-11-29 13:28:20.000000'),
(34, '12', 'Car Interior Vacuuming', 'Dust removal and vacuuming for car interior.', 'Bukit Kayu Hitam', 'Car Service', 45.00, '2025-11-29 13:28:20.000000'),
(35, '13', 'Flower Bed Design', 'Arranging flower beds and decorative garden layout.', 'Baling', 'Gardening', 75.00, '2025-11-29 13:28:20.000000'),
(36, '14', 'General House Helper', 'Assist with organizing, packing, and home chores.', 'Bandar Baru', 'Other', 50.00, '2025-11-29 13:28:20.000000'),
(37, '15', 'Weekly Maid Service', 'Weekly cleaning service for small homes.', 'Kota Setar', 'Cleaning', 99.99, '2025-11-29 13:28:20.000000'),
(38, '16', 'Sink Unclog Service', 'Removing food and hair blockage from sinks.', 'Kuala Muda', 'Plumbing', 70.00, '2025-11-29 13:28:20.000000'),
(39, '17', 'Switch Socket Replacement', 'Replacing burnt switches and damaged outlets.', 'Padang Terap', 'Electrical', 65.00, '2025-11-29 13:28:20.000000'),
(40, '18', 'Door & Gate Painting', 'Painting metal gates and wooden doors.', 'Pokok Sena', 'Painting', 99.99, '2025-11-29 13:28:20.000000'),
(41, '19', 'Tyre Pressure Check', 'Checking tyre pressure and basic tyre inspection.', 'Yan', 'Car Service', 25.00, '2025-11-29 13:28:20.000000'),
(42, '20', 'Small Plant Installation', 'Installing pots and small decorative plants.', 'Sik', 'Gardening', 45.00, '2025-11-29 13:28:20.000000'),
(43, '1', 'Gardening', 'We keep your garden in shape', 'Bukit Kayu Hitam', 'Gardening', 25.00, '2025-11-29 14:38:15.461015'),
(44, '1', 'Room Cleaning', 'Let us clean your house', 'Kota Setar', 'Maid Service', 50.00, '2025-11-29 15:05:12.822567');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_phone` varchar(15) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_otp` varchar(6) NOT NULL,
  `user_address` varchar(300) NOT NULL,
  `user_latitude` varchar(20) NOT NULL,
  `user_longitude` varchar(20) NOT NULL,
  `user_regdate` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`, `user_address`, `user_latitude`, `user_longitude`, `user_regdate`) VALUES
(1, 'ali@email.com', 'Ali bin Abu', '0194444555', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '432587', 'No. 12, Jalan Tanjung 3, 06000 Jitra, Kubang Pasu, Kedah', '6.4383', '100.1940', '2025-11-02 09:27:23.965748'),
(2, 'alice@email.com', 'Alice Tan', '0111234001', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '483920', 'No. 22, Jalan Harmoni 1, 06050 Bukit Kayu Hitam, Kedah', '6.4260', '100.4260', '2025-11-29 12:16:18.161896'),
(3, 'benjamin@email.com', 'Benjamin Lee', '0111234002', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '251734', 'No. 8, Jalan Bayu 5, 09100 Baling, Kedah', '5.6827', '100.9117', '2025-11-29 12:16:18.161896'),
(4, 'carmen@email.com', 'Carmen Wong', '0111234003', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '907162', 'No. 19, Taman Bahagia, 09600 Bandar Baharu, Kedah', '5.4943', '100.5080', '2025-11-29 12:16:18.161896'),
(5, 'daniel@email.com', 'Daniel Lim', '0111234004', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '642513', 'No. 77, Jalan Sultanah, 05100 Alor Setar, Kota Setar, Kedah', '6.1184', '100.3692', '2025-11-29 12:16:18.161896'),
(6, 'elena@email.com', 'Elena Ng', '0111234005', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '315890', 'No. 5, Lorong Dahlia, 08000 Sungai Petani, Kuala Muda, Kedah', '5.6470', '100.4870', '2025-11-29 12:16:18.161896'),
(7, 'farhan@email.com', 'Farhan Aziz', '0111234006', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '782640', 'No. 20, Jalan Merpati, 06300 Kuala Nerang, Padang Terap, Kedah', '6.2500', '100.6830', '2025-11-29 12:16:18.161896'),
(8, 'geetha@email.com', 'Geetha Devi', '0111234007', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '958123', 'No. 31, Jalan Sena Indah, 06400 Pokok Sena, Kedah', '6.1667', '100.4500', '2025-11-29 12:16:18.161896'),
(9, 'harris@email.com', 'Harris Tan', '0111234008', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '416872', 'No. 4, Taman Damai, 06900 Yan, Kedah', '5.8217', '100.4313', '2025-11-29 12:16:18.161896'),
(10, 'isabelle@email.com', 'Isabelle Lim', '0111234009', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '705243', 'No. 11, Jalan Cempaka, 08200 Sik, Kedah', '5.8024', '100.7340', '2025-11-29 12:16:18.161896'),
(11, 'jason@email.com', 'Jason Ong', '0111234010', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '624581', 'No. 9, Jalan Kenanga, 06000 Jitra, Kubang Pasu, Kedah', '6.4383', '100.1940', '2025-11-29 12:16:18.161896'),
(12, 'kimberly@email.com', 'Kimberly Teo', '0111234011', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '892367', 'No. 42, Taman Seri, 06050 Bukit Kayu Hitam, Kedah', '6.4260', '100.4260', '2025-11-29 12:16:18.161896'),
(13, 'leon@email.com', 'Leon Chua', '0111234012', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '349052', 'No. 15, Jalan Mawar, 09100 Baling, Kedah', '5.6827', '100.9117', '2025-11-29 12:16:18.161896'),
(14, 'maya@email.com', 'Maya Abdullah', '0111234013', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '760418', 'No. 28, Jalan Aman, 09600 Bandar Baharu, Kedah', '5.4943', '100.5080', '2025-11-29 12:16:18.161896'),
(15, 'nathan@email.com', 'Nathan Koh', '0111234014', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '237561', 'No. 6, Jalan Setar Muda, 05100 Alor Setar, Kota Setar, Kedah', '6.1184', '100.3692', '2025-11-29 12:16:18.161896'),
(16, 'olivia@email.com', 'Olivia Tan', '0111234015', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '548739', 'No. 33, Jalan Intan, 08000 Sungai Petani, Kuala Muda, Kedah', '5.6470', '100.4870', '2025-11-29 12:16:18.161896'),
(17, 'peter@email.com', 'Peter Chong', '0111234016', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '951672', 'No. 18, Jalan Sri Nerang, 06300 Kuala Nerang, Padang Terap, Kedah', '6.2500', '100.6830', '2025-11-29 12:16:18.161896'),
(18, 'qiara@email.com', 'Qiara Lee', '0111234017', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '124963', 'No. 2, Jalan Teratai, 06400 Pokok Sena, Kedah', '6.1667', '100.4500', '2025-11-29 12:16:18.161896'),
(19, 'raymond@email.com', 'Raymond Yap', '0111234018', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '689451', 'No. 7, Taman Ria, 06900 Yan, Kedah', '5.8217', '100.4313', '2025-11-29 12:16:18.161896'),
(20, 'sophia@email.com', 'Sophia Ahmad', '0111234019', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '305728', 'No. 12, Jalan Melur, 08200 Sik, Kedah', '5.8024', '100.7340', '2025-11-29 12:16:18.161896'),
(21, 'thomas@email.com', 'Thomas Goh', '0111234020', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '873194', 'No. 55, Jalan Tanjung 5, 06000 Jitra, Kubang Pasu, Kedah', '6.4383', '100.1940', '2025-11-29 12:16:18.161896');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_services`
--
ALTER TABLE `tbl_services`
  ADD PRIMARY KEY (`service_id`);

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
-- AUTO_INCREMENT for table `tbl_services`
--
ALTER TABLE `tbl_services`
  MODIFY `service_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
