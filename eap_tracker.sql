-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2026 at 03:07 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eap_tracker`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(40) NOT NULL,
  `detail` varchar(500) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`id`, `user_id`, `action`, `detail`, `created_at`) VALUES
(1, 1, 'login', 'admin', '2026-11-04 13:29:20'),
(2, 1, 'employee_updated', 'Barnachea, Connie M.', '2026-11-04 13:52:28'),
(3, 1, 'payment_added', 'Alburo, Ma. Ada N., Nov: ₱50 cash', '2026-11-04 13:53:09'),
(4, 1, 'payment_deleted', 'Alburo, Ma. Ada N., Nov: ₱50', '2026-11-04 13:53:14'),
(5, 1, 'collection_created', 'Collection #10 on 2026-11-04 (tab 1)', '2026-11-04 14:13:07'),
(6, 1, 'payment_added', 'Alburo, Ma. Ada N., Nov: ₱50 cash', '2026-11-04 14:13:07'),
(7, 1, 'payment_added', 'Alburo, Ma. Ada N., Dec: ₱50 cash', '2026-11-04 14:13:09'),
(8, 1, 'payment_added', 'Amaga, Jessa Marie O., Dec: ₱50 cash', '2026-11-04 14:13:10'),
(9, 1, 'payment_deleted', 'Amaga, Jessa Marie O., Dec: ₱50', '2026-11-04 14:13:15'),
(10, 1, 'payment_added', 'Cabarrubias, Rosario, Oct: ₱50 cash', '2026-11-04 14:13:32'),
(11, 1, 'payment_added', 'Cabarrubias, Rosario, Nov: ₱50 cash', '2026-11-04 14:13:33'),
(12, 1, 'payment_added', 'Facurib, Roxanne Jane S., Aug: ₱50 cash', '2026-11-04 14:13:54'),
(13, 1, 'payment_added', 'Facurib, Roxanne Jane S., Sep: ₱50 cash', '2026-11-04 14:13:55'),
(14, 1, 'payment_added', 'Facurib, Roxanne Jane S., Oct: ₱50 cash', '2026-11-04 14:13:55'),
(15, 1, 'payment_added', 'Facurib, Roxanne Jane S., Nov: ₱50 cash', '2026-11-04 14:13:56'),
(16, 1, 'payment_added', 'Facurib, Roxanne Jane S., Dec: ₱50 cash', '2026-11-04 14:13:57'),
(17, 1, 'payment_added', 'Gayosa, Noemi R., Sep: ₱50 cash', '2026-11-04 14:14:06'),
(18, 1, 'payment_added', 'Gayosa, Noemi R., Oct: ₱50 cash', '2026-11-04 14:14:07'),
(19, 1, 'payment_added', 'Gayosa, Noemi R., Nov: ₱50 cash', '2026-11-04 14:14:07'),
(20, 1, 'payment_added', 'Gayosa, Noemi R., Dec: ₱50 cash', '2026-11-04 14:14:08'),
(21, 1, 'payment_added', 'Lariba, Adrian Clave, Aug: ₱50 cash', '2026-11-04 14:14:56'),
(22, 1, 'payment_added', 'Lariba, Adrian Clave, Sep: ₱50 cash', '2026-11-04 14:14:57'),
(23, 1, 'collection_created', 'Collection #11 on 2026-11-04 (tab 2)', '2026-11-04 14:15:39'),
(24, 1, 'payment_added', 'Alburo, Ma. Ada N., Hautea: ₱100 cash', '2026-11-04 14:15:39'),
(25, 1, 'payment_added', 'Boston, Marlon Andrew B., Lariba: ₱100 cash', '2026-11-04 14:15:44'),
(26, 1, 'payment_added', 'Boston, Marlon Andrew B., Talino: ₱100 cash', '2026-11-04 14:15:45'),
(27, 1, 'payment_added', 'Boston, Marlon Andrew B., Hautea: ₱100 cash', '2026-11-04 14:15:45'),
(28, 1, 'payment_added', 'Facurib, Roxanne Jane S., Elosis: ₱100 cash', '2026-11-04 14:15:50'),
(29, 1, 'payment_added', 'Facurib, Roxanne Jane S., Urbano: ₱100 cash', '2026-11-04 14:15:50'),
(30, 1, 'payment_added', 'Facurib, Roxanne Jane S., Cipriano: ₱100 cash', '2026-11-04 14:15:51'),
(31, 1, 'payment_added', 'Facurib, Roxanne Jane S., Lariba: ₱100 cash', '2026-11-04 14:15:51'),
(32, 1, 'payment_added', 'Facurib, Roxanne Jane S., Talino: ₱100 cash', '2026-11-04 14:15:52'),
(33, 1, 'payment_added', 'Facurib, Roxanne Jane S., Hautea: ₱100 cash', '2026-11-04 14:15:52'),
(34, 1, 'payment_added', 'Cabarrubias, Rosario, Hautea: ₱100 cash', '2026-11-04 14:16:27'),
(35, 1, 'payment_added', 'Gayosa, Noemi R., Hautea: ₱100 cash', '2026-11-04 14:16:36'),
(36, 1, 'payment_updated', 'Gayosa, Noemi R., Hautea: ₱300 cash', '2026-11-04 14:16:41'),
(37, 1, 'payment_added', 'Sucgang, Charley Jay, Cipriano: ₱100 cash', '2026-11-04 14:16:47'),
(38, 1, 'payment_added', 'Sucgang, Charley Jay, Lariba: ₱100 cash', '2026-11-04 14:16:48'),
(39, 1, 'payment_added', 'Sucgang, Charley Jay, Talino: ₱100 cash', '2026-11-04 14:16:48'),
(40, 1, 'payment_added', 'Sucgang, Charley Jay, Hautea: ₱100 cash', '2026-11-04 14:16:49'),
(41, 1, 'payment_added', 'Nantes, Waren Jay B., Urbano: ₱100 cash', '2026-11-04 14:16:56'),
(42, 1, 'payment_added', 'Nantes, Waren Jay B., Cipriano: ₱100 cash', '2026-11-04 14:16:57'),
(43, 1, 'payment_added', 'Nantes, Waren Jay B., Lariba: ₱100 cash', '2026-11-04 14:16:57'),
(44, 1, 'payment_added', 'Nantes, Waren Jay B., Talino: ₱100 cash', '2026-11-04 14:16:57'),
(45, 1, 'payment_added', 'Nantes, Waren Jay B., Hautea: ₱100 cash', '2026-11-04 14:16:58'),
(46, 1, 'payment_added', 'Salvador, Imelda T, Urbano: ₱100 cash', '2026-11-04 14:17:04'),
(47, 1, 'payment_added', 'Salvador, Imelda T, Cipriano: ₱100 cash', '2026-11-04 14:17:04'),
(48, 1, 'payment_added', 'Salvador, Imelda T, Hautea: ₱100 cash', '2026-11-04 14:17:06'),
(49, 1, 'payment_added', 'Lariba, Adrian Clave, Talino: ₱100 cash', '2026-11-04 14:17:35'),
(50, 1, 'payment_added', 'Lariba, Adrian Clave, Hautea: ₱100 cash', '2026-11-04 14:17:35'),
(51, 1, 'payment_added', 'Lariba, Adrian Clave, Lariba: ₱100 cash', '2026-11-04 14:17:36'),
(52, 1, 'payment_updated', 'Lariba, Adrian Clave, Lariba: ₱1 cash', '2026-11-04 14:18:05'),
(53, 1, 'payment_deleted', 'Lariba, Adrian Clave, Lariba: ₱1', '2026-11-04 14:18:21'),
(54, 1, 'payment_added', 'Lubaton, Naye Joy A., Lariba: ₱100 cash', '2026-11-04 14:25:45'),
(55, 1, 'payment_added', 'Lubaton, Naye Joy A., Talino: ₱100 cash', '2026-11-04 14:25:46'),
(56, 1, 'payment_added', 'Lubaton, Naye Joy A., Hautea: ₱100 cash', '2026-11-04 14:25:46'),
(57, 1, 'remitted', 'Collection #4: ₱300 cash on 2026-07-23', '2026-11-04 14:36:27'),
(58, 1, 'login', 'admin', '2026-11-04 14:39:28'),
(59, 1, 'employee_updated', 'Cabarrubias, Rosario', '2026-11-04 14:42:47'),
(60, 1, 'payment_added', 'Cabarrubias, Rosario, Jul: ₱50 cash', '2026-11-04 14:42:53'),
(61, 1, 'payment_deleted', 'Cabarrubias, Rosario, Jul: ₱50', '2026-11-04 14:42:56'),
(62, 1, 'payment_added', 'Elosis, Edwin E., Elosis: ₱100 cash', '2026-11-04 14:47:12'),
(63, 1, 'payment_updated', 'Elosis, Edwin E., Elosis: ₱0 exempt', '2026-11-04 14:47:31'),
(64, 1, 'payment_added', 'Lariba, Adrian Clave, Lariba: ₱100 cash', '2026-11-04 14:47:36'),
(65, 1, 'payment_updated', 'Lariba, Adrian Clave, Lariba: ₱0 exempt', '2026-11-04 14:47:42'),
(66, 1, 'payment_added', 'Hautea, Hazel E., Hautea: ₱100 cash', '2026-11-04 14:47:50'),
(67, 1, 'payment_updated', 'Hautea, Hazel E., Hautea: ₱0 exempt', '2026-11-04 14:47:54'),
(68, 1, 'employee_updated', 'Ladublan, Mary Stephanie', '2026-11-04 14:48:24'),
(69, 1, 'payment_deleted', 'Cabarrubias, Rosario, Nov: ₱50', '2026-11-04 14:49:31'),
(70, 1, 'payment_added', 'Cabarrubias, Rosario, Nov: ₱50 cash', '2026-11-04 14:49:41'),
(71, 1, 'payment_added', 'Lariba, Adrian Clave, Oct: ₱50 cash', '2026-11-04 14:51:24'),
(72, 1, 'payment_deleted', 'Lariba, Adrian Clave, Oct: ₱50', '2026-11-04 14:51:34'),
(73, 1, 'payment_added', 'Cabarrubias, Rosario, Elosis: ₱0 exempt', '2026-11-04 14:53:13'),
(74, 1, 'payment_added', 'Cabarrubias, Rosario, Urbano: ₱100 cash', '2026-11-04 14:53:20'),
(75, 1, 'payment_updated', 'Cabarrubias, Rosario, Urbano: ₱0 exempt', '2026-11-04 14:53:24'),
(76, 1, 'payment_added', 'Cabarrubias, Rosario, Cipriano: ₱0 exempt', '2026-11-04 14:53:33'),
(77, 1, 'payment_added', 'Cabarrubias, Rosario, Lariba: ₱0 exempt', '2026-11-04 14:53:37'),
(78, 1, 'payment_added', 'Cabarrubias, Rosario, Talino: ₱0 exempt', '2026-11-04 14:53:41'),
(79, 1, 'payment_added', 'Ladublan, Mary Stephanie, Elosis: ₱0 exempt', '2026-11-04 14:53:47'),
(80, 1, 'payment_added', 'Ladublan, Mary Stephanie, Urbano: ₱0 exempt', '2026-11-04 14:53:51'),
(81, 1, 'payment_added', 'Ladublan, Mary Stephanie, Cipriano: ₱0 exempt', '2026-11-04 14:53:54'),
(82, 1, 'payment_added', 'Ladublan, Mary Stephanie, Lariba: ₱0 exempt', '2026-11-04 14:53:58'),
(83, 1, 'payment_added', 'Ladublan, Mary Stephanie, Talino: ₱0 exempt', '2026-11-04 14:54:01'),
(84, 1, 'payment_added', 'Quiriones, Joven S, Elosis: ₱0 exempt', '2026-11-04 14:55:38'),
(85, 1, 'payment_added', 'Quiriones, Joven S, Urbano: ₱0 exempt', '2026-11-04 14:55:42'),
(86, 1, 'login', 'admin', '2026-11-05 09:48:02'),
(87, 1, 'login', 'admin', '2026-11-05 09:49:40'),
(88, 1, 'collection_created', 'Collection #12 on 2026-11-05 (tab 2)', '2026-11-05 14:28:03'),
(89, 1, 'collection_deleted', 'Collection #12 on 2026-11-05', '2026-11-05 14:28:19'),
(90, 1, 'payment_added', 'Meniano, Kyle Krishia, Cipriano: ₱100 care_of', '2026-11-05 14:29:30'),
(91, 1, 'payment_added', 'Meniano, Kyle Krishia, Lariba: ₱100 care_of', '2026-11-05 14:29:37'),
(92, 1, 'payment_added', 'Meniano, Kyle Krishia, Talino: ₱100 care_of', '2026-11-05 14:29:42'),
(93, 1, 'payment_added', 'Meniano, Kyle Krishia, Hautea: ₱100 care_of', '2026-11-05 14:29:46'),
(94, 1, 'login', 'admin', '2026-11-06 16:39:36'),
(95, 1, 'login', 'admin', '2026-11-09 07:34:29'),
(96, 1, 'collection_created', 'Collection #13 on 2026-11-09 (tab 1)', '2026-11-09 07:36:57'),
(97, 1, 'collection_deleted', 'Collection #13 on 2026-11-09', '2026-11-09 14:39:50'),
(98, 1, 'login', 'admin', '2026-11-10 08:50:50'),
(99, 1, 'login', 'admin', '2026-11-12 08:13:39'),
(100, 1, 'login', 'admin', '2026-11-12 08:17:27'),
(101, 1, 'collection_created', 'Collection #14 on 2026-11-12 (tab 2)', '2026-11-12 08:45:36'),
(102, 1, 'payment_added', 'Vilbar, Ma. Christine B., Hautea: ₱100 cash', '2026-11-12 08:45:40'),
(103, 1, 'payment_deleted', 'Vilbar, Ma. Christine B., Hautea: ₱100', '2026-11-12 08:45:47'),
(104, 1, 'column_added', 'RABAYA (tab 2)', '2026-11-12 08:50:36'),
(105, 1, 'payment_added', 'Juanico, P. Jovelyn, Hautea: ₱100 cash', '2026-11-12 08:50:44'),
(106, 1, 'payment_added', 'Juanico, P. Jovelyn, RABAYA: ₱100 cash', '2026-11-12 08:50:45'),
(107, 1, 'payment_added', 'Chua, Ma. Theresa T., Hautea: ₱100 cash', '2026-11-12 08:53:34'),
(108, 1, 'payment_added', 'Chua, Ma. Theresa T., RABAYA: ₱100 cash', '2026-11-12 08:53:35'),
(109, 1, 'payment_deleted', 'Chua, Ma. Theresa T., RABAYA: ₱100', '2026-11-12 08:53:50'),
(110, 1, 'payment_deleted', 'Chua, Ma. Theresa T., Hautea: ₱100', '2026-11-12 08:53:55'),
(111, 1, 'payment_added', 'Tan, Christine Grace L., Hautea: ₱100 cash', '2026-11-12 08:56:07'),
(112, 1, 'payment_added', 'Tan, Christine Grace L., RABAYA: ₱100 cash', '2026-11-12 08:56:08'),
(113, 1, 'payment_added', 'Genita, Marvin V., Hautea: ₱100 cash', '2026-11-12 08:56:31'),
(114, 1, 'payment_updated', 'Genita, Marvin V., Hautea: ₱200 cash', '2026-11-12 08:56:40'),
(115, 1, 'payment_added', 'Genita, Marvin V., RABAYA: ₱100 cash', '2026-11-12 08:56:47'),
(116, 1, 'payment_updated', 'Genita, Marvin V., Hautea: ₱300 cash', '2026-11-12 08:57:03'),
(117, 1, 'payment_added', 'Escalona, Ma. Ellen T., Hautea: ₱100 cash', '2026-11-12 09:01:26'),
(118, 1, 'payment_added', 'Escalona, Ma. Ellen T., RABAYA: ₱100 cash', '2026-11-12 09:01:27'),
(119, 1, 'login', 'admin', '2026-11-12 09:02:50'),
(120, 1, 'login', 'admin', '2026-11-12 09:34:06'),
(121, 1, 'payment_added', 'Chua, Ma. Theresa T., Hautea: ₱100 fund_transfer', '2026-11-12 09:34:22'),
(122, 1, 'payment_added', 'Chua, Ma. Theresa T., RABAYA: ₱100 cash', '2026-11-12 09:34:26'),
(123, 1, 'payment_updated', 'Chua, Ma. Theresa T., RABAYA: ₱100 fund_transfer', '2026-11-12 09:34:31'),
(124, 1, 'payment_added', 'Toledo, Sarah Jane T., Urbano: ₱100 cash', '2026-11-12 09:37:34'),
(125, 1, 'payment_added', 'Toledo, Sarah Jane T., Cipriano: ₱100 cash', '2026-11-12 09:37:40'),
(126, 1, 'payment_added', 'Toledo, Sarah Jane T., Lariba: ₱100 cash', '2026-11-12 09:37:41'),
(127, 1, 'payment_added', 'Toledo, Sarah Jane T., Talino: ₱100 cash', '2026-11-12 09:37:42'),
(128, 1, 'payment_added', 'Toledo, Sarah Jane T., Hautea: ₱100 cash', '2026-11-12 09:37:43'),
(129, 1, 'payment_added', 'Toledo, Sarah Jane T., RABAYA: ₱100 cash', '2026-11-12 09:37:43');

-- --------------------------------------------------------

--
-- Table structure for table `collections`
--

CREATE TABLE `collections` (
  `id` int(11) NOT NULL,
  `fund_id` int(11) NOT NULL,
  `collected_on` date NOT NULL,
  `color` char(7) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `collections`
--

INSERT INTO `collections` (`id`, `fund_id`, `collected_on`, `color`, `note`, `created_by`, `created_at`) VALUES
(1, 1, '2026-02-06', '#378ADD', 'Batch 1. The workbook only gives its remitted date.', NULL, '2026-11-04 13:27:40'),
(2, 1, '2026-02-24', '#D4537E', NULL, NULL, '2026-11-04 13:27:40'),
(3, 1, '2026-04-30', '#639922', NULL, NULL, '2026-11-04 13:27:40'),
(4, 1, '2026-07-23', '#BA7517', NULL, NULL, '2026-11-04 13:27:40'),
(5, 1, '2026-08-25', '#E24B4A', NULL, NULL, '2026-11-04 13:27:40'),
(6, 1, '2026-09-10', '#1D9E75', NULL, NULL, '2026-11-04 13:27:40'),
(7, 2, '2026-07-23', '#BA7517', NULL, NULL, '2026-11-04 13:27:40'),
(8, 2, '2026-08-25', '#E24B4A', NULL, NULL, '2026-11-04 13:27:40'),
(9, 2, '2026-09-10', '#1D9E75', NULL, NULL, '2026-11-04 13:27:40'),
(10, 1, '2026-11-04', '#7F77DD', NULL, 1, '2026-11-04 14:13:07'),
(11, 2, '2026-11-04', '#7F77DD', NULL, 1, '2026-11-04 14:15:39'),
(14, 2, '2026-11-12', '#378ADD', NULL, 1, '2026-11-12 08:45:36');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `division` varchar(30) NOT NULL DEFAULT '',
  `status` enum('enrolled','not_enrolled','scholarship','transferred') NOT NULL DEFAULT 'enrolled',
  `start_on` date DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `name`, `division`, `status`, `start_on`, `remarks`, `active`, `created_at`) VALUES
(1, 'Alburo, Ma. Ada N.', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(2, 'Amaga, Jessa Marie O.', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(3, 'Barnachea, Connie M.', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(4, 'Bautista, Rhenell', 'SDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(5, 'Bercades, Aiza Marie P.', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(6, 'Boston, Marlon Andrew B.', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(7, 'Ealdama, Epifania L.', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(8, 'Cabarrubias, Rosario', 'AFMD', 'enrolled', '2026-10-01', NULL, 1, '2026-11-04 13:27:40'),
(9, 'Capecio, Elbert G.', 'CPD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(10, 'Chua, Ma. Theresa T.', 'SDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(11, 'David, John Kenneth C.', 'CPD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(12, 'Escalona, Ma. Ellen T.', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(13, 'Facurib, Roxanne Jane S.', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(14, 'Gabunales, Flora Politud', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(15, 'Gayosa, Noemi R.', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(16, 'Genita, Marvin V.', 'SDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(17, 'Hautea, Hazel E.', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(18, 'Juanico, P. Jovelyn', 'SDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(19, 'Ladublan, Mary Stephanie', 'AFMD', 'enrolled', '2026-10-01', NULL, 1, '2026-11-04 13:27:40'),
(20, 'Layda, Arnel E.', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(21, 'Lubaton, Jinnard', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(22, 'Lubaton, Naye Joy A.', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(23, 'Manalo, Elliza C.', 'SDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(24, 'Man-on Geovanni', 'CPD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(25, 'Martirizar, Dagny Athena A.', 'IDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(26, 'Meniano, Kyle Krishia', 'AFMD', 'enrolled', NULL, 'Promoted to DTI NC', 1, '2026-11-04 13:27:40'),
(27, 'Monsale, Karl Francis', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(28, 'Morala, Niel Anthony T.', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(29, 'Morales, Mary Ann', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(30, 'Nantes, Waren Jay B.', 'CPD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(31, 'Quiriones, Joven S', 'MSSD', 'scholarship', NULL, NULL, 1, '2026-11-04 13:27:40'),
(32, 'Salvador, Imelda T', 'IDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(33, 'Sucgang, Charley Jay', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(34, 'Sucol, Mildred T.', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(35, 'Tan, Christine Grace L.', 'IDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(36, 'Toledo, Sarah Jane T.', 'AFMD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(37, 'Vilbar, Ma. Christine B.', 'IDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(38, 'Villar, Angelito B.', 'SDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(39, 'Villareal, Noel P.', 'MSSD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(40, 'Ferolino, Elaine Nita L.', 'CPD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(41, 'Elosis, Edwin E.', 'JOCOS', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(42, 'Goloran, Ramil B.', 'JOCOS', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(43, 'Jaspe, Joel S.', 'JOCOS', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(44, 'Lariba, Adrian Clave', 'SDD', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(45, 'Maglana, William A.', 'JOCOS', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(46, 'Ortiz, Izzy Kate S.', 'JOCOS', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(47, 'Pajel, Mary Joy L.', 'JOCOS', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(48, 'Galve, Hermell', 'JOCOS', 'enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(49, 'Delegario, Frances', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(50, 'Mariano, Jerick D.', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(51, 'Depano, Jennifer M.', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(52, 'Lubaton, Rica Mae L.', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(53, 'Basiya, Serafin Jay S.', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(54, 'Bague, Rowena', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(55, 'Jimenez, Rowena', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(56, 'Dela Cruz, Japhet', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40'),
(57, 'Basid, Benjo G.', '', 'not_enrolled', NULL, NULL, 1, '2026-11-04 13:27:40');

-- --------------------------------------------------------

--
-- Table structure for table `funds`
--

CREATE TABLE `funds` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `default_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `sort_no` smallint(6) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `funds`
--

INSERT INTO `funds` (`id`, `name`, `default_amount`, `sort_no`, `active`) VALUES
(1, '2026', 50.00, 1, 1),
(2, '2026 Mandatory', 100.00, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `collection_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `mode` enum('cash','fund_transfer','direct','care_of','exempt') NOT NULL DEFAULT 'cash',
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `employee_id`, `period_id`, `collection_id`, `amount`, `mode`, `note`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(2, 1, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(3, 1, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(4, 1, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(5, 1, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(6, 1, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(7, 1, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(8, 1, 8, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(9, 1, 9, 6, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(10, 1, 10, 6, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(11, 2, 1, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(12, 2, 2, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(13, 2, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(14, 2, 4, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(15, 2, 5, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(16, 2, 6, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(17, 2, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(18, 2, 8, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(19, 3, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(20, 3, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(21, 3, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(22, 3, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(23, 4, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(24, 4, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(25, 4, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(26, 4, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(27, 4, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(28, 4, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(29, 4, 7, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(30, 4, 8, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(31, 5, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(32, 5, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(33, 5, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(34, 5, 4, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(35, 5, 5, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(36, 5, 6, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(37, 5, 7, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(38, 5, 8, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(39, 5, 9, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(40, 5, 10, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(41, 5, 11, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(42, 5, 12, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(43, 6, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(44, 6, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(45, 6, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(46, 6, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(47, 6, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(48, 6, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(49, 7, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(50, 7, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(51, 7, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(52, 7, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(53, 9, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(54, 9, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(55, 9, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(56, 9, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(57, 9, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(58, 9, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(59, 9, 7, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(60, 10, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(61, 10, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(62, 10, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(63, 10, 4, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(64, 10, 5, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(65, 10, 6, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(66, 10, 7, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(67, 11, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(68, 11, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(69, 12, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(70, 12, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(71, 12, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(72, 12, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(73, 12, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(74, 13, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(75, 13, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(76, 13, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(77, 13, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(78, 13, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(79, 13, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(80, 13, 7, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(81, 14, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(82, 14, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(83, 14, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(84, 14, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(85, 14, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(86, 14, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(87, 15, 1, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(88, 15, 2, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(89, 15, 3, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(90, 15, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(91, 15, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(92, 15, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(93, 15, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(94, 15, 8, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(95, 16, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(96, 16, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(97, 16, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(98, 16, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(99, 16, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(100, 16, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(101, 16, 7, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(102, 16, 8, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(103, 16, 9, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(104, 17, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(105, 17, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(106, 17, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(107, 17, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(108, 17, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(109, 17, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(110, 17, 7, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(111, 17, 8, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(112, 18, 1, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(113, 18, 2, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(114, 18, 3, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(115, 18, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(116, 18, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(117, 18, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(118, 18, 7, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(119, 18, 8, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(120, 18, 9, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(121, 18, 10, 4, 50.00, 'fund_transfer', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(122, 18, 11, 4, 50.00, 'fund_transfer', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(123, 18, 12, 4, 50.00, 'fund_transfer', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(124, 21, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(125, 21, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(126, 21, 3, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(127, 21, 4, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(128, 22, 1, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(129, 22, 2, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(130, 22, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(131, 22, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(132, 22, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(133, 22, 6, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(134, 22, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(135, 22, 8, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(136, 22, 9, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(137, 22, 10, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(138, 22, 11, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(139, 22, 12, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(140, 24, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(141, 24, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(142, 24, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(143, 24, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(144, 24, 5, 4, 50.00, 'fund_transfer', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(145, 24, 6, 4, 50.00, 'fund_transfer', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(146, 24, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(147, 24, 8, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(148, 25, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(149, 25, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(150, 25, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(151, 25, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(152, 25, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(153, 25, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(154, 25, 7, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(155, 25, 8, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(156, 25, 9, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(157, 25, 10, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(158, 25, 11, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(159, 25, 12, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(160, 26, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(161, 26, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(162, 26, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(163, 26, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(164, 26, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(165, 27, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(166, 27, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(167, 27, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(168, 27, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(169, 27, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(170, 27, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(171, 28, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(172, 28, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(173, 28, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(174, 28, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(175, 28, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(176, 28, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(177, 29, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(178, 29, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(179, 29, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(180, 29, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(181, 29, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(182, 29, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(183, 30, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(184, 30, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(185, 30, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(186, 30, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(187, 30, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(188, 31, 8, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(189, 32, 1, 2, 50.00, 'fund_transfer', 'FT Feb 11', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(190, 32, 2, 2, 50.00, 'fund_transfer', 'FT Feb 11', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(191, 32, 3, 2, 50.00, 'fund_transfer', 'FT Feb 11', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(192, 33, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(193, 33, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(194, 33, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(195, 33, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(196, 33, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(197, 33, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(198, 33, 7, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(199, 33, 8, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(200, 33, 9, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(201, 33, 10, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(202, 33, 11, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(203, 33, 12, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(204, 34, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(205, 34, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(206, 34, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(207, 34, 4, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(208, 34, 5, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(209, 34, 6, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(210, 34, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(211, 35, 1, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(212, 35, 2, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(213, 35, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(214, 35, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(215, 35, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(216, 35, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(217, 36, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(218, 36, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(219, 36, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(220, 36, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(221, 36, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(222, 36, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(223, 36, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(224, 37, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(225, 37, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(226, 37, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(227, 37, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(228, 37, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(229, 37, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(230, 38, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(231, 38, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(232, 38, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(233, 38, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(234, 38, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(235, 38, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(236, 38, 7, 6, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(237, 38, 8, 6, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(238, 38, 9, 6, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(239, 38, 10, 6, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(240, 40, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(241, 40, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(242, 40, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(243, 40, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(244, 40, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(245, 40, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(246, 41, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(247, 41, 2, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(248, 41, 3, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(249, 41, 4, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(250, 41, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(251, 41, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(252, 41, 7, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(253, 43, 1, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(254, 43, 2, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(255, 43, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(256, 43, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(257, 43, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(258, 43, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(259, 43, 7, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(260, 43, 8, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(261, 43, 9, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(262, 44, 1, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(263, 44, 2, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(264, 44, 3, 2, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(265, 44, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(266, 44, 5, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(267, 44, 6, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(268, 44, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(269, 46, 1, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(270, 46, 2, 1, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(271, 46, 3, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(272, 46, 4, 3, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(273, 46, 5, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(274, 46, 6, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(275, 46, 7, 5, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(276, 48, 1, 4, 50.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(277, 2, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(278, 2, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(279, 2, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(280, 2, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(281, 2, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(282, 1, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(283, 1, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(284, 1, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(285, 1, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(286, 1, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(287, 5, 13, 7, 200.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(288, 5, 14, 7, 200.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(289, 5, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(290, 6, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(291, 6, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(292, 6, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(293, 7, 13, NULL, 1000.00, 'direct', 'Direct (1k)', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(294, 7, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(295, 14, 13, NULL, 0.00, 'direct', 'Direct', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(296, 14, 14, NULL, 0.00, 'direct', 'Direct', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(297, 14, 15, NULL, 0.00, 'direct', 'Direct', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(298, 22, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(299, 22, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(300, 22, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(301, 27, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(302, 27, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(303, 29, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(304, 31, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(305, 31, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(306, 31, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(307, 3, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(308, 12, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(309, 12, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(310, 12, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(311, 12, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(312, 12, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(313, 15, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(314, 15, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(315, 15, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(316, 15, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(317, 15, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(318, 17, 13, NULL, 0.00, 'direct', 'Direct', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(319, 17, 14, 7, 500.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(320, 17, 15, NULL, 0.00, 'direct', 'Direct', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(321, 17, 16, 8, 300.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(322, 17, 17, 8, 200.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(323, 21, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(324, 21, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(325, 21, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(326, 28, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(327, 28, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(328, 33, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(329, 33, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(330, 34, 13, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(331, 34, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(332, 34, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(333, 36, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(334, 26, 13, NULL, 0.00, 'care_of', 'c/o NC', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(335, 26, 14, NULL, 0.00, 'care_of', 'c/o NC', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(336, 9, 13, 7, 200.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(337, 9, 14, NULL, 0.00, 'care_of', 'c/o SC', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(338, 9, 15, NULL, 0.00, 'care_of', 'c/o SC', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(339, 40, 13, NULL, 0.00, 'care_of', 'c/o SC', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(340, 40, 14, NULL, 0.00, 'care_of', 'c/o SC', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(341, 40, 15, 8, 200.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(342, 40, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(343, 40, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(344, 11, 13, NULL, 0.00, 'care_of', 'c/o NC', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(345, 11, 14, NULL, 0.00, 'care_of', 'c/o NC', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(346, 24, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(347, 24, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(348, 24, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(349, 24, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(350, 24, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(351, 30, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(352, 25, 13, 7, 300.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(353, 25, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(354, 25, 15, NULL, 0.00, 'direct', 'Direct', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(355, 25, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(356, 25, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(357, 32, 13, NULL, 1000.00, 'direct', 'Direct (1k)', NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(358, 32, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(359, 32, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(360, 35, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(361, 35, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(362, 35, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(363, 35, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(364, 35, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(365, 4, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(366, 4, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(367, 4, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(368, 4, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(369, 4, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(370, 10, 13, 7, 200.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(371, 10, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(372, 10, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(373, 10, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(374, 10, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(375, 16, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(376, 16, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(377, 16, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(378, 16, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(379, 16, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(380, 18, 13, 7, 200.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(381, 18, 14, 7, 200.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(382, 18, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(383, 18, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(384, 18, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(385, 44, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(386, 44, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(387, 44, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(388, 23, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(389, 23, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(390, 23, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(391, 38, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(392, 38, 14, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(393, 38, 15, 9, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(394, 38, 16, 9, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(395, 38, 17, 9, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(396, 43, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(397, 43, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(398, 43, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(399, 43, 16, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(400, 43, 17, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(401, 46, 13, 7, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(402, 46, 14, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(403, 46, 15, 8, 100.00, 'cash', NULL, NULL, '2026-11-04 13:27:40', '2026-11-04 13:27:40'),
(405, 1, 11, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:13:07', '2026-11-04 14:13:07'),
(406, 1, 12, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:13:09', '2026-11-04 14:13:09'),
(408, 8, 10, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:13:32', '2026-11-04 14:13:32'),
(410, 13, 8, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:13:54', '2026-11-04 14:13:54'),
(411, 13, 9, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:13:55', '2026-11-04 14:13:55'),
(412, 13, 10, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:13:55', '2026-11-04 14:13:55'),
(413, 13, 11, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:13:56', '2026-11-04 14:13:56'),
(414, 13, 12, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:13:57', '2026-11-04 14:13:57'),
(415, 15, 9, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:14:06', '2026-11-04 14:14:06'),
(416, 15, 10, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:14:07', '2026-11-04 14:14:07'),
(417, 15, 11, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:14:07', '2026-11-04 14:14:07'),
(418, 15, 12, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:14:08', '2026-11-04 14:14:08'),
(419, 44, 8, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:14:56', '2026-11-04 14:14:56'),
(420, 44, 9, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:14:57', '2026-11-04 14:14:57'),
(421, 1, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:39', '2026-11-04 14:15:39'),
(422, 6, 16, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:44', '2026-11-04 14:15:44'),
(423, 6, 17, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:45', '2026-11-04 14:15:45'),
(424, 6, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:45', '2026-11-04 14:15:45'),
(425, 13, 13, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:50', '2026-11-04 14:15:50'),
(426, 13, 14, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:50', '2026-11-04 14:15:50'),
(427, 13, 15, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:51', '2026-11-04 14:15:51'),
(428, 13, 16, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:51', '2026-11-04 14:15:51'),
(429, 13, 17, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:52', '2026-11-04 14:15:52'),
(430, 13, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:15:52', '2026-11-04 14:15:52'),
(431, 8, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:27', '2026-11-04 14:16:27'),
(432, 15, 18, 11, 300.00, 'cash', NULL, 1, '2026-11-04 14:16:36', '2026-11-04 14:16:41'),
(433, 33, 15, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:47', '2026-11-04 14:16:47'),
(434, 33, 16, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:48', '2026-11-04 14:16:48'),
(435, 33, 17, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:48', '2026-11-04 14:16:48'),
(436, 33, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:49', '2026-11-04 14:16:49'),
(437, 30, 14, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:56', '2026-11-04 14:16:56'),
(438, 30, 15, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:57', '2026-11-04 14:16:57'),
(439, 30, 16, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:57', '2026-11-04 14:16:57'),
(440, 30, 17, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:57', '2026-11-04 14:16:57'),
(441, 30, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:16:58', '2026-11-04 14:16:58'),
(442, 32, 14, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:17:04', '2026-11-04 14:17:04'),
(443, 32, 15, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:17:04', '2026-11-04 14:17:04'),
(444, 32, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:17:06', '2026-11-04 14:17:06'),
(445, 44, 17, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:17:35', '2026-11-04 14:17:35'),
(446, 44, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:17:35', '2026-11-04 14:17:35'),
(448, 22, 16, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:25:45', '2026-11-04 14:25:45'),
(449, 22, 17, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:25:46', '2026-11-04 14:25:46'),
(450, 22, 18, 11, 100.00, 'cash', NULL, 1, '2026-11-04 14:25:46', '2026-11-04 14:25:46'),
(452, 41, 13, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:47:12', '2026-11-04 14:47:31'),
(453, 44, 16, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:47:36', '2026-11-04 14:47:42'),
(454, 17, 18, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:47:50', '2026-11-04 14:47:54'),
(455, 8, 11, 10, 50.00, 'cash', NULL, 1, '2026-11-04 14:49:41', '2026-11-04 14:49:41'),
(457, 8, 13, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:13', '2026-11-04 14:53:13'),
(458, 8, 14, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:20', '2026-11-04 14:53:24'),
(459, 8, 15, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:33', '2026-11-04 14:53:33'),
(460, 8, 16, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:37', '2026-11-04 14:53:37'),
(461, 8, 17, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:41', '2026-11-04 14:53:41'),
(462, 19, 13, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:47', '2026-11-04 14:53:47'),
(463, 19, 14, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:51', '2026-11-04 14:53:51'),
(464, 19, 15, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:54', '2026-11-04 14:53:54'),
(465, 19, 16, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:53:58', '2026-11-04 14:53:58'),
(466, 19, 17, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:54:01', '2026-11-04 14:54:01'),
(467, 31, 13, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:55:38', '2026-11-04 14:55:38'),
(468, 31, 14, NULL, 0.00, 'exempt', NULL, 1, '2026-11-04 14:55:42', '2026-11-04 14:55:42'),
(469, 26, 15, NULL, 100.00, 'care_of', NULL, 1, '2026-11-05 14:29:30', '2026-11-05 14:29:30'),
(470, 26, 16, NULL, 100.00, 'care_of', NULL, 1, '2026-11-05 14:29:37', '2026-11-05 14:29:37'),
(471, 26, 17, NULL, 100.00, 'care_of', NULL, 1, '2026-11-05 14:29:42', '2026-11-05 14:29:42'),
(472, 26, 18, NULL, 100.00, 'care_of', NULL, 1, '2026-11-05 14:29:46', '2026-11-05 14:29:46'),
(474, 18, 18, 14, 100.00, 'cash', NULL, 1, '2026-11-12 08:50:44', '2026-11-12 08:50:44'),
(475, 18, 19, 14, 100.00, 'cash', NULL, 1, '2026-11-12 08:50:45', '2026-11-12 08:50:45'),
(478, 35, 18, 14, 100.00, 'cash', NULL, 1, '2026-11-12 08:56:07', '2026-11-12 08:56:07'),
(479, 35, 19, 14, 100.00, 'cash', NULL, 1, '2026-11-12 08:56:08', '2026-11-12 08:56:08'),
(480, 16, 18, 14, 300.00, 'cash', NULL, 1, '2026-11-12 08:56:31', '2026-11-12 08:57:03'),
(481, 16, 19, 14, 100.00, 'cash', NULL, 1, '2026-11-12 08:56:47', '2026-11-12 08:56:47'),
(482, 12, 18, 14, 100.00, 'cash', NULL, 1, '2026-11-12 09:01:26', '2026-11-12 09:01:26'),
(483, 12, 19, 14, 100.00, 'cash', NULL, 1, '2026-11-12 09:01:27', '2026-11-12 09:01:27'),
(484, 10, 18, 14, 100.00, 'fund_transfer', NULL, 1, '2026-11-12 09:34:22', '2026-11-12 09:34:22'),
(485, 10, 19, 14, 100.00, 'fund_transfer', NULL, 1, '2026-11-12 09:34:26', '2026-11-12 09:34:31'),
(486, 36, 14, 14, 100.00, 'cash', NULL, 1, '2026-11-12 09:37:34', '2026-11-12 09:37:34'),
(487, 36, 15, 14, 100.00, 'cash', NULL, 1, '2026-11-12 09:37:40', '2026-11-12 09:37:40'),
(488, 36, 16, 14, 100.00, 'cash', NULL, 1, '2026-11-12 09:37:41', '2026-11-12 09:37:41'),
(489, 36, 17, 14, 100.00, 'cash', NULL, 1, '2026-11-12 09:37:42', '2026-11-12 09:37:42'),
(490, 36, 18, 14, 100.00, 'cash', NULL, 1, '2026-11-12 09:37:43', '2026-11-12 09:37:43'),
(491, 36, 19, 14, 100.00, 'cash', NULL, 1, '2026-11-12 09:37:43', '2026-11-12 09:37:43');

-- --------------------------------------------------------

--
-- Table structure for table `periods`
--

CREATE TABLE `periods` (
  `id` int(11) NOT NULL,
  `fund_id` int(11) NOT NULL,
  `label` varchar(40) NOT NULL,
  `due_on` date DEFAULT NULL,
  `beneficiary_id` int(11) DEFAULT NULL,
  `sort_no` smallint(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `periods`
--

INSERT INTO `periods` (`id`, `fund_id`, `label`, `due_on`, `beneficiary_id`, `sort_no`) VALUES
(1, 1, 'Jan', '2026-01-01', NULL, 1),
(2, 1, 'Feb', '2026-02-01', NULL, 2),
(3, 1, 'Mar', '2026-03-01', NULL, 3),
(4, 1, 'Apr', '2026-04-01', NULL, 4),
(5, 1, 'May', '2026-05-01', NULL, 5),
(6, 1, 'Jun', '2026-06-01', NULL, 6),
(7, 1, 'Jul', '2026-07-01', NULL, 7),
(8, 1, 'Aug', '2026-08-01', NULL, 8),
(9, 1, 'Sep', '2026-09-01', NULL, 9),
(10, 1, 'Oct', '2026-10-01', NULL, 10),
(11, 1, 'Nov', '2026-11-01', NULL, 11),
(12, 1, 'Dec', '2026-12-01', NULL, 12),
(13, 2, 'Elosis', NULL, 41, 1),
(14, 2, 'Urbano', NULL, NULL, 2),
(15, 2, 'Cipriano', NULL, NULL, 3),
(16, 2, 'Lariba', NULL, 44, 4),
(17, 2, 'Talino', NULL, NULL, 5),
(18, 2, 'Hautea', NULL, 17, 6),
(19, 2, 'RABAYA', NULL, NULL, 7);

-- --------------------------------------------------------

--
-- Table structure for table `remittances`
--

CREATE TABLE `remittances` (
  `id` int(11) NOT NULL,
  `collection_id` int(11) NOT NULL,
  `remitted_on` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `mode` enum('cash','fund_transfer','care_of') NOT NULL DEFAULT 'cash',
  `reference` varchar(100) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `remittances`
--

INSERT INTO `remittances` (`id`, `collection_id`, `remitted_on`, `amount`, `mode`, `reference`, `created_by`, `created_at`) VALUES
(1, 1, '2026-02-06', 700.00, 'cash', 'Imported from workbook note', NULL, '2026-11-04 13:27:41'),
(2, 2, '2026-03-19', 2500.00, 'cash', 'Imported from workbook note', NULL, '2026-11-04 13:27:41'),
(3, 3, '2026-06-11', 4000.00, 'cash', 'Imported from workbook note', NULL, '2026-11-04 13:27:41'),
(4, 4, '2026-07-23', 900.00, 'care_of', 'c/o nonoy collection', NULL, '2026-11-04 13:27:41'),
(5, 4, '2026-07-23', 3750.00, 'fund_transfer', 'FT', NULL, '2026-11-04 13:27:41'),
(6, 7, '2026-07-23', 5400.00, 'cash', 'Imported from workbook note', NULL, '2026-11-04 13:27:41'),
(7, 4, '2026-07-23', 300.00, 'cash', NULL, 1, '2026-11-04 14:36:27');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(40) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','staff') NOT NULL DEFAULT 'staff',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `full_name`, `password_hash`, `role`, `active`, `created_at`) VALUES
(1, 'admin', 'ADMIN', '$2y$10$isftS0z7FWO2TRkfKdvxZu5h14JzLddLiM8vSSGeviqVyVVqx.tGS', 'admin', 1, '2026-11-04 13:29:20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `collections`
--
ALTER TABLE `collections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_fund_date` (`fund_id`,`collected_on`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_division_name` (`division`,`name`);

--
-- Indexes for table `funds`
--
ALTER TABLE `funds`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `one_cell` (`employee_id`,`period_id`),
  ADD KEY `idx_collection` (`collection_id`),
  ADD KEY `period_id` (`period_id`);

--
-- Indexes for table `periods`
--
ALTER TABLE `periods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_fund_label` (`fund_id`,`label`),
  ADD KEY `fk_period_beneficiary` (`beneficiary_id`);

--
-- Indexes for table `remittances`
--
ALTER TABLE `remittances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_collection` (`collection_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT for table `collections`
--
ALTER TABLE `collections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `funds`
--
ALTER TABLE `funds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=492;

--
-- AUTO_INCREMENT for table `periods`
--
ALTER TABLE `periods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `remittances`
--
ALTER TABLE `remittances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `collections`
--
ALTER TABLE `collections`
  ADD CONSTRAINT `collections_ibfk_1` FOREIGN KEY (`fund_id`) REFERENCES `funds` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`period_id`) REFERENCES `periods` (`id`),
  ADD CONSTRAINT `payments_ibfk_3` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`);

--
-- Constraints for table `periods`
--
ALTER TABLE `periods`
  ADD CONSTRAINT `fk_period_beneficiary` FOREIGN KEY (`beneficiary_id`) REFERENCES `employees` (`id`),
  ADD CONSTRAINT `periods_ibfk_1` FOREIGN KEY (`fund_id`) REFERENCES `funds` (`id`);

--
-- Constraints for table `remittances`
--
ALTER TABLE `remittances`
  ADD CONSTRAINT `remittances_ibfk_1` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
