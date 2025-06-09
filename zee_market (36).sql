-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 09/06/2025 às 06:20
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `zee_market`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `admin_logs`
--

CREATE TABLE `admin_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `admin_logs`
--

INSERT INTO `admin_logs` (`id`, `user_id`, `action`, `details`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 0, 'purchase_created', '{\"compra_id\":43,\"produto_id\":21,\"valor_btc\":1.0e-5,\"taxa_plataforma\":2.5000000000000004e-7,\"btc_price_usd\":100000}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '2025-06-04 01:00:51'),
(2, 0, 'purchase_created', '{\"compra_id\":44,\"produto_id\":21,\"valor_btc\":1.0e-5,\"taxa_plataforma\":2.5000000000000004e-7,\"btc_price_usd\":100000}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '2025-06-04 01:01:16');

-- --------------------------------------------------------

--
-- Estrutura para tabela `admin_notifications`
--

CREATE TABLE `admin_notifications` (
  `id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `balance_history`
--

CREATE TABLE `balance_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `crypto` varchar(10) NOT NULL,
  `type` enum('credit','debit') NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `balance_before` decimal(18,8) NOT NULL,
  `balance_after` decimal(18,8) NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `reference_type` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `bitcoin_mixing`
--

CREATE TABLE `bitcoin_mixing` (
  `id` int(11) NOT NULL,
  `mixing_id` varchar(50) NOT NULL,
  `input_address` varchar(100) NOT NULL,
  `input_amount` decimal(18,8) NOT NULL,
  `output_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`output_data`)),
  `mixing_fee` decimal(18,8) NOT NULL,
  `delay_blocks` int(11) DEFAULT 1,
  `status` enum('pending','processing','completed','failed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `btc_balance_history`
--

CREATE TABLE `btc_balance_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('credit','debit') NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `balance_before` decimal(18,8) DEFAULT 0.00000000,
  `balance_after` decimal(18,8) DEFAULT 0.00000000,
  `description` text DEFAULT NULL,
  `tx_hash` varchar(100) DEFAULT NULL,
  `crypto_type` varchar(10) DEFAULT 'BTC',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `btc_transactions`
--

CREATE TABLE `btc_transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tx_hash` varchar(64) NOT NULL,
  `amount` decimal(16,8) NOT NULL,
  `status` enum('pending','confirmed','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `crypto_type` varchar(10) DEFAULT 'BTC',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `type` enum('deposit','withdrawal') DEFAULT 'deposit',
  `fee` decimal(18,8) DEFAULT 0.00000000,
  `to_address` varchar(100) DEFAULT NULL,
  `block_height` int(11) DEFAULT 0,
  `notes` text DEFAULT NULL,
  `confirmations` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `btc_wallet_changes`
--

CREATE TABLE `btc_wallet_changes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `old_wallet` varchar(100) DEFAULT NULL,
  `new_wallet` varchar(100) DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `changed_by` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cold_storage_requests`
--

CREATE TABLE `cold_storage_requests` (
  `id` int(11) NOT NULL,
  `crypto` varchar(10) NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('pending','approved','rejected','completed') DEFAULT 'pending',
  `approved_by` int(11) DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `compras`
--

CREATE TABLE `compras` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `endereco` text NOT NULL,
  `btc_wallet_comprador` varchar(255) NOT NULL,
  `btc_wallet_vendedor` varchar(255) NOT NULL,
  `data_compra` timestamp NOT NULL DEFAULT current_timestamp(),
  `vendedor_id` int(11) NOT NULL,
  `concluido` tinyint(1) DEFAULT 0,
  `valor_btc` decimal(16,8) NOT NULL,
  `taxa_plataforma` decimal(16,8) NOT NULL,
  `wallet_plataforma` varchar(100) NOT NULL,
  `pago` tinyint(1) DEFAULT 0,
  `tx_hash` varchar(100) DEFAULT NULL,
  `confirmations` int(11) DEFAULT 0,
  `payment_log` text DEFAULT NULL,
  `valor_recebido` decimal(18,8) DEFAULT 0.00000000,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `compras_seguras`
--

CREATE TABLE `compras_seguras` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `vendedor_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `endereco` text NOT NULL,
  `btc_wallet_comprador` varchar(100) DEFAULT NULL,
  `payment_method` enum('balance','external') NOT NULL,
  `preco_usd` decimal(10,2) NOT NULL,
  `preco_btc_cotacao` decimal(15,2) NOT NULL,
  `valor_btc_total` decimal(18,8) NOT NULL,
  `taxa_plataforma_percent` decimal(5,4) NOT NULL,
  `taxa_plataforma_btc` decimal(18,8) NOT NULL,
  `valor_vendedor_btc` decimal(18,8) NOT NULL,
  `payment_address` varchar(100) DEFAULT NULL,
  `tx_hash` varchar(100) DEFAULT NULL,
  `confirmations` int(11) DEFAULT 0,
  `escrow_id` int(11) DEFAULT NULL,
  `risk_score` int(11) DEFAULT 0,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `status` enum('pending','paid','confirmed','shipped','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `crypto_rates`
--

CREATE TABLE `crypto_rates` (
  `id` int(11) NOT NULL,
  `btc_usd` decimal(10,2) DEFAULT NULL,
  `eth_usd` decimal(10,2) DEFAULT NULL,
  `xmr_usd` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `crypto_rates`
--

INSERT INTO `crypto_rates` (`id`, `btc_usd`, `eth_usd`, `xmr_usd`, `created_at`) VALUES
(1, 106340.00, 2635.20, 363.02, '2025-06-03 01:43:23'),
(2, 106360.00, 2636.62, 363.61, '2025-06-03 01:46:03'),
(3, 106356.00, 2637.88, 363.58, '2025-06-03 01:47:06'),
(4, 106383.00, 2639.61, 364.25, '2025-06-03 01:51:53'),
(5, 106389.00, 2642.99, 364.26, '2025-06-03 01:53:12');

-- --------------------------------------------------------

--
-- Estrutura para tabela `encrypted_messages`
--

CREATE TABLE `encrypted_messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) NOT NULL,
  `encrypted_content` longtext NOT NULL,
  `recipient_fingerprint` varchar(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `read_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `eth_transactions`
--

CREATE TABLE `eth_transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tx_hash` varchar(100) NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `type` enum('deposit','withdrawal') NOT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  `address` varchar(100) DEFAULT NULL,
  `fee` decimal(18,8) DEFAULT 0.00000000,
  `block_height` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `feedback` text NOT NULL,
  `rating` int(1) NOT NULL,
  `data_envio` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `feedback`
--

INSERT INTO `feedback` (`id`, `nome`, `email`, `feedback`, `rating`, `data_envio`) VALUES
(2, 'Pedro Santos', 'lonelyfalkoor78@gmail.com', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc rutrum fermentum diam sed dapibus. Morbi ornare ipsum vitae elit iaculis, et aliquam massa placerat. Mauris consequat nibh vitae cursus hendrerit. Ut pellentesque ipsum turpis. Praesent auctor fringilla dui, ullamcorper congue erat venenatis a. Maecenas aliquam eget augue in rutrum. Nullam imperdiet vitae mauris ac semper. Aenean tincidunt diam vel ullamcorper iaculis. Praesent vehicula in lacus vitae maximus. Morbi sit amet lorem at nibh bibendum cursus. Morbi eu risus et leo suscipit molestie. Vivamus imperdiet tortor augue, quis dictum enim posuere ac. Ut eu libero dictum, tempus risus at, semper nulla. Quisque eleifend vehicula porttitor.\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc rutrum fermentum diam sed dapibus. Morbi ornare ipsum vitae elit iaculis, et aliquam massa placerat. Mauris consequat nibh vitae cursus hendrerit. Ut pellentesque ipsum turpis. Praesent auctor fringilla dui, ullamcorper congue erat venenatis a. Maecenas aliquam eget augue in rutrum. Nullam imperdiet vitae mauris ac semper. Aenean tincidunt diam vel ullamcorper iaculis. Praesent vehicula in lacus vitae maximus. Morbi sit amet lorem at nibh bibendum cursus. Morbi eu risus et leo suscipit molestie. Vivamus imperdiet tortor augue, quis dictum enim posuere ac. Ut eu libero dictum, tempus risus at, semper nulla. Quisque eleifend vehicula porttitor.\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc rutrum fermentum diam sed dapibus. Morbi ornare ipsum vitae elit iaculis, et aliquam massa placerat. Mauris consequat nibh vitae cursus hendrerit. Ut pellentesque ipsum turpis. Praesent auctor fringilla dui, ullamcorper congue erat venenatis a. Maecenas aliquam eget augue in rutrum. Nullam imperdiet vitae mauris ac semper. Aenean tincidunt diam vel ullamcorper iaculis. Praesent vehicula in lacus vitae maximus. Morbi sit amet lorem at nibh bibendum cursus. Morbi eu risus et leo suscipit molestie. Vivamus imperdiet tortor augue, quis dictum enim posuere ac. Ut eu libero dictum, tempus risus at, semper nulla. Quisque eleifend vehicula porttitor.\r\n', 4, '2025-05-25 20:08:47'),
(4, 'PEDRO_TARADO_DO_GRAU', 'DFSADFJPOSD@gmail.com', 'STEPHANY GOSTOSA YEAH!!!!!!!!!!!', 5, '2025-05-26 00:16:16'),
(5, 'STEFANY ', 'pedromfc2006@gmail.com', 'CU', 3, '2025-05-26 00:17:39'),
(6, 'STEFANY ', 'pedromfc2006@gmail.com', 'CU', 3, '2025-05-26 00:20:42'),
(7, 'Pedro Santos', 'lonelyfalkoor78@gmail.com', 'qwerqwereqfd', 5, '2025-05-26 01:20:49'),
(8, 'qwdqwd', 'lonelyfalkoor78@gmail.com', 'qwdqwdq', 5, '2025-05-26 01:20:58'),
(9, 'Pedro Santos', 'lonelyfalkoor78@gmail.com', 'qwdqwdqwd', 1, '2025-05-26 01:21:10');

-- --------------------------------------------------------

--
-- Estrutura para tabela `hot_wallet_utxos`
--

CREATE TABLE `hot_wallet_utxos` (
  `id` int(11) NOT NULL,
  `txid` varchar(100) NOT NULL,
  `vout` int(11) NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `script_pubkey` text NOT NULL,
  `address` varchar(100) NOT NULL,
  `crypto` varchar(10) NOT NULL,
  `spent` tinyint(1) DEFAULT 0,
  `confirmed` tinyint(1) DEFAULT 0,
  `spent_in_tx` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `login_logs`
--

CREATE TABLE `login_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `tor_used` tinyint(1) DEFAULT 0,
  `tor_confidence` int(11) DEFAULT 0,
  `pgp_used` tinyint(1) DEFAULT 0,
  `login_method` enum('standard','pgp','totp','pgp_totp') DEFAULT 'standard',
  `success` tinyint(1) DEFAULT 1,
  `failure_reason` varchar(255) DEFAULT NULL,
  `session_id` varchar(128) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `login_logs`
--

INSERT INTO `login_logs` (`id`, `user_id`, `ip_address`, `user_agent`, `tor_used`, `tor_confidence`, `pgp_used`, `login_method`, `success`, `failure_reason`, `session_id`, `created_at`) VALUES
(3, 12, '::1', '0', 0, 0, 0, 'standard', 1, NULL, NULL, '2025-06-08 22:46:13');

-- --------------------------------------------------------

--
-- Estrutura para tabela `multisig_configs`
--

CREATE TABLE `multisig_configs` (
  `id` int(11) NOT NULL,
  `crypto` varchar(10) NOT NULL,
  `required_signatures` int(11) NOT NULL,
  `total_signers` int(11) NOT NULL,
  `script` text NOT NULL,
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `multisig_transactions`
--

CREATE TABLE `multisig_transactions` (
  `id` int(11) NOT NULL,
  `withdrawal_id` int(11) NOT NULL,
  `crypto` varchar(10) NOT NULL,
  `unsigned_tx` text NOT NULL,
  `required_signatures` int(11) NOT NULL,
  `current_signatures` int(11) DEFAULT 0,
  `signatures` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`signatures`)),
  `status` enum('pending','signed','broadcasted','confirmed','failed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `payment_monitoring`
--

CREATE TABLE `payment_monitoring` (
  `id` int(11) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `payment_address` varchar(100) NOT NULL,
  `expected_amount` decimal(18,8) NOT NULL,
  `received_amount` decimal(18,8) DEFAULT 0.00000000,
  `confirmations` int(11) DEFAULT 0,
  `status` enum('monitoring','received','confirmed','expired') DEFAULT 'monitoring',
  `last_check` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pgp_keys`
--

CREATE TABLE `pgp_keys` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `public_key` text NOT NULL,
  `key_fingerprint` varchar(40) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pgp_signatures`
--

CREATE TABLE `pgp_signatures` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `data_hash` varchar(64) NOT NULL,
  `signature` text NOT NULL,
  `verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `platform_wallets`
--

CREATE TABLE `platform_wallets` (
  `id` int(11) NOT NULL,
  `crypto_type` varchar(10) NOT NULL,
  `private_key` text NOT NULL,
  `public_key` text NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `produtos`
--

CREATE TABLE `produtos` (
  `id` int(11) NOT NULL,
  `vendedor_id` int(11) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `preco` decimal(10,2) NOT NULL,
  `preco_btc` decimal(16,8) DEFAULT NULL,
  `preco_eth` decimal(16,8) DEFAULT NULL,
  `imagem` varchar(255) DEFAULT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp(),
  `aceita_cripto` varchar(50) DEFAULT 'BTC,ETH'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produtos`
--

INSERT INTO `produtos` (`id`, `vendedor_id`, `nome`, `descricao`, `preco`, `preco_btc`, `preco_eth`, `imagem`, `data_cadastro`, `aceita_cripto`) VALUES
(21, 7, 'pedido teste', 'isto é apenas um teste de descrição', 1.00, 0.00001000, 0.00037836, 'prod_683bc18c634cf.jpg', '2025-06-01 02:57:16', 'BTC,ETH');

-- --------------------------------------------------------

--
-- Estrutura para tabela `purchase_logs`
--

CREATE TABLE `purchase_logs` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`details`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `purchase_reviews`
--

CREATE TABLE `purchase_reviews` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `risk_score` int(11) NOT NULL,
  `alerts` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`alerts`)),
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `reviewed_by` int(11) DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `rate_limiting_logs`
--

CREATE TABLE `rate_limiting_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `result` enum('success','failed') NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `rate_limits`
--

CREATE TABLE `rate_limits` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `security_alerts`
--

CREATE TABLE `security_alerts` (
  `id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `resolved` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `security_logs`
--

CREATE TABLE `security_logs` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `level` enum('attempt','success','error','critical') NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`details`)),
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `system_config`
--

CREATE TABLE `system_config` (
  `id` int(11) NOT NULL,
  `config_key` varchar(100) NOT NULL,
  `config_value` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `system_config`
--

INSERT INTO `system_config` (`id`, `config_key`, `config_value`, `description`, `updated_at`) VALUES
(1, 'real_mode', '1', 'Ativar modo real (1) ou simulado (0)', '2025-06-03 23:53:25'),
(2, 'btc_min_deposit', '0.0001', 'Depósito mínimo de Bitcoin', '2025-06-03 01:16:06'),
(3, 'eth_min_deposit', '0.001', 'Depósito mínimo de Ethereum', '2025-06-03 01:16:06'),
(4, 'daily_withdrawal_limit_btc', '1.0', 'Limite diário de saque BTC', '2025-06-03 01:16:06'),
(5, 'platform_fee_percent', '2.5', 'Taxa da plataforma em porcentagem', '2025-06-03 01:16:06'),
(6, 'platform_wallet', 'bc1qxvkeglgc745f7ekah7w4evkjg65j5qm0n3ex9m', 'Carteira para receber taxas da plataforma', '2025-06-03 01:33:15'),
(15, 'btc_withdrawal_fee', '0.0001', 'Taxa de saque Bitcoin', '2025-06-05 22:05:05'),
(16, 'eth_withdrawal_fee', '0.002', 'Taxa de saque Ethereum', '2025-06-05 22:05:05'),
(17, 'xmr_withdrawal_fee', '0.01', 'Taxa de saque Monero', '2025-06-05 22:05:05'),
(18, 'min_confirmations_btc', '1', 'Confirmações mínimas Bitcoin', '2025-06-05 22:05:05'),
(19, 'min_confirmations_eth', '12', 'Confirmações mínimas Ethereum', '2025-06-05 22:05:05'),
(20, 'min_confirmations_xmr', '10', 'Confirmações mínimas Monero', '2025-06-05 22:05:05');

-- --------------------------------------------------------

--
-- Estrutura para tabela `system_logs`
--

CREATE TABLE `system_logs` (
  `id` int(11) NOT NULL,
  `level` enum('info','warning','error','critical') NOT NULL,
  `category` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `context` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context`)),
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tor_hidden_services`
--

CREATE TABLE `tor_hidden_services` (
  `id` int(11) NOT NULL,
  `onion_address` varchar(62) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tor_request_logs`
--

CREATE TABLE `tor_request_logs` (
  `id` int(11) NOT NULL,
  `url` varchar(500) NOT NULL,
  `method` varchar(10) NOT NULL,
  `http_code` int(11) NOT NULL,
  `response_time_ms` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `value` decimal(18,8) DEFAULT NULL,
  `tx_hash` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `two_fa_logs`
--

CREATE TABLE `two_fa_logs` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `used_totp_codes`
--

CREATE TABLE `used_totp_codes` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `code_hash` varchar(64) NOT NULL,
  `time_slice` bigint(20) NOT NULL,
  `used_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `tipo` enum('cliente','vendedor') DEFAULT 'cliente',
  `btc_wallet` varchar(100) DEFAULT NULL,
  `is_vendor` tinyint(1) DEFAULT 0,
  `btc_balance` decimal(16,8) DEFAULT 0.00000000,
  `btc_balance_saldo` decimal(16,8) DEFAULT 0.00000000,
  `btc_deposit_address` varchar(100) DEFAULT NULL,
  `last_deposit_check` timestamp NULL DEFAULT NULL,
  `eth_balance` decimal(18,8) DEFAULT 0.00000000,
  `xmr_balance` decimal(18,8) DEFAULT 0.00000000,
  `eth_deposit_address` varchar(100) DEFAULT NULL,
  `xmr_deposit_address` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `btc_private_key` text DEFAULT NULL,
  `eth_private_key` text DEFAULT NULL,
  `xmr_private_key` text DEFAULT NULL,
  `pgp_public_key` text DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `two_factor_secret` varchar(255) DEFAULT NULL,
  `two_factor_enabled` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`, `tipo`, `btc_wallet`, `is_vendor`, `btc_balance`, `btc_balance_saldo`, `btc_deposit_address`, `last_deposit_check`, `eth_balance`, `xmr_balance`, `eth_deposit_address`, `xmr_deposit_address`, `username`, `is_admin`, `btc_private_key`, `eth_private_key`, `xmr_private_key`, `pgp_public_key`, `is_blocked`, `updated_at`, `two_factor_secret`, `two_factor_enabled`) VALUES
(1, 'pedro', 'lonelyfalkoor78@gmail.com', '$2y$10$KjUohwHZYLxgi25lAQINuu7UVcgWcsdgEeEmDZL5p/AF6vEpyL1f6', '2025-05-25 17:44:39', 'cliente', NULL, 0, 0.00000000, 0.00000000, NULL, NULL, 0.00000000, 0.00000000, NULL, NULL, 'pedro', 0, NULL, NULL, NULL, NULL, 0, '2025-06-05 22:00:08', NULL, 0),
(2, 'pedro2', 'pedrophsantos2@gmail.com', '$2y$10$QgFWQ8/o/xgX2Cp1j3jJ0OrGMZb0sFk.zsZZro3fOm1kZdCpyEa5W', '2025-05-25 17:49:12', 'cliente', NULL, 0, 0.00000000, 0.00000000, NULL, NULL, 0.00000000, 0.00000000, NULL, NULL, 'pedro2', 0, NULL, NULL, NULL, NULL, 0, '2025-06-05 22:00:08', NULL, 0),
(5, 'felipe', 'felipe@gmail.com', '$2y$10$xSKwSI7aV8zFmAPX5F8bnuP2WG9bBQ9QkX6JSt0XlAoRvDkAtu0pq', '2025-05-30 01:08:57', 'cliente', NULL, 0, 0.00000000, 0.00000000, NULL, NULL, 0.00000000, 0.00000000, NULL, NULL, 'felipe', 0, NULL, NULL, NULL, NULL, 0, '2025-06-05 22:00:08', NULL, 0),
(7, 'Admin Teste', 'admin@zee.com', '$2y$10$example...', '2025-06-03 00:58:27', 'cliente', NULL, 0, 0.00000000, 0.00000000, NULL, NULL, 0.00000000, 0.00000000, NULL, NULL, 'admin_teste', 0, NULL, NULL, NULL, NULL, 0, '2025-06-05 22:00:08', NULL, 0),
(12, 'm1sterZ33Admin_SUPREME', 'z33m4rketofficial@pronton.me', '$2y$10$7vHFHA.iCSuQL2BX20tGduqg77y7liiU7naHE5KrSf7vb0PbYmAJC', '2025-06-08 22:45:54', 'cliente', NULL, 0, 0.00000000, 0.00000000, NULL, NULL, 0.00000000, 0.00000000, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0, '2025-06-08 22:45:54', NULL, 0);

--
-- Acionadores `users`
--
DELIMITER $$
CREATE TRIGGER `before_btc_wallet_update` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    IF NEW.btc_wallet <> OLD.btc_wallet THEN
        INSERT INTO btc_wallet_changes (user_id, old_wallet, new_wallet, changed_by)
        VALUES (OLD.id, OLD.btc_wallet, NEW.btc_wallet, CURRENT_USER());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_2fa`
--

CREATE TABLE `user_2fa` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `secret_key` varchar(64) NOT NULL,
  `is_active` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `activated_at` timestamp NULL DEFAULT NULL,
  `deactivated_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `user_2fa`
--

INSERT INTO `user_2fa` (`id`, `user_id`, `secret_key`, `is_active`, `created_at`, `activated_at`, `deactivated_at`, `updated_at`) VALUES
(1, 9, 'L6X4ADFJVDBHSTFXZWVQ5YRV7ZUDLWID', 0, '2025-06-07 16:03:52', NULL, NULL, '2025-06-07 16:03:52');

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_access_logs`
--

CREATE TABLE `user_access_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `is_tor` tinyint(1) DEFAULT 0,
  `tor_confidence` int(11) DEFAULT 0,
  `page_accessed` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `user_access_logs`
--

INSERT INTO `user_access_logs` (`id`, `user_id`, `ip_address`, `user_agent`, `is_tor`, `tor_confidence`, `page_accessed`, `created_at`) VALUES
(1, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:17:21'),
(2, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:17:21'),
(3, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:17:22'),
(4, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:18:28'),
(5, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:18:30'),
(6, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:18:32'),
(7, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:18:34'),
(8, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:18:36'),
(9, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:18:39'),
(10, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:05'),
(11, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:08'),
(12, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:10'),
(13, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:12'),
(14, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:14'),
(15, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:20'),
(16, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:22'),
(17, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:24'),
(18, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:20:26'),
(19, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:22:13'),
(20, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:22:15'),
(21, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:22:17'),
(22, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:22:19'),
(23, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:22:21'),
(24, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/dashboard.php', '2025-06-08 18:24:40'),
(25, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:42'),
(26, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:44'),
(27, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:46'),
(28, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:48'),
(29, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:50'),
(30, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:52'),
(31, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:55'),
(32, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:57'),
(33, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:24:59'),
(34, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:25:01'),
(35, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:26:55'),
(36, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:26:57'),
(37, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:26:59'),
(38, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:27:01'),
(39, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:27:03'),
(40, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:27:05'),
(41, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:27:07'),
(42, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:27:09'),
(43, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 18:27:11'),
(44, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 19:11:46'),
(45, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 19:11:47'),
(46, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 19:14:27'),
(47, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 19:14:29'),
(48, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 19:14:32'),
(49, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 19:14:34'),
(50, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/index.php', '2025-06-08 19:14:36'),
(51, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/', '2025-06-08 19:15:53'),
(52, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:18'),
(53, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:20'),
(54, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:31'),
(55, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:33'),
(56, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:35'),
(57, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:37'),
(58, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:39'),
(59, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:41'),
(60, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 19:16:50'),
(61, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:16:52'),
(62, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:19:31'),
(63, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:19:33'),
(64, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:25:45'),
(65, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:25:47'),
(66, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:25:50'),
(67, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:25:52'),
(68, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:25:54'),
(69, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:25:56'),
(70, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:25:58'),
(71, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:26:00'),
(72, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:26:02'),
(73, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:26:04'),
(74, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:26:06'),
(75, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/', '2025-06-08 19:26:08'),
(76, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:27:17'),
(77, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:27:19'),
(78, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:27:21'),
(79, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:27:23'),
(80, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:27:27'),
(81, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:27:29'),
(82, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:27:33'),
(83, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:27:35'),
(84, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:39'),
(85, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:41'),
(86, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:43'),
(87, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:46'),
(88, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:48'),
(89, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:50'),
(90, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:52'),
(91, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:54'),
(92, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:56'),
(93, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:29:58'),
(94, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:30:03'),
(95, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/', '2025-06-08 19:30:05'),
(96, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/', '2025-06-08 19:30:09'),
(97, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/', '2025-06-08 19:30:11'),
(98, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/dashboard.php', '2025-06-08 19:31:02'),
(99, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 19:37:13'),
(100, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 19:43:57'),
(101, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 19:44:06'),
(102, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 19:46:41'),
(103, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 19:52:06'),
(104, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 19:55:14'),
(105, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 19:56:17'),
(106, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 19:56:24'),
(107, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 19:56:45'),
(108, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 19:57:16'),
(109, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 19:58:06'),
(110, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:00:04'),
(111, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:03:47'),
(112, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:08:01'),
(113, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/', '2025-06-08 20:11:47'),
(114, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/', '2025-06-08 20:11:49'),
(115, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/dashboard.php', '2025-06-08 20:11:54'),
(116, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:12:01'),
(117, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:12:06'),
(118, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:12:14'),
(119, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:16:59'),
(120, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:17:16'),
(121, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:17:47'),
(122, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:19:12'),
(123, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:19:20'),
(124, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:53:12'),
(125, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 20:53:24'),
(126, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:06:01'),
(127, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:06:12'),
(128, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:13:03'),
(129, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/', '2025-06-08 21:14:07'),
(130, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/', '2025-06-08 21:14:09'),
(131, 8, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/dashboard.php', '2025-06-08 21:14:15'),
(132, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 21:14:35'),
(133, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 21:14:47'),
(134, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 21:14:56'),
(135, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:15:00'),
(136, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:15:18'),
(137, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:17:07'),
(138, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:17:14'),
(139, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:20:10'),
(140, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 21:20:23'),
(141, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:11:05'),
(142, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:17:42'),
(143, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:38:41'),
(144, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:39:25'),
(145, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:40:58'),
(146, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:41:25'),
(147, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:41:49'),
(148, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 22:41:56'),
(149, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 22:41:58'),
(150, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/dashboard.php', '2025-06-08 22:42:03'),
(151, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:42:09'),
(152, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:42:11'),
(153, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:42:15'),
(154, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:42:17'),
(155, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:42:19'),
(156, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-08 22:42:46'),
(157, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-08 22:42:48'),
(158, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 22:42:50'),
(159, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:42:57'),
(160, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 22:43:30'),
(161, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 22:43:32'),
(162, 10, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/dashboard.php', '2025-06-08 22:43:35'),
(163, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:43:40'),
(164, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:43:42'),
(165, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php?cadastro=sucesso', '2025-06-08 22:43:53'),
(166, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php?cadastro=sucesso', '2025-06-08 22:43:55'),
(167, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php?cadastro=sucesso', '2025-06-08 22:44:02'),
(168, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php?cadastro=sucesso', '2025-06-08 22:44:04'),
(169, 11, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 22:44:06'),
(170, 11, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:44:17'),
(171, 11, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:44:21'),
(172, 11, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:44:32'),
(173, 11, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 22:44:44'),
(174, 11, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 22:44:46'),
(175, 11, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/dashboard.php', '2025-06-08 22:44:53'),
(176, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:44:59'),
(177, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:45:01'),
(178, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-08 22:45:42'),
(179, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-08 22:45:44'),
(180, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php?cadastro=sucesso', '2025-06-08 22:45:56'),
(181, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php?cadastro=sucesso', '2025-06-08 22:45:58'),
(182, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php?cadastro=sucesso', '2025-06-08 22:46:11'),
(183, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php?cadastro=sucesso', '2025-06-08 22:46:13'),
(184, 12, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/dashboard.php', '2025-06-08 22:46:16'),
(185, 12, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:46:58'),
(186, 12, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:47:14'),
(187, 12, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/privacy_settings.php', '2025-06-08 22:48:26'),
(188, 12, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 22:48:32'),
(189, 12, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/index.php', '2025-06-08 22:48:34'),
(190, 12, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/dashboard.php', '2025-06-08 22:48:38'),
(191, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:48:43'),
(192, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 15, '/ecommerceZEE/login.php', '2025-06-08 22:48:45'),
(193, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-08 22:50:03'),
(194, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-08 22:50:05'),
(195, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-08 22:50:47'),
(196, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-08 22:50:49'),
(197, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-09 04:20:10'),
(198, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 0, 0, '/ecommerceZEE/login.php', '2025-06-09 04:20:13');

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_backup_codes`
--

CREATE TABLE `user_backup_codes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `code_hash` varchar(255) NOT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `user_backup_codes`
--

INSERT INTO `user_backup_codes` (`id`, `user_id`, `code_hash`, `used_at`, `created_at`) VALUES
(1, 9, '$2y$10$i94hLoHG.03yU2tHuagzpOXFpB5MBtbTEDmVyoSOjhKU5VApu7WWS', NULL, '2025-06-07 16:03:52'),
(2, 9, '$2y$10$kXuwpY5BX/2iYWteSfadFe1DG6aULeja6VdVg5Su2p2ooIfCu6QqW', NULL, '2025-06-07 16:03:53'),
(3, 9, '$2y$10$DYHM1MpH2LF0t8G9lSf97ufBLIqDiDZsHZg3rA0ZFpy/BPyPpiU3S', NULL, '2025-06-07 16:03:53'),
(4, 9, '$2y$10$G7gyd38j9Qdgbdh/u.qzHut78JYzR1wdv7x5tHAEs4cH7nbQ.l5ti', NULL, '2025-06-07 16:03:53'),
(5, 9, '$2y$10$yCyNF.r7Qf9MNraHtI8CPedS6wq7pzPTolsj.uKuGzU78NB1PapR2', NULL, '2025-06-07 16:03:53'),
(6, 9, '$2y$10$NluU/jYrB0id26PZ34lGde1smCdcY.e1VVZXdCUdFMNipDjokCHUS', NULL, '2025-06-07 16:03:53'),
(7, 9, '$2y$10$sDRz3lO0GYCctJRn9HMyluri9CRHN.lRyG9cZfOAHTdXiKZ0.qTgC', NULL, '2025-06-07 16:03:53'),
(8, 9, '$2y$10$u2XNqpyJH8MqUWkXuCsAluneXfCg69AAXTzh1vEJjNF1KKtkW1u/a', NULL, '2025-06-07 16:03:53');

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_notifications`
--

CREATE TABLE `user_notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_pgp_keys`
--

CREATE TABLE `user_pgp_keys` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `key_id` varchar(16) NOT NULL,
  `fingerprint` varchar(64) NOT NULL,
  `public_key` text NOT NULL,
  `private_key_encrypted` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL,
  `revoked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `user_pgp_keys`
--

INSERT INTO `user_pgp_keys` (`id`, `user_id`, `key_id`, `fingerprint`, `public_key`, `private_key_encrypted`, `created_at`, `expires_at`, `revoked`) VALUES
(1, 8, 'E3B0C44298FC1C14', 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855', '-----BEGIN PGP PUBLIC KEY BLOCK-----\n\n\n-----END PGP PUBLIC KEY BLOCK-----\n', 'ycehAD30LlRapRHrMdw7HTFjcFZ4ZnZuRjAxSEUxekJSME5OZElsS0JreDRFM1hPeGZ0aXlVUElDcUg5OWh1Vi93U0kxQUdKZGhyOFlIVW1hQmZiSDI0MTA1eGFNTTA5VGtwNWRBL1lPZ09mekJ5enJTMUlJc3FyNjRzPQ==', '2025-06-08 21:06:15', '2027-06-08 21:06:15', 0),
(2, 10, '49F3FCE10477FC1F', '49F3FCE10477FC1F12486F5CD96C91337D146BEF4B2DF6A7BA8D12076DBFCADD', '-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nLS0tLS1CRUdJTiBSU0EgUFVCTElDIEtFWS0tLS0tDQpNSUlDQ2dLQ0FnRUF0NGRQ\nUnJXZzBBc0x0R21SRWlGL3Buek1nRk9sY2h6ck9rcGlic1dsTEtUMmwzbnFSZEhD\nDQpTbmx3cUc3RU1FMmNNQ2ZOSlY5ZVk4YXF4ek4zQTZNYkRTRTE0MnRCbFhtdVlI\nVjgrcVd0Zm9kRlZ0c3BLa2Y0DQo5MWpPdXpjWVRBY240SUJ5eEtJMmJyN0xJWUEy\nTnNSUnBQWE4rbHB3bkZxS0lkOHNtS1R4bDJZZlAyZlZTR3dqDQpWdWt2ejFxQWM4\nV1d1M05peEFQMnpwaURBNkNKd05GRmFYZUhLM1hqaW5RSXFTMVpHM3k1bjBDN0JV\nUjlwaUcrDQp0Mkt3WW5yN2lyWVpUZTdVK3JxRkVzbmRxaFNxRFlWRTZ5V2FQYmcz\nQmpzdTdINVNvd3JqMDNSL1VWTmd6WG9nDQphNVNQVnJ4U1VVQTZPUFdDQnl3Qmw3\nSHh5VjBRUDJENGp1d3A1NUZYVmN3UmFuZWpraTlQbytackFoVGFsQWpODQpKTDZZ\nbzVUN1FoZHZCMWhUT1ErTVpjUDhrTG82RysxMGNnUWJUaGZLYkhaTXpOWngrNG9l\nMENzSmxIaHpOUmRiDQpaZW41d1Q4UHUwUGpaNVFYWDlEWktyaDdDUXhXZSt2NHFC\nRzFIZE1ybVNMTExMdjM4bC9yM1JyRWZ1VVBkaW1zDQo4OFJXQWZyZHhkaDBrc3ov\nSDM5ZEdUUTZTQ002cEt6N05GV3JEZ3VmZmtKZEwxSTBsd2ZoRmVzUFhUR0JpdkVr\nDQoxTnlvMGx6ajZrVWlMYkxKOCtJWm5lRmppTFRGcXROaWFaaE04cFAybXJwdzlB\nZ1RiaFpkTVA1Yld4aEZGQlpCDQpxNDFsazQrOGl5NlV5eC9WT0VsSjVNZCtkdHkw\neFBmN1dkdHBmSWEzTHpJYXF4MDJZQXEyMlMwQ0F3RUFBUT09DQotLS0tLUVORCBS\nU0EgUFVCTElDIEtFWS0tLS0t\n-----END PGP PUBLIC KEY BLOCK-----\n', 'nfQJTUzo43a17MBFY5ncvXJrWUk4SitNVXo0SkFteHhxYllLVi85WVcwY0cvU005MGtKbzRhLzd4QS9CQTVuMWR3NEtXakJtWC9WMVYyZHl5b2lhUXZvdmgvUjJUcVdnUGw1UW1UNlE0OUIrK1UyVTBLK2RWWkFuOWRZQ0g4YSsvZUdBRC9haExBTVpkS1RDdkQ2c0RUbXdUNDRIN2J0dVJESkF3aGdWcE9ldmtzTjYzSzVsUGZKZzY3d3hrb0ZBVloweDZZOWtYME9TMUZIOUpuWGlUbUxJZXhrQXpXVWo3Y1FQVUxPLzUxMTdwaW55NkhDT2tncTRDa3o1TW1SbXBQZU5wcUtlV0dqUFZXRW41TDFSODlJM3d6NkhVUTA2VFRldk9HS09MWnVmVG51VFhGcVVENE9XcXNIOW5vMnZOUVRPdmNHS2J2RldzbjR4UjZqY3BMVXBqNk9xenJKRDh4aDZHVXlsMW85L3dveXpRWW5EdGJNelkySGJjVXk4aU54RXlodThUMklxTml1Y1RvbU1PVFlodXc1SnlZVUM4NUhWSXBVWWc1R2J3V2MwU3JIRWFEclRqdDJWSE8xaTlnU0t6eGhSVzJzRE9CelNUdEpPMEYxMlZBVlNlSWFJclBWYW9JMW1kYUxCcE1vSklTZXB5cVR5NTgwQ3Q3OTlYejh0OHM5SUpWd0VPSVdzc3ZqcWdITXFVUEo2dFUrbC93eVBVN0R5YTFmSVI2SDBJUFJtY2JRRkRvZTgxMnpXT29NVk1JaG1ja1dSQWRBYWpISWRGRDBhbHFCUWNZRHFFMUZSb3ZuUWtvOGVIUUxBL2p2cEV4NkovY2szRlZJQ1puTzlVdEd5T096UndaUmkza0dkRzRlMy94ZXNOaUc5OGN6UkJOTWlaeGJWT2VEUVY1cGVaOVAreGtQbG9FZUxPVC9tNU14U05oUWlPU0Y3NlQ4RE4xSkw3UWF5NWsvUXZBWXNBeGUvYWtydysvZHcyNy9aSzkxSDAyRHd3NlUyRVhmL0lnRzRHR3N1b2pSOUs0dVFQVGEvUVEwY3lncEVZdG1aUkdGUW4wampLYWpsSjZJVHg3YktOd1M3OCsvZ0lxSWd2dnBEdEYvV2FiclZxMlQ3Q2ZJNW9WcHh5NWNyVHFkc2VaRWtNSkIyYjRmclpwbHU0aVRYcHMyenQ2bExLcFE2REk0dVNZZWsraE1NWFlEdVFhc3JtZ0J6ZGRHMUx1a0tJVGxiajRxWmdZSjNlUmd5WkpwYkdPbFhpeE5sZ2NVbGgvUklPYUJSMGIrZHNuSitzL01McDhpdUtFcGR6L08wWXdEUjFMOSsrVTVEZWoxV3B2TVhpQmowd3c3S1NEVUxMT05zYXluUkk4dks0d2JDMEtXQzZPZ2ZLRm1zTHlGTGd0dkNsbUVmRDlHNjk2bXBnNjh0MmFmM3VuYkZaMnZMK2pTTFduVnRJTVViRmNWd2hNM3pYWDduL2pwUGlKUmNJZ2pINEFpYTdURURXWXE5dzROV3M3V3dUUzdTTzhFWTZzbkk0YTVVRGdodVZac3N1WEdSWTJWV2g5WS9jb285L0hZbUxkNlY4ckxEaUdyMXQ4ODFmOXUrQkI1Q0pFQzZqd28vdW9LT3JDVEMwY0ZvYzd1RlRuYzJKU2R6cVZ3QmU2dDE5MGE4YmlvTy9zb0UzQmxrTmtvRWJKVUtxNlI4aElJU2lsNjI5ZldDN3NQaWhhVUV4MTExdElETC9JRjlReE1qaWNuRVpYTGZOY2U0QW1JZnJRdFBxU1ovZWFxUmM1ZGt3aUNzeXpaR2NTd0JrcUUyWHVXbEtIbTc3bDJVL3UxVE9oRjNJWC9oMnVETFBsbnRtSXlrbHpFK29sQ1lTTUhiZFd5NUQyNVVxcWZ5by9vWmx3b3F1VzVpVC9IcFFGaFBuM2F2bkxHWDN3U0FnZVhOMk5CN1dhQnlFY2ZJazVYK0lVcnFlbVF2eUR6bHZWK3JFNE9tbmFZNjBpYTBsNTJaTUhiNVNsZDlIYWpYN0R6RXUvSGx0TzU5elFYbE9KT29sK2tKeitaT0lPSmxUZXZzYWZ5a3RETHZlWVdyeldRaTN6TXY3a3FnNTd5cERWUVcvdlViWnFmVFBuSEw1R0NvVmd3ZVNlS0RZa0ZVbWxYbGhtNlVjSktXaFE2YlJuRC9HRnVDQkRyYkhoOW1rdnlObElKMVJoWTdORkNGalYzRWI0Sm1BY1N6bUgxeHgxYWhGdFRDVDB1NzdqdGZvQ3ZXQXBBV2owcnhNZVdtWmtBZkpIUVU5OFR4MkJ6WitVSzRiSHIxbHdSeEhDY093TUUreEFDNU1oVlNSYnhMRkdnNEtRRzRMQWlUUkZRbVJLMlMrbi9LM2F2L0xWdW1jSlNuRjdJaEpGd0t5VTZRSlQ4VnRpbEpHZ212SXQ4NzVmMTVDWitwVmVVcG9McHN6K2Q4T0d4ZGhzSjJGaUtNM3NJUXVPTEVmaXlTN2hzcWNBL0dIU0ZXMEZXNXVzeHlrTEJ5WFhxd0c3RUJLZ3VHRDNxUUhkbi9xOE1wS0xhaFZSdVo2N3crNkE2SjM4SVF4bHV4Q3JoMkhFR0JmUkRneU1KbEs0K21mUmdDOVFGdW1oWWVkNzFRM2hKckljcmhFVUl4azBoaVh1UUZTOGp6Y1h1dXJBdS9YR0I2SUl5bkZScU05dnhkb1RYcUJ5OTczUUVOc0FqMHNjYlhXUHVIekNaK0VLQzBqUkIwMERJZFFCN1Bza3BVRnlnUzluM3hOSjV0cEhqc3ZxRUpBcVVMaFc2eVRtRy82OHo3bHJKTWlGMTVlQVRXemw0eS9TVHpTNkxCR1ZtZUNDUlh5VEFuRlFUTVd1SlQyOEpKdkNmQUE5RmlnRFJqSlNlWXlZdlRweVlzYkUvRGZ2ZGZmQ09wTEFpOGI5VFk3bjhaWnZYVTVhYjBKN3JCdHEzMnluUUNuTUIwcGVLbm9VeW52UHNOYmlmOWFLbHlocnpxVXNocHoyRWJZeEEyeFo4QUthaS9oTkRnNXRZYTdMdnJTTXpvWWYzRTFkZ1FjdUpIdDVPeXVBNDJIYkk4YWxWVU9wSVIyVU9DTWpJUU5OSHRCV0hyZkpiQXlHdDNHL3BPNEo4NGtUclpqTHNHZzRyemFENCtsSWNJd0U1RTl5cy94Y3UyTTFYUUkwYVlISzdHVnVVS1lTeklJOFRBQ2w2cnJKalJwQ2hQeTI0YVBwc1FzYWlsOTBpRDNOSkpjNWZnSCtRcnhtYU9aaXJvSldJMlpaY3VleVMweHMzdVd0bG11OU5xdldiUXMvVEpFU3JUeTF4cHBZUUZTa2NVR3BOMVJPdFdnc1gzMVFxMENRZDlINkJkVER5a0NkbkZwMlBBeUNYZW5seUtYdE9vUTUxS2FwcXFBRlhFWmNaakJvY0QwaGZYN3c1RlZ2K3p6WmpoVVhEaTZ2OUI3ZUVvcm9iYzJwaDlDR1h2a04zOVgydElJZzdhcmtCNzBaSnBLTElpbmE2ZjBjbGlqV2RaMHNXSTRtdmo1S3JncTVTbDJ4Y1J0cERHUjdhWE55S1ZzT3QrdWh6WmNmNjNYRTFKUDNjTWNzZ0FBYjdlcHJMd215V1RLZmV5OW1qdFZYdjM3aWlSb3I1d3lWaUlCeWhGWlEwemtQYkpEbTlNbCtSeXR6SVA1eG1BRElFb290cnRrZ1FPSWpseHZRdjFTMlA0bzVzMmlhZ1FrYzBxb1JIRExMN2ZXSDhnODZBZ0ZTR1dUaDZEMERFSENLZEloeUl1d0hPU0V5VVB4L2ljeWwwai9YeTR6OEV6ZXhlbG9iNlFxekhYODBRZElKUmlNaW9UbldkL09HN3p0UHY3K0ZlQzhubDF1T2dwOTNZWFBBV1dKa3AvT3dJbmt2VFcwTXI5TlpDa2tXRG1sdU4wK1kwVU45em43ekI2bFdmUVQ5WWJjK1c4SXpTMENxTFlxbE1KRnRwdTg0SjVsWmFsaGRMbEYzSER6bXdXaktoM2VjSkVWOGpSdHFqZUhDZFRKMk03cHdLSXA0R1RaMTRQVXdUSnk5UnhkbUZqbGYwOVYyTXRVSUQrRXdieWQ4dEZwczNvd1FCcWQyVVQ3OFNTSVJOZGRzUWhvNTdsL3BQWXRLL3JOajVhVzZ0T1hGdmVjbFkzTGNPS1NsYVdIdFRuQzZRS2RYTGZVcldJNDk1dGhQa3BGRXN5UEN0Q280MlRURU9IVVlrUEVlalF0Lzh5Qk0ydytVam00VWc3aGprZDRGZjNML1ZrSGRzdlJhblVNRHpSTm9KdVdocjNUT2tsN0VXcTgwcndneGsrUStFY0dubUI1dWpHVlVmU0FKTlFBcWF3WEtlaVJmdDN1OHVmak9KVUdCc1AwOVdCV3NJU1k5Q2lzSE1zMkNaT09rRURkSEtmTE5oMmtpdnMyeERJclN1YjI5WEVNZENuNW5uZmFBRlNaZUdsRWVtYWpybDFCLzRYQXc1L2Q1TWwybURBcGZHNmdPR3ZjQ2gzcXVFck9idUIrbW5YdjVKSzVoSU1CcEpYMklOaVlscFlxdEh4bzFmMnkyOXBjNFdOVXdsUTNLbUtlcGpIVU8wNGFKb3Jrb0x0MEM4aDVvSmFuM0RSVnIyVzdNd21HdUlYODF3L3R1c0J4azh4NVVCTnJTNFlNY1g0TG54Q29QZENrMlkyNXZrZnd6QTA3TW5tb2ZaQVBuUktva2dwWlhXS3R3WHl0WThySTY2NTNrZTdicUZ4UHVGdnZ2dXB1QjI0VHV3MDY1YW9FNkhqSGVIWXk0UUR3T001MGZPdXk0RVp3a0d3d3d4NVJXZzdZeDJ1RlRuenRFUzJJVUIvcXlueVBCemJ3WWNNZDZFdk5Td3BqWGk0dTZoTXVwR29BYTIrVkRFV2FKSXVPaHV5eDZEcXQyc2pBc2pxb3ZvZ2VBMXZ2UmRVcXNlV04xb29NMW0ydHFyWmlLUE1PL0FYQWF3NHBiOFRaOHRrRm1IREZ3SGI1NDFMd2ZTRytzOXVuT2QyaGhwVUd3R0NGZ3FDN1M3VDVCbTlWS09iOHhORllNMkV1OXByYmFSSjg2WDV5VDI2aHJORlREbVNlTGJGdjR5Yk5lZkJOdFVBMWQyNVU3QUF0U0JZQ0syMzV4TVVOUGlaZ2c4b0VJc2pvTmdoZnJZaHBQYzU3cFljUlJNQ2h1RmtRZkpQS0NzUjh5c0wzK2hnNUNXQ2ZYL0l5ZE9kcG55YTkyR2JKOGZWVUpOb1E2aW9aMFdXV1NEZ3ZteDZVd3JieDdtU1diTmc1dVpZcUI2S0xFbnE0UjZ4SDgvNGtRVHBDcS9QZWJxMDRtUFdKajJ3WEIxR0JndGhKZm1la21Hc2ZoYVhEbkNnMkMzZXZEWU9BRThaMHJ1Y2xZMUZNOHExT1g4RTV1TzVRbkZjY004OUc1ZnMrcC9RckRrSlh1WWs4Z3lsZFVKWENuYnJ1MWcraHA5Z3JhakNzMVNzc1poNlI4QmdwS2w4clJiWDA3SVl1UWhjeU9RRk51ZEpLUDUyd2E2aEdPVnBHN24waFBLS20vUTVyYmxpKzNNQ2xtMkdjbnJQYzAzUVZHYXkyS0xKR1BDMU1MUk9pdjN2U2dEWUNTZ0haQjlCRVA0Z0p4U0c4VG5OVmhpLzFuOXg2SEIvS05rcFVUNnc1eU10S1FWZVRCUGN0NmtGQW83ZDBBNldZengzcXpMSmdrWDFadGV0dXhyNGFqUk94djJQYVhQQjB1NTl3dzRoT3lFSnZJVWRnSE94Uy9OeWNjV1dXV1hFU1JVbU9VK0Q5d05Nbi9sUzcwSGJNNVJITUNZSlNVcW9UTkdlTDRMZkRLaHBIYnM1WnZhMit3a0pHUmMvSU91ZHBhZWgxckUwSDlpK1hzZ3V6dlRoWkcwYTE4ekZ2Y1FYWnBvTDZXWlgxR1RXS05DMzVsUFFVTnBDOFEzZnpmWVBsUjJhZ3JSL0JmYzBQUkV5VjA5WlZzdVFuZldYNGFtRjczZUVkb3dEelpTS2U1dmN0OFo2dXh2RGs0Vi94eWJsMXBBTUFLQmNDekRGaHhTYzNibUd6QzJ1Y2k1cklSdk1TalJWSkpQc1FaM1hXamlyakl0Yjd2dlo0WEdheGJobkYrcURpMW1iMGlKQkNXekEwSU55RFU0MjZrcjlCcHhzNThJUS8xNlJBZmFKWG9Dbm84dG9LbHlieHVqUzBoZWwvZUhFelFCY0MrM2U2dTUvVFlnV3lpNWVxWmtIWlozT0d6OEExVzRCQkNSZFpDbUIrUE9YTlRvVnk1U3B3U2ptbVVLbHcrMjZtS2tHeDhFLzJkeW5LVDNVWjFEWnIyY0lNNXBjcFRhVDl6Zm5XenVLTFRlWWNEaUtkaUFBNk5NMU0vOWtXSk5qd0hxNkZNNzNra1pHM29mVE9UUHkvODlPWVQ1NVJrblhQTWpuT29pUW5sbHV5L2NUTW9YWUl5NlhHS0ZodlRVdTBMZ0VzVUhwQVd0bThXTHA4ZWx6OXlSNFQ5QktITDVXUmpNUkg5eTk2ZVI3amE2TmJkZThheG5yd0hxY2VlU1V1dkUwTmp4dTE4T2t1aDJUMlBseTRxZmsvYksvYkxKSlJvbG1rSDBZZmw0S1I0K0w0RmJXMVFXTFBSM0kvMGYzbmNUVThMNWtTT3dpdXVEck5QMUp4ZW9oR0lvUk9IRWxpZzQzT21yVmg2QlY1UzhhNlNxa05OTEJUQkFhYkhybVl0VE1DMzJmVlFnZTdBMS9wdjBIZFJaWlhWczlndVdGSE40N09JbzJRb0NaeDdtVWtVWGoyakFNVytEcmQ5aCtFMGhsR0dwMVMrWkRIeWp6MzlkajVpbmpMNjZtV0RNdGpTWVN4OHpJczI5dDRsT0ZnR0FoM1pSb3BJNDV3cG1OMlBNYzZ2RkJOMHB0MHpPclQzRGR0cFYzSTFtWCt0RjU4MUU0dWllQnRLSXl1cjZZRmFmQ2FxQjF0ZCtYajFOenZqQW9mUGxqTEhKbE9Kby8wUVpING83STlSd1BURDhtVUVMdDJPeDZvUG5zRi90Wm1TQWpIVFpKM1cxaXI0L29jU0k5TituRnUxK3NjMlEzVFppM1NUZ2lESmhTMEdIekhiN0tTaE94SGhUNks0b1NmVktIQmNNVU9qWUhlM1dFem84OHlyelFqNldtK1FWL2tuTWVjb2paTnhMbGRzTWRmMThPdUVNbkoyTk1Sb0YzakZTQ1M5bll6dEtHNGprNVMrbk5DcXU5QWxKeW5UVDFFK3dMQitRLytYbElTUmhSL01yQ2ZyZnVxYlErSjhNUU1tZmlOSUNCN2VXYVFGT2VYUTYzT0RvSHhydHlhanJyZ3BPbVliNHJ2R0l0SlhpalVlTy9taWhremU4T2JKSWJDeGZTSjFTaWZHN2l5SHhtL3MraEU4TUk1Qkk0Y3B0c3lUdTNWN0dXMndMclFrRE1QTjdUUFZwZElocVV3dDArQ09zNHpYODJaN2FPUCt5RTFyZ25Vc0tjODJvOUdYREVSNVZ0WDRjbFJReWRTZUtFNjFVUGhJeHRKbWZVS2QyTWFkSWt6VjErMHgycFMwcXBqTFU4M255UlBHbjF2YjA1NnRNMGFXUlJKY0Z1MzhFMWQ4Rk1Zc1Y2blA0QkpGaFRtT09XRkFZUjdZdFgwdDd0Ym1TR2VUTGEvTFZ6N2dWK2MvWC9mdnUxM1p3RUNaaTVHK0wzN2dLaHB6VDRnQWRiS3BRTkc4TDQ1eVZQNXNQMTUrbmErbGRNMDkxUkVZczNqeS8vZWpvaXFWNktITTBnYlZuMys3ajA2aTdFbUk3WmwzekZSQ21yd2I0Q3UrT242WVZnT0hyayt4M2d0U292enA1Y3RtdEU1bjNVdzJZcnh3N3N4ZTRHNEg0am9SUXZSVWVoYUpCUG1ucVBxUTB0bjlFdUxlR2Jrc201YkNUYWlSTFNOaGErRENSNHdQdHRGdXhlY1JHWWsweVdpWEYza2tkd3RZSFFORmExTk4zenVNeGpyd3V3anZGNGM0NjNEcWlGRllYVWJlcFBaRWZXM2VzRngyTHNXN3BLVVp3PQ==', '2025-06-08 22:11:08', '2027-06-08 22:11:08', 0),
(3, 9999, 'D1EE7E03CD06D1E8', 'D1EE7E03CD06D1E81FDEE7BC01702F8A28BFEC1723ECB9E47DD4734AED219805', '-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nLS0tLS1CRUdJTiBSU0EgUFVCTElDIEtFWS0tLS0tDQpNSUlDQ2dLQ0FnRUFzeHhZ\nUXFSYk1TeGI4d2dNckVZMWxYZldXREFoMVRURUxqNUxFQzF5MUpBMDRseDhyREts\nDQpXUW9RcXlYSjVIb3lBbDROMnl4MmtPNXA2WitjZHZJWVFkdnNNT0lmVDFMc1BI\nTS9TdGt4NTlPN3VxWmJJaGpHDQppUWcwdFRvd2NaWWk0N091ajhQby9oOFlZOElX\nNEFnc3VhNExWZFpBbE9UMUt4V3BKZGE5RHJMKzg5RWZPcXB1DQp0N0RWclhWQUZU\nL1orak1yaFYwcGMxNTNEanBCVmJwRE90WjM0M0tlZFJvTGJqTHJTMGsyeDhyOGJ3\nRnpTeGljDQpvUDF5WHJWZC9lVTRXYzUzYWhlTS9SS1l0ZlIzZnRJRmJWdWVvOWds\nVDhCT0pJazlzd2IrWVIya1NHVWlmU1BSDQpTMVJJMldHdXdOb29sbHN4VWdmVkF0\nam53L2xGbHdXSlhsazVsSUxWbk82YWRpdEVHY1JqMWNDd0dSWStieksvDQp3cnlE\nZGkrSzlkR3lLOUtUa3A5Z1F6ZGdETW9nRWxHZk00WDZzUXRwbmVJSjB0N3kzbEhz\nYXY3UEhWT05aSG1CDQppS2g5SEJPTitCcXhuVnB6UDNLNi9RMXpMV3gvNEphbFlD\nNFlhcWFvMVFsUHJKSWZTRUlQNnlkb2VTNDAzdkJiDQpvdjdmVytpdmF6QVFNZXVK\nRjRrQXErMzJVZHI1UDB6V1h2M3NTL25Kc09PaENwY1VDcjZ6QkxUNUd2T1p4bDdS\nDQp6ZU11Ymk3Z3B1cThOY0twU056UkZqOFZtOXFZRVM3aUlMN1ZZdmJYSllKeDhK\nMndURW8ySlBDS3kxYnB0dGRzDQo5Umg0TUxzbnliYlEwVTBoYlBBaytoT0Y4ZVR4\nNXNKbzlaQVdXSkZ0ekk1dGhiMFhsSG1BS2UwQ0F3RUFBUT09DQotLS0tLUVORCBS\nU0EgUFVCTElDIEtFWS0tLS0t\n-----END PGP PUBLIC KEY BLOCK-----\n', 'XFAwq55fIF5SYdXELRMPgDFWVm5wYTlYM3VkdXpRTElpdUpYVHg2OVJNSEY2TUFVaGlLSHFTWHVaKzgvVlM2UkVaU0FJWmgvSjRWeW00YjRDbFNJVzFLanphOHJlM01QMllsSXMzTWpIM1BUN1ExOHIvZE91SWpOWFpJRllCdDZBMFVpWnA2WW54ZXdMenhhVWtua2w3c0xZYXVjdkNCR2tBeXFXWTdXOHBnR2tZL210TGZFMjgwMTNNUVhsM25sS1hja0N1S0FXYnVNR0VyZnBwUlJONWxQYm5WVm1aY2JvdjNNMEZBVWo0L1RHVUhvRTlLNGF3VFFYanpCcHplcGlyQk45bHpqQmRlL0txTXgrWnQ0dWJza3lEbEpHUGMyMkx3Wm90aDFDOVU3VFpPSndGbHplenNwTE1jZTBaVEdJRkh0WjhVQTYvcFZTM0lBOTlGRCtnUTJYUzR1MjIzZXZrMlVGdlRDRWw4Z3NVUUZTYnpPa2x3ZzFQOWJNbndPYjJCSG1Gc2RJVXFBcXBEeUpkMENvZjdqTWcyMEZnSkF6bHRlUnV5NThoWVlNSzl5QzZCY2IzOWRmQllqbEtXSWc4cUkxSFRXYk9nUDkyU0Vlb2xRR3J5US9nUmFONTI3WjJDV2NjbE9aZlFCK0lVdzdGYnQwNDBBb2ZYcStBR2JNMzVzMURQeFdCcUhjMHJaMG5rNFp3QWIrdFBWRWtwQ2VwajZ1bjZrcmh6MkVoTHJtWmNCYUVhL1E2V0s0eGJmaVVlZnhIVkVqK0F2R3VVNTRLbnZsM1czRDdTejVvak1KWWF2ZjdzMVBaZ1FWNWhibFFUNTM0SDdhQUNNQjhSMmlaOWhkMXBQckZMRk9ieVFvRkFMYjd3MUhPcDcyekJEKzg5Y25jV0l2cEF6cTFyVkVCYzBPdmVWUWZLalVMa05WNmhBU2xxdndYc3d4MXF5QTNLWGtQWHFrUHNvQ2tpODZsS3E3SFRFNVlYWlRhQTZOTWFnVG9mdk1HZUh1Y0dENWhtVWRhWSsxZHVPdTArdmxZQmpMMmpTVVd6WTRodkxjSVl4Nk04UnJMQ3M1eitROGxHSzlVTmZJcDVCMUVEdDdaczVCRFVCQ0pyUmRxNXphTGxYVHY2enBPWTllQXphenYzMjd2N21vWkF2bEpsOGdOMlljMmVjaHlpT0Y3L3hXVEM4TmRTbEtDajY2ejNpczQzK1JHaUxEOU5OZFJ5YXV3MzE2a2p2d1BoWVhkVUQ3dXU4Yys2RGl1VWMyam84SGRuQXd0TkM2WWh2TTFmY3pocHc1RHhDczh2TnZyZ2NGYnlUNlFCaDJ1MEl6ZVZsOUZ1d2JnRnhXejY2ME01dFZUWlhOYklFZUMvSkVmRlBPNm93NWVCZVZxUXF5bk4relpwQ2w0KzNsQzVaTWhxV1l6dTJRZkRlaGw5ZCtaM0svODZlVUdsTEhvM2FacENnSUZRYWw1cGRLY3dKMFNBNzN0TGdCVkVmbGtVTk9uOUdKbzVPc1lWY21WU1c1WVB5ejVaQXI1L2ZHRW13aGlwM05EZng2dGV5VzNMMG5TNHNNdnRkZm1rdUhNZk84Q1hpWjVxV2VSTVVnRmZyT0w5OEpYdUZrMkVmY0NoQkVyMWlybmVFREVSeTFOYWtuVjJkVmVjcWhxYTVpN0svTmlCaXZQMU5ERVUra0VoRVQwd21HY1Z0VnQxYi9uazZ6SDk0OGVVc0pIeFlkUmxHR3pkeU51cWljVHU2dWlzQVcyT0h1Q3hpcW02TzhwYjR0TGxZVkM1T1VTaHBQSzNhTjcyTVZyNlYyWmh0RkpUZnE3b28rNnhNN3krNnF6d0xZMWYvQkxyREsveEhOS2VxVHlJNWx4Sk9PbkFlbW1aUDNDdEdQTDNzdXdCZ25abGp2eitjZ2hLS0g3UThqLzFRSy81RG9oTEFuU3VXcFdnaVJCek94c01YNWJwT1J5Zkx0MDNjNENTU2hweVdqWGZKbyt6ZFovU1dpOTJGV3pVV0c1WEN0NWNoMExDU2pkZTI1ZU94b25abWpKMm80dk45T3dWK1U3M082NWpIT3hLODU5M1pLQk5sZ1lUcENvWEZnRUhDQnRxbEg5Vk03Z3RKYkJqUUZDR1FZYXdrWFQxZ0EyR1RzQ3dLRHBXWSszZVhkWXA2NUlCUkZMWEtxbWZSYlh5NGpubWJPelQ4SGxXRkFtb3UybXZ4aHpvUEVLN1p3VUlCK3pGMEhicjVjSkN0a21mVzhQczJrNGlYU2t2MXdZMXlJYmRiU0trcXMwbGMzYThWVnVtOWZXLzhjZmV1WkNGRVArUUVwTEk1S1VlelJZTDdETy96dGRhcEZyWnRKVXNtTEgrZGN6TEkxRWpCKy9VT3FBcWVNdHMra29RZFhtazJnV2Z1QWRKRnBobjlIcmJJLzNYS201UWtIdkFsTk9ZMTBUczJqZEhFN2xOSVJtTVhpdkxERk82VXFUNHAxRnVrdzJOeWNaWWlPZmNiU0Nwd1V6anMycHE3OG8yL1NZQWpsRXVpUkpueFltalJhUkl2NjhYbGpjWm9vUG51cUtLVUdSMmRzR203b3l3WW5DTUhKbUxjS2F2TnNqVk5zOWd5d0haclVBcjZxVDZLVjJMT0JFVTNtVFVTR2VJYXd2T3k2ejNKMXJWZzFTdCtyNmQ1K2RCRnJQblhaNVVhZngyeVJ1ek1BRzZxODF1a29maFZydjg0bUNFNkY3TUhDVGM5Y0xmL0IySFJrc1VNdTF6d1hCcXRneWhRRWZzeVcybUVYUWMwVjMvTXl3WnFGdjJZTTFzYjVpRDlCYSsxS3psNEF0QkZsWlhKUzZ6ZS81Y2U0aGZEblZpVWlCNE5FU1puVmxIeEc2TGQyeGgzNWJ4NFpFQ0VpZ2p0UjExWkNtbHRUNTZsdmdPeDNadDdZQlBKVVF6LytYRVQ4QXlocTNrNUhoOGJaSi9FSWdlZmNHaDZsOStLd2l4QktQT01hZkFmRGJBVlhVenMySnpZRkU2T3VXTFdXaUVwelZvb0tNTk5JOWg3UFZXRzZETkVDaXQ3SkVtNlVWOUU4ZVpkN04wc0h2SXR5Y1RRWlVwWXRtNmJKVDhwQ1BwaCtUOUlNMC9PTzMvVjU5aXZxTHJKZEhoMVNjbEJ2OStPY2liaE5CbFlRY0FCbExRRkdFS1FUMUx0eDZVN05ZbHZUTFFpNGdvbEkyYjVHTzRmY3pxWG1wQjdVNHFueHlWaWl6ME5GdS9nZ2dRd21udkZZN3dnQURWNlFYVEFZSzFFa2VtSHRzRjluN3UxQ3A3aVErMTFFU29oL0R6dGFoeElPa0p4bGl1dk94bmZydVpNSkNid1loMENXL05vVnlkTWlNYmYwSWg1YjdReHhVanR6UnhTMUNXcWlSMDNqMUhzczl4Y0x0OW95SjZqNmFBMTZtRVg3NUsvY2d2aW1mcS8wckREREVLTWUxS3BaeVoyVmRqdFdiT2R1a2VvTTd2RnRleVlvZmowVzd5KzJIb0NIT0VZK2lQR0dTMFlhU1dJc3Z1OUNEV3doVjh4VWsrZ3NPSnNaMlh3SFgvY3B1N0NpWjRwNSsvT1NSZE05TldZWW1xb2pEM3BHVWpGZFlreko0Mk5KeFl5R2NFODhPVTluVGNHWjFHRWFyYWltS0w3SVdnZXZYdFJUK05HUnBYYjcyVmtlR0N4RmZpRXJlSnZJUWJCbFBZdkR5NTBTaGx6VVBDSWNpcjhhZDZsMzBJa1EweHhwWjdWZVFZOXhvL2w4anBZUklnMmlaa001dVRPZTMraGY1NkF5aWF4SVRxRkpWVC9qbGNWSjBCWU1kY3pkd1IrYUdadU94M2JxMnI1LzFTQ2hoem1rc1RiMjZSQnJMVUFVV1c1SGptQzIrUVBqWTB6MUNvQUQ0Y0Q1emo3aGZvOHdCWkppY01kTjJNQVh5S1V0dXNwM2FmdWxKaFBxYUhhN0lnWkdzZkpyZ1puL0hqQWZPaUozZEFQbDFyMHpLZkh3eWlybFV3Mi9KL2lpd0psRmlBYXN0L1lxaTJWQm1Lbk1LUTlUbml4VnVZSFhhMGdzdVlLZDdzV1c2ek9CMDdkSzFNLzhNNzczcDlCRW9Xb0FEdHZwcWdCMWZxN0t0WGU0NFVxUlBpQmkwYUlqLzlsdk8rTGVKMmUvUlhUZmJMbkxFV1lQVWJnOVY4VkVYeEhzZGFlUnh1bGoxL0w1VGt5VXpFenUxZkx0OEJ5K2hPRGxxZmNRNGYwMWcxUDlOUW5rKzhRWmI4cll2ZHd4Ty9tSGxTVjRYcG56dVZmcGlPeWJoWlVVYm9hV3FpQk5EUWRyamFhZEx0bU1jK0ptTThpK1dLL3pIbDVoM29xZHo2dWtxdXVXTE9TdFRUdGc4Y1JVVDUza055QkFBUnVvR1ZsKzVZRUpYMWRpS0lIZXJEK2VOMnh0RStsTFB4UC9ydWExQXhvQnIwOCtWNkdpQkRaTE1zMENlVUlBWkczZERvZndJSGNpZ1lBYVR2WFphVExmWW9FTmxaVXRLR0JsczZFWWhzaTJmelYrNlB4VEsxTHhIbTBabmUyVzI5Qk5mdXNpU3JlZ1A3enB1TXB3MEVUNE1YMXQ5bW5KRmFMN2syWWZGOWFKZ3l0N0M3U0U0dm5RNEdUT0llc3NQZHAwclhDV3BGS0QyRU95RnJqUTdzZjNpL21tMzhOa3hBRFFvc2huR0JTZnF0ZlM4R0hhSlVxbVpibEhZbzBJN1FOaDNVQnB2N05iRkV0KzVCZHdQS21sN3ptM1BnNjVRREttbGJVVHNRZE12OXl2R284cEVnQkc4M3QrZ0JIZHIwQ2J2RVduWjV3aE96ZTQxeUlUa29WR0FtN040T29BeTVlU2d6VFNXVVRNVm16L1lQNE5hZzlza3FkMSt3NTFsSXU0U0h1Mk5adllEREhOQzR1azM3c0VBeGZsUHZBd2h1T3VtZERqSUs3YXdPakU5SUkrUlZjdGRwN2tQZ1VsWTZ3UktWNk41Mnh6bCtJR3FTbGV0QVA3eDA4YmtDSThUWGVoTTdnakdUeWMvR1hhUEt6aTdXVVJDckcyRG9pUDIvY3VWWDNwUTRIQ2lBY1QxVVVrcy9nMjlLMGtwVXdkNWIyUlVzRjIyenQxNTk1TWNxMFIvOEM4amJBRjZSZlZQWUp1QmJnRkRiOGpBSjR0V2JnL2pkMmZEanV0R0l6aFlPNFBCakY5R2lkaWd2elBRYSt6T0k3MkxjUWZWc3oxaTN4Z2xLY2xZVVdTYjFQaEFMWnl4Uml1U0hjZ1Z2S2VRclcxUytxYUZ1bDJucHZ1V3NYNzUwQy8xOVVyS1RWMStqc0NVbk9ZZWZRVnBsSzlPOCtWVGwyQTc0WnBQVXRaZ3ltRTRQVXh2T3EyUkpYRnhwZktDekpFV0drYUxXdEM0Ti9DMGV4UU85K0UyaE5lanF1ak83ZU9sTlk1a05kaFpyS3VidFptazlhbnpMZENIZUVyQUtGN29XUlU5SlBZak8rb3dXN050L0FYVEFJNlFFeGtpeVplNmR3ZWRMR3VHYnVrTGJMYUNNb1RkZUtzV1RmdmVmSHZZVFAzbVRITFlBMkNkRVRzTWJVQWhLK2cwb3daVkVvV1FGNGZJUW1HcGhENFlFNllONW1nUUNHQUt5N3c0bXZsRHMycDVLS2o2Zk9ocU0rS25kTGhSajBtY1BFa1UwdmdxTkRZVHZTYVJnSGFHVjVhSUl5N0huVUpnVFF2ZzlBakdRWHdCWHFtZ1BVLzMvSjIzWHc1M05ia3ZHQVpQdlY5cDlTYUNoZ2JJQXk1dlE1amVVN29KTHRVVkVvTWk5UWNIRzAzWldIeExFeGM2Y1RmRVBCWE1LNGN0dHlxelRHMDZ1YkhNUE5oeUREYkk4V1RZeGVTVGhuaHE5bm1ITTlmT2h2eHU1UzZFUlJ3QStCemdCazNIVkNwbno0VVZnUHN5SEdNWU85NUV5bWlOdVoyUEdiWU5UaDFUZXJmVWRpV2psa0RFNndpM3FkTk1xWFhhN1loMVc2Yk5WaGZPRFE1eVd2bVBNZkY5elEySVR2Z01nN3ZqQ0lSc3E2QnE1UnBtSGlJaGlQYXlxRWVLdlJ2NXE0b1dOR3RicTE5T3h4aURsUHJlVVdZQm5BcDV6K0NtTmJWNG1mY3JEWnFkaXNITllHOTBXZ1NGNHRMeTA3K01Lblh5b3pTTDZSUXZUR0FXVUFVaXNhVGVJZS90NkQ3NVRacjlSVjNobnRBVnhVanlHbGxIMGFLWDlOU2tHK1JubVRPVU9Nb3JlRTNETS9SeUVLVXhUbHRpajQ4Z002NitFRGFlNDRDL3hrSjdxblJOTFNaWUM4VHpjeU00cWpPdmw2WUI5SWordkpFKzg4Y1YwTEUyTDgrU0EyWTBSMnJ2WWdZd0h5VzIvZE9JWkt3L2hPaXV0V1lod2d4NndSTzFPSkF2WUwrc0poNFg2c0tnWm9PK3ZDUnk5WkNBUGhqNVRKMzd1SmNJbGhkRk0weFpjUWN3bjJEZ0VSRTRFRzdNazlQODBMRlNGMGJKalJFZHlva1ZEMHl0VzBSYVNlZzFBQUNlZXFZNlZiTE9lUjc1b21wTEtIamEwUEkvME5JMUdYZ3hVUDNNMHQxdXc5eWN3dlFMTm9iZmFqZnd0RjMrVU1la3V2eFRqMjV0K0FML1QrYllTL1dxWHNtaWtKQVZ2WmZxNEV0ekVBeTFpYnU1QitpOXYrQjdmRGZlbi9ZTURxOVBPV1RNZUFEM0tWWHhVVDA2UEUrRkYyOXp2NmhhRUZYbFVJWkY0azEwNFVYOGRac2wxNzExVzN1dWZWUTRIWW8vMnpsZUhuancxUlFpOHhZb2dwOTJsenowa3Bta2YvdzZ2bmFIQ3p0cmthQlZTUWNWaVhqaEpjbXB1OThrRzVaemFpejJMOXRtWU9wdGlxMTF5OWxCWGgzS0c4N0hDSlJwSzcrQ1lOWHNtekNNQWJqOGFZUTZrWFBWSk12WGlZd2xhSTRncXlqL1NXUko3L3kyRXliYnNDZkowRkpVbjBZMDVQNFhCWElwMkZvcFFUR2F1ZnNLdjV1cFU5K2dpV2RvOEVQREVUVmNZc1pRek1EVEhWdFNlS21SOVFEclN4UzFvR0ViNEllTjE4dHRQUFBCNm9CL1lMN1VDWmE1NElQN3B6dnJ2WXBndGpvaEd5cnREWThPeklBTHFaWkdPR1k4NWdrSWNXakFOTjRqUXZYeUxydEgrdmVlZHRUamZ4bXgxSmx6MDFEdUdvL3dYWUpKcEhiZ3NBblJlTkRHbm85Zjh3Qmd3ZEJWQ0RMWDZDeFhxbVZvcGRVTGlHdmQzZWkvNXkvSkVmSnJxczhaZHJPdUtCQW5wbitzL2JGcFV0WE42cmhqWHNHTnFlNmRzbDlVUGhubFpOWkZKR0dHeFBhd3g3cFk0R2JSTFNrOHdXZVRWbVRsVnNBRVE5ZUcxWDkwYmxsbEs4cmpZOE9vSDQyVFh2NnAxM0Rzb3NlRjlPK2N0VHVWa3NPalowQVhieGtsSUNWM0pCNTB0OTlOYzNFNDZnWEFIVlZUYWhub2hvbmlFY3hJU3dwM3lKV1puaWF0OWJnekhsdU1xYmVraTBLaGhCSlU5QllqUk4yZFc2bmVnUGxLYjVvdkdXQ09lT2NBdWw1YmhvT1Z5WUN4WEpJNTBzZ1JtYW9VTGtHMDd0a2NIdHhHWndNUkt2K0VPc25Va0lnNnpjNjBxQkFBVkJHZzNVanR3ci81eCtLcHIxdVkwSVJIc2ZZOUdWYTgyNlZpd2pEQ0ZNcjZRMFVLbVlNcnVkSXlUTzNZWit0em5aTUlxcktSYzZQS25yQTRsOVRzcUtheHZ6VS9mUXROY1F2R0t6elBuQ2JWZ0szNGZpWmhMRGtmY2c1UW1tT0ZiL3lpMzFJc09GT05yNHVtdGMraWxBZENkTVdEL1RTZ21rRGtyTkcxZ1l3NWtOT1ZGQWFxYzIyYU8wMy9ROW1jczJCdlB4SkdpUHRZaCtoVTF6RktxZlFpRDM2VU1VcWlTUGUzVC94NERjSngwPQ==', '2025-06-08 22:17:28', '2027-06-08 22:17:28', 0),
(4, 11, '90ED3294E31EB959', '90ED3294E31EB959BCE92147540874CD4850C8C08CA5B78280DD647E35A117A4', '-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nLS0tLS1CRUdJTiBSU0EgUFVCTElDIEtFWS0tLS0tDQpNSUlDQ2dLQ0FnRUEzMWRa\nQkVWclgyWkdxcjhRYWJhVlRvcm9PY3NUN0ZjeGxmYXFEaytYZG9EQkdSaTBVVnZW\nDQpTTlB1YzRsMFBSR2M5ZVBsaDBtWUdvdzNPNkVFYWl2eFhpdWpDK0o1NjVQcjBM\nbHJEakRGdTNmeWhFMnA0VlhpDQplL3FoMm9wZG56T0xOZjg1RElBZkxubmFtQ1pJ\nUUVnbUtzYUphMkQxUXhUOTFCaWpuMFZGdWJuT3RUNWoxbitBDQoxVUJNeHg3V3ZU\nZTF5RXAvNW4zSjc1TXNWL1lqVEZQcEhUdURPOVFRK1dSWVllUUdacXljK25oaGpK\naElybjhRDQpjVnhiaWRvdDlVYjVJV3IwcUQvdmdTK0JkRFdqbmt2eEZHaFI0bXZW\nTnFzWDJReGxyZHJ4MW1ZbkR5aG5Cb0hPDQptWXM0U3JqWDRjbWZGTEdNVTBpNmNU\nZEdjOUExWnNKRXhxOEV5MHpiY0RDZ1BoWmRSTHBPZE1TS29JNDhDY0IzDQplVlJE\nQXFKN2x0U1pNWTlKRUdzNVRYK1EvMEx0NkJFN00rRWZjdmM1d0xIOXo1cHJWcTcr\nRzBVRzR3VW9mM2hMDQpxNXFBdlpTdU5PYnlQZnVwL2dkNUtFRHdaUzh6TVdmY1lH\nbm1KWXdCMWJXTm1Nc05TckZxSXkvM1ZiUFdkZk51DQpadU9sTHArUW5VSkc1N01Y\nMWFsS0pGSDRHTjNaLzRNbGlITU9QU1UyWXhqNGR1QnhDWDJnb1dZMTZERUxIb3Yv\nDQorR1ArSTF0NzFsQWM3cVh3WXdTV2RWb3RQdUhSODc3TWc5VlQ1NHZJbCtVWFRX\nRlRxczZKWHRDWWxWVlFDZVA2DQpid0hxQ0tlUVJaVGNkeFV0YUQxUmxBczZVUk9x\ndXljOXIveFV3VERsOFhGVVdQaEQwRWJOWWVFQ0F3RUFBUT09DQotLS0tLUVORCBS\nU0EgUFVCTElDIEtFWS0tLS0t\n-----END PGP PUBLIC KEY BLOCK-----\n', 'xjDA4/A+r/8knNBxzisdxFh2OEw5T2tPK1FJQzNmeUczR3VzTnZjZDk2UFpJTFFFb2xRSnJ6MElnVE9RNTVENkUwdys5dmxZWnMySDFYV2EycDNOeFU0MEpVOEtDODg1NUFMWjNFZnpQMFpFOGh6OUc5czdSb3hueWtZczlIYnVvZ3BkSzBsNXVUcTNVOHNMOTJiamQxL3Y0OWxlUHJmK1pkdmJUNVlFRnRuRFV1cXgxR3Jsa2lvN0srR0o4T2VsS1VGdjdaWG55S3ZoUEdjcW43VnlUMXErMytYWUxGOHk3NmZ0YStCRDRpYnVmOTdQMHEzd1V6RDRzcVVTajZrUnIwZDR6MWFtL0lqQkFqbVRLa1luUWZycGdUdk5MTXZ0TGdrdTZ4VElhcjhEbEQrY3BGN2NXMjN0aisxOW56YlFlL1FSSEI4Q2lUVk10aVRPRjhnVm9GVG9taE0wczkyL2pxcGRMNWFXc2dkYkNkVWs1S2dVR0lhZGVqZWkvQjY5MFMyQ2NySU5UbTk4UzVzaTg4ck1pZ0g2czh0N2o0RXNwU3JGc0VKUy92TzF5VEdINUlCWDJFbHJnSnlJYlhXajZzNjExcTNuYXlXTkppa25CeHBEUUU1Vi9VWjFqeDl0cCtzTS9mZFlpNnd0MEtHcnYwMmxXbVlKeHZRYXQ4WEpQN1NoMWZqM0s4K2d2QzdkTFZsTTNqVTVsOEJ3eGs5aGFhS0NSQUZ5dXhkMFYwZ3hYQ3dLVFl4azlNN2czM0VtQmJkMGhXa05mUXVYYVN2c2RTWmRaazRzSlN0ell5UU5DVTNwMjlQeml1UFQ4dTNqNklEa0h6SnN0Qk9PQ3VOV2J2YmVHUmwzSHdoY3Q3Z3NrVE9LamIvQ2VlZ2d4Rmp6NUg3cS9FelA5aVlZd1pVSUltQ0NwT0N0MG1HcUxUZDNqeEgwdnU4N2c3YzdsQzdDZFZleW51d3VoYVlDK2dnSHBKZnc5Y1FnUnl5NXpCanRCNEdHVG9oU0dpeVAzelRsdHFjeUh1SGZtbG90cEtzd3laTDd5ckIrU0s1Y0dTVU4yYkZGTlNpUkpRcys5d2x2MTl4b1hmekNPWDdNUGU3TzFidGNDbGpleThlTTFGK2YwWWpySy9CWE1pSjVOZm5lUUE3Y0JZUnhEVUxXckhXTktYWmg1cHVaQWovYmtRSnRIY1YvK3B2aDdhSG5PYmc4cWJZTzBzVnY0bUNqSFRaY3hyZEw3TTlJR3o3MzlqdkJLR0lwelBodWpPYWZhR2hsNHVvMHFRVkI5RUNUc2VtVnorY1lldGJvMDhFd0NKOFJDVWxJZlJGVjh3YTRUUkRyallIM1lNVG5BL0RBMjlmWHVWRmdqV2RMOEgvZzQ3M1phWDIxMy9EVmk2aFF4bVJHelJZQ3hnenBxb1pqSHdSMUZhUTVtTnBrbTV4UWo1WDBwYno1Q0tVeHJ3R3JWc1htTW9ncGtkZyt4bC9BRk9DdkI3a0FGVVlveGI1d3B5cVpwVjhzY1c1My84My92SFJyTHVJNFdaWGd4OFM1RStWYmZ1UUx0N2lrQURicXJ1b2RWei9NL2RUUXprNG1jWW1UU0FCOXAvdVZHaTlZNzAwYjZZYjBSTjB1YzhTVzdETERSMEtrUkNMM1N0RW9CVzR1c0kyU2RuODRqc3l0LzYzUW5LV1J5TjZ4KzA4NnZIbTl2SWZMVUpwMDJrVzRTVEdYY1dZQmY0MldDbXpOM1BBNzZoNk5POWJOOWE0UC9SbGc2RmMwaWJUcVhSZVFFTjM3L1dmVzhDUXFyZ1orcnBRY01raEtMU3o3alg3dnZ2TEtKRmsxOGwwU0N1amE0YytVc0Rpdk84MFNjZVFQZi9nUzlpZUNNUFU3YkVjTjNBcUQ2QjhFbGRubzRLMVJubG92c3czLzhPUHlXR0t6bDlSTDhEenAza1UzKzh6V1daS09HUDhVcyt0dGx0VVk4Z3A2M3YrN3Jkb3lvNGZ3eGVwWVJpWXJrRzBScTJEZ0FlMCtzVWxzZW9wZzIxU3l0dmplaklUWW5DSk9BT3Z4eXlDQTFJbm54VjNsZXllSW5tMUxBSFNoT3RuQ3hFMitWeE5IS0wrS2NEcXFKV0FmZWhzcDNOLzRBL2FjdEZvckl4MkdzdTVtZExzZkxENVlpVmNHRUgvZk1UN0NZNy8vZ3dLWlB0RHBZdTNvYWtkR2xjVks4cW9pNitsSVdSM2FMcHJ0bU1qamlHME5iRGZnQktpbDdvd25LdkxYSWpydktZSWRyNGZGdEJGbmpEeUZVeDdUZVBIbkhROEw5RDhBZzJZK1owcEZ5ZFVVOGZCNnQ4T1ZKbzg3THB3NWloaVBuZlZWeTNPNE9ldEQyVnFrWGFIRnVUU0gvSXN3Z0pRcElqakJUeURLSEtGaFc3L2hRRDRkcGpBRUJsOTRQbDBGeFpQaXoxRUp6YzgzL09zT0E1bW84NlFrRm1zUzJZT2Y2a2ZVWFhuV1VVMC81emR1OWJIY1BPMlJHd2Y5NzQxNEYvSWErT0NlZTRNUzJ6UG55ZVYxcFozRlltTCtIZDYvUk1zYWplVjhMOXpDdzBKRDlUNWtXalEwWnZRY3h1Y1JYb08yUVRoKzRIajRiSGFOT3VCNTFNRzYwTXU5MHRPcHVqMnd2YTlnT2RWUmZVYkhGWEllWXpqNkZEa3hDYzNlcytaOGF6R21WOTNWRkcycUVvY2V2RE12Y1k0VEJ2Z0VVSktsMWQzVFJEY0FZeXRkOUJ1eVpnaElkdFZ4bE5sSVlEYXYvSGJlUXpzYnZTK29FbVFLbWU4MTAvaGpQUDNPemtGVkE1TjhGelhlOVBLUmZGamwzKzhrRmt2Ylg1TkNieGRRTHRBa0d3T1I2ellGbGhNU2hSbGs5cTc3bWlLTE85eUVMRzJWenJyU2hBM0M0Vk15NDRBSmlpaUxIMmF0bWpJcy9LN0tvZnZhcEJxUGJ5blBkTW5BWGtxc1NDL2hjZlNqdUZqdnpiaFVYSVRVRytKSmRUMDJPYmR2Y25reUFPUGhobHgvNm5SSHV2eHBHa1VJKzUrQlUzRmNmUldualVzQVNVMmtaTXY2cnBPWkVQRU5tL0YxVXcxa051elgrZmtZQVA3RFZiQjh3c1lNZWRwVkFmUEt5QUE4aTc1Y1VMd0pnQ1llMW51WjlaOHQ4OE1xMGtOWXQ0WW1uOE9vaE16Q3VXZTFzcEdBTHJwVjhQQlZjZjBHaU9nQzJFUXc1a0p5aGZQN3ZVYnVUUWVIVVNNQ3JMMEZpRWNheHg5WjZEVXVtWFdPTUUyZnhXeFlPekIxS3B6a2U4d3Q5RDNQTzFWZEYxckYrTVUwL1FQcEhJVGNQR0xrZmZNdVdxVkNHaEI2M3BYRFdLWWQ1QjY5WXBkVy9OV1EwNWtrV1lwNndSTmZNdkFIa3g2WkZpU1FQTHQ0eDJrY0NhRDdqUlhhNlgvNFdqUCszQ1RCc3VJUjYvd09oT21IYStHRitacEtTc3R5bUFZWWFLZVpYMkNIN1FnemJEWW1LSHBjeHhvbm9NV1ltbzk1dFJsYVBGaGRNSTJreU13TWJYL2UwR0lXMi9LcmU4SGdKYTJBd0VlVUNPSVZYTVpXdmxoSU9MaHV1ZnFmT1hDT0JxU2phT0dKTzlvVk45cFpraC9VMmhrd01tOE1mOFk3cWNhQ05OYUxNLyt5KzJ3RHRxNEEyK1V3WjZucEdyWkViRDlwUG1kWjdXV0laaGpzTFN1d2VSbmdzM0syWjhQT21Oc0R2dm5NN2J5dy81U1pqY0EzT01HUFNrdUd3NkN0VkwxUGNKQitkL2pJZEZNSjVCSGlsVklYa2tuSXZncHloRTNNTGFPelFaL0RXVlROQUgwSE5uY0pWTHB4eHlNcS81RjZHZ05SazdIWWZqWlFvZlBLNzZKMG9FWGNXd2RGS1NiQVNpU1cxK3JUVmh0NlJIVGlBYVBvYkw5VU9ONzBqcnJpQjgwMFVhZmNwYmU3OFZuUHlMbUk4TXh0OEF2Q1JDVml1Vk1xdXM1NDRpWlJ3ZFFjeVZxSG0vWElUQWxRenhvdWVZeFFDUGcxa2hYZjYzaXczaVl1bUd1SmtVSGtGTmVMYVVyNnIzZzZ5eVdLZTZiYlN3ekxjN2xPUDRBSWVxeHYvMEVJRjR4OXRGZ3RVUkNZU0J5QUFrb0xRYnhIR0dSVVY5LzZyRWxVTTI2ektFL1RzQmNtNGlwM0pZWnRtT3haMktaNmQxTktnL1JxU29reW9HamtnSDhPRitpaXhINkhjN3RGZFQxZTZ1aldGbjBwNjRtbm4xdStoUDF2Vjg0b053R09FV1ppQXFQK2VxeUQ5bmlSeEE2L1E0OU9mOWM1RUxaTEo2eHl1eUZleXVON1plS2pRTCtRcVRQMWhHVjFqbHdndWxEUEU5a3dCblViN1ZaaFZhRDZSM1V0cTVZZnlCZEZSQmRXZW5QU0FyT1hUbElWOHhlc0NzY04zLzkvUmJST1ZKYXcrUlpRdWtxQUlldmRiV0VLQ2hlenN1MHNWTnBFR2orVGc0UGZYN3ZPK2pRUHg1VmVGZUdkaytOY0IvT1VMMkxVK2lrSkFGWU4yeXlYQUZpYittY2VnYUF6RkY1MkZLQWlqbTYrN1pvRzFXc05uL1hpQ29TWjZ2ZDVrZFhOYmZ4Q3Y3SUhYNFdqMktnd2drNUVkUGs5UUk3VzVBZzNqMXNlUHg0VFJuSmM3ZHNCVk5qVHhLUmdVenFOdmtybXdDNkNQRmkyYWd6VXJxRkJnTElSb00zbTFsM2lrSHRHV1drTllDWXBQVDM2OXFVb3ZQMzJzT082Rnk4VFIvQkFjbjQyb0x1RXpaRUdQc2JMdHFTRTkzUGdoMGNRUjJ4S0p4WnFMem1JYTJaOG1WMnpJUk8yWUhoUHFwN0NUbEhZUGxXdFhKNGFvNDdqT2wxeElrZlZPbzZxV1FTN2FvUk1Yb3p2YVJobDd2YWRwTkkwNmtseGFiUjY4SUozT1JnZkZrWVdwOXBqa0xZQm1QSmt2eldPOXVFU09rSVdlNG92TVBOc2xXYUppYmR0U0QxYWJ3ZVM5TzZ0UFM3dFlEemdUMkpPdTdZc2l2eDA2UnpNODdyb0xYanhzYitmV29VY3MxaGIvQ256ejN0MmthVnpMeks3dlJmTHUzNzYrcW9jcmVhVzlCWVkwSTFmUXNhbFhrZndnYmZFRzFMbkcwSHMvOXFidzd3SWZmWHlKRXpxMG5jWnN6SUJzZ0djSTMyNHc2WlhvelZCZytyMEYvWjAwZ0xmbk9tUGJHb3ZjUVp0NkJPT0hzeWx1VUZ0TncwejFwMTZESjZWZHFicU9RYUMwWi92RlB0TFBWdEE5YUFKL3NrQlpQM3FIbm1pcFozd0VPL1FVQWhrWUVOZTdzZ1JwK3VZN09ZOWw0UXVxM3R4aUY3T2FWSXBpdkFxZU51Tk5XVHVrTFlhM25ua2lTMjV1a0Vzb3ZkcDBpWUZkQkIvZWg5MzluVk5NTnNMcDNtVHc5YklKT1ZGWDdjeEphUEorQ0RRQ3UxQXU5NGZHU2kxSU41V1RRaTlOVFB2WGJESUgrbDkwaHBpYUh1RDJKU2Zzb1BnbzNQV2dJdXFiUDR4VmhveGNsOEdzSkhVZDBMeFJaenc4WDlmbDhFNVFKZzhPT2Z4Sy9vNW9tSlF4UEZPNTJ0MUNjdFRmbVRtWnRtekJOYWg0NWFUNmxtZ09RSGxoWlJ3KzBjOWVydnZFTFlSbm9md0dqZXFoSmVENDJ6UmhhVkpSekdUek5VSmRHRG1qMUZqTXU0eEVUUVlqU2RNYTh3QUlCcXE1MnVlKzlaQjVDQmRJejU2SFBwb1lIeU5kWm9oaERpT3dXQkd2TXl4bnIwa0pGR2x0SjRheDVMbUl4ZHZmNHVIZmJhenlBWWEvaHFBQmMwMDhQdnU4SFB6VUFlYStTY040cmZTNDdpNEI2VmFwU3VFMlBpRk9WTDFwM29xNkZNdWhmWS92WGtpQTRXalBsSkZ3YXZuUFFjbW41QU5rb1pRNVExamJtV0dCK2Nxd3hzTGZoSVE2R0daVUVySzZ4RUYxNU93Y0N3UnRPZk90RjNQRW80S09FM2h1OCtBZlRvSTMrZDhkZFM1VzJESlZmMHhUT1BKRFdMbnhiRVRMK1FRRk5sYTFiYmZ1ZklMQjk5VGZscEpnTVVnYlB0NVl6OUo3b2ZzMnlkRk9hWlNYRkZlRTNsWnRUc01ZS1UramRvcXROTHFYMnlodWdQSTEvMnBzTDZTVW5lek40WGpyQzVYWVFoWWkrZnRReVBRWDhMYVVVT0xCWEdMTHpiOXJTUER3V3EwZVVOc0phR2RVMGQ4SGtObC9tdE94Zm0xMDJEUjdXTWhXZGtFQ2l0YjdmbGZyV3ZkRUUrcHA1dktmdnRvSXlmVjE3bHA1dWlCTW9SaTlLWmFxRm1JUzVLT013ZjVjTEpNaGo3RDdndFltWWdxVVRrYzZnWTBQSDdrU2Z1RXRPOTdSK2Zsd1R4elhuOTVUcjJKbjlwYVhyU3hNUXdreUdPdmhIanhvNHUzSmpVNHFoZmdQaHJ1ZE8rM3pDcTlVQnRmN2t6M1loRkpENlkxZmZ6UXphRGJJSmtzb09hcjdmMWlDUEtnV1IwYXRYVnUvK0FheFRtTWFadGxrbTFSM1RSMk1RUVZHem5rUDhaYjRTWTdNV0k4OEpJYkdnaTJmZ0pDUVVUbDkveERZaS96TzRwc25td0t0SE5aQjltNTZGNmFjWnRUeXVDNUlqY0VUbW9RWkxXMzNUQWhvenNEVEFKYW1ZYXJZWE1NdWJ2SHU0ejZNcXpkeVgyZXNaZnhBbUNlczNTaGJCSVVDNWxMZGRZSW8zMTZmK0wxdGZYYklsbWtodG9hbkN0YTJXSzlzTU1yc1ExTnBGdU04TzB1ZEtWY2RVR0JqbFJLd1Z1dXBrSWlKeE93NE9jQ3dDbEdOYkpKUEk4S0pBamJaQnQ3MjRZTTVoQTNEUHdVK2dRckpUQnR2S251UkdDQzJHNk9RYklpTyt6c0RNbEN2bmo0VERCd0JFclZCOTBQT0hZWncwZHJTUiswRkd6aDl6ZFJvYjEyZUwxZ3N2OUplTENKc05ZNzdZVlh2RzdFL01KeDlBemxDdHhKSmtvSTA5RHNpVUM5QnV2WnFjK1FjRDV4Z2ZwZ0REV2tmVjY0Qm9ldjBjVmxZeUxzTGVFV1A5QmxQNzNFUW9ucEVHWTdqanFUMGdqRTlvUXJhNHJ1dHcwYmRnY24xQ2RQdW5PNzRnM0d1L21vcmtCY3V4MGhxUEJVZE1VMUhpZENZTVp4QlJhZ08wSnJIZEdUWUNOQm80OHNkSFdFUCtBNXpTWEVjR1BBamttK2ZKV2RyVVJyWm5EOTM5UGhJcnRTTXA2QUl6cGZKRW1EeVg4a3hCV2hhK21FYlhpVjhnbzNFd1hldlVMbmh1S2lUN05weXBNK0VBbUtEQUUwd3Uyd1NrUnJZbVRaamk0UkxnNGd5N0lQK1VoVlZ5MXlVZll2UE9WTEFnYkJJVnlPUkQwMjM3M3lrSmhDKy9tK1laelVRQ0pqaW9LK0w1REV6d0RmUjI2Qm5XbFBjODYxd1ZHZGdZSlJFYk1QYTFRUkFvTmM5VHpIdXNEZ1hUNU43bDNqMHNqRWx0bWY1ZFlKTkYwWjluemEvTlBwS0FLZmVKSTdqNERHUE56d3JIWnVUVk9zQWZyWURQS21CaXdIK1lmVnk4NVVYQUpYWlVvQVQ2eDg0MFRHVHB5VVBCTFNqem1vczcxK3JCVkN2RWVRSjVOdHdBL3lqM1VONi81Nm9zbllFRFRrOHpHZ0piOHNFTGY0UWR5OENXZWxsNzZSb3Znblgzbko0RE1uekNQQXpjMjhrYkxrZ0wraldOZ0VSRkdwMWhVcXJiWkdXV0Q2TmlFMGNGajhBQUIxSnJOejVGbHNST05uL2ZTdHgweFFDV1M1YlhWL3Fkei9tbnV5OU00VURmbTg3TEZYQWIwSEY5TXNsZW5Uc3NkMHBsNWtRK2U2MWsweitDY0FiU1FnUHNRPQ==', '2025-06-08 22:44:37', '2027-06-08 22:44:37', 0),
(5, 12, 'CFF8697D93149314', 'CFF8697D931493142E19C54685F05F16FB0867F669A915D865ED140778E78C54', '-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nLS0tLS1CRUdJTiBSU0EgUFVCTElDIEtFWS0tLS0tDQpNSUlDQ2dLQ0FnRUE3c2VQ\ndEx5UFFKWlVzTitzSlB2a3dpNWhSZUNYdVdvREJHTGRSVFRjcHFoWDF6QWZiZU4x\nDQpUT2JEWTdWM1NLRExoUnBnV0ozejhtVUZMS0MzTmpnMjJGK0pYOEVtTGp6bWZv\nUThoa0VMc0crVmJXbWl4NUNVDQpHbjR5ck85Qm1XOVY0c3FabzdjTk5zYVRtOWZL\nQmNhSnlMMGp6WnlBNVBzb25qY3IreGpPZzJXOWRkV05QRTYvDQoxZitPdXVPcW5U\nZDhZNmJJYS9oMHdYdHA4blo2QjNNcXhGcURLeW9rTk5UK25BaUZlZjhOZnM1RGNT\nT3cwZGdODQpkdkRzL21uQ0ZnY3FTSkJ5VG9kMXYzbFNiUjBRNmwzYzJCQXYySFFs\nOEp1ZTlVMThkTU9RRnozMFR3V0wrTDJaDQpFRERIZlFPUGM1QW1GZE82Vm1rdk9D\nUmJTRU9KYmwzTXFDOUJhendwMkttUGhLd1FYOUdpL3gyaDl0MHNuWU84DQpKR0xo\nVzNRSUNmb2ptVDN5eTBLSnlSVzJqRGU3THNBZ0o5K3REdjdIRmE0QjUxd1hNK3JX\nVUY4azJXdllhcUJ0DQprYnVuc0JqUThuVzN4NnJqaDFDbDRBY0dLa1BlM3M5K3Y3\nQ0E4bDU4b2Y5QWIyOXdmekF0b3k2RTBIei9tRmxyDQo4QStSWjl2b0pNTWlMdk9U\nREQxNHZLV1luV3A0cXFQUjVyMXBReUQwK0xtUnUzZ1V5dTFMbUd0NU1FaFl6emtZ\nDQo1eXpqOVp4L1h2OTJ5MXZCdHJWRG9DWXAwNnlBbSt0MGVpbU8yMUc0SDBacDdZ\nRGZ3QUJjbFBSUkw3RElDdkhHDQpaOTVoUlJtaTE2a2FGTXNqSytLVW4vVVNhZG5n\ncmJRTERqNVNacUd3NGRKNkRoZ3lYMlR0YnRVQ0F3RUFBUT09DQotLS0tLUVORCBS\nU0EgUFVCTElDIEtFWS0tLS0t\n-----END PGP PUBLIC KEY BLOCK-----\n', 'pf/3Mrre60h5I1kaGOe55Gpna1EwNWVuWWtIb3ppQTNsNkpCWHRUMFpyVVhsYjgwaVVKZW0waStraklCNElCSkRRL3YzblBXWE9QMVdhVXBlRUpkM2hhV2ZhaHR5VHdZbnpIOS9qNXdTZU94NTdkeS9ZSHhkVzhHM2NDdHlDSis5bE9HMzVHU0hGcHFMQlF6Tjl4MGg5VTJXK1RYVjhlS04yM0RvUjN2bGowL0ZkdlJLeGdzN0dRNTBmWUZkMzUvRWpSL3FxUmtpRXVYRFhpaXQ0MmorcFl6ZlZQMmRRRDJGcG9nM21PS0U1UDlzTHoxYm5jZUlVOUt3V2hKRmtZNE5landDVkpwai85TEplQVh5Nkc3eTM4Q3doNjVBY05kK1F0L2R3aFY1TUNVUzU2NjdGYS8ySU1QL1RqWlM1cjZ3SkdKTkI4aDVKbE9wb3ZGWHFkbXJ6OGhhTlF6UU1abmR0MWtBYkJjbCs2RWhWeUNXTjRsbGRaWSs1VTdSb3ZLZEQrNjZZOGRjcU44Nzl1TUVzcVhTeEJJRWF0MmdjS2UzQUNYSk9FOWtuMk5GMmZhNC9JVUJuT1JZZlJ2V0MyVHpoMCt5UnM2SktUR016NUtEd283OXluZUhmTEVlZjJ6ZlRIcGwyeWMwMEVSV3E4YnRnQ3o1VXFPYUhpZ1ZFSlhCNEpJQjZpTTJzUzhsTG53a0VNU2ZJUndzeHF1d2NZZTdlbzBmZnFWaXhhZitnWkVkek5rQ0FqL0oxYkR0RVBGRmJsNmkrMkVwbDB5VUlVOHY5WkZYRUEzRzh2ZzFaWHVPL1Y4b3VLaHZsVnRYQnFwWUZQNDVJVm5xVXgzZFBBeVpOSzRxZ0FsTEhid1F1TDcyZ09sRTM1TVNpQUNadFlRaW42VWpYemhXRExabENaRWEyQ0dMejBKTVB6Z05qdzdhUEp3SHduT0FoUnFnN3NmSm9kcDUxWGNiTFVtOStXOXlDblJtb0JKMlc2TkJVMzNKZmFzcmxRSytKTjFzRk5QMjdiN1RpaDhZVlVGV0YyYlM0M2xldExyRDlPRkpsRnhMTnF0U0FGN1drb1pGc2ZNNXRyQXRWSlY4cWxlbDAydGYxbG4xc0lUcnpySW5zU2IxaFcvSldybzNuRjNuNmdBTmdlT1J6NStxeHdTZTBNVnNEVWpBTlk0WnZGamxyUzd6eVlYNTFKTkRrVmpsbFlhQmJ2MU0vQnFaTEVDTTBVVWJTOGtsWDBsYUloNFFybC8wb1pZN3UzTzZjSXRJODg3ODZFM2tLbUt0NjAzcUVKUE40eUdrbW9NN1lLekYwemhHVVUraks1Nm5oaS9GdmJ4YzNmbDFFcWd0dW9RL2ovd0xTU1FWSjNvTHZuR0ZRbFRlK1BUcHJnZkpKaDhXMUo5bUZDR01GVVQvME1hcWcvK21GWUFPMzFkUGZlbjRFZWREREpVNDhEOXRXSWdBaUJsNGx0dzdJMUJib0lGMW5USVFyUWVHN2UxOEVzSGlvZTZUaWdKazk3ZHBhU01LOVN3WWZJbG9QMFdaTzVXMCtkcXBySDg4U01qRkR4aENsczYyMjg4RVVIb3BVYXdKeXkvbXdSc21tbFVFcjZaaXYvaVlXbHRBcW4wQUJ1UjZIM1NzZ3NtWFZodG82Q3c4R3N2L2RpcGV5U1VBZ0s5VncvVlBTRWI2a0E3Q3NwTGJzbEQvSDU1cFZGdE0xb2JwdnIrOGpVQ1NzNWxQRS9VL1lsSjBCQVRzRnB2Z0cyaHdTTXc5Z1RTWXUyODE5RyswbE5LL1hUdnE5c3gzQmcxVGZscEs0OERQd05JZUwxc2tNMHoyZE5XVEQxUDcvWFA3eDdoYkdFTXZFb08zSXlkbEhzRW1OYVZPcHRtN01Ua3RPTWVmT1ROaUYyVTFLVW5VRC9LVHFiSTRQRHVQWWsyVDRGZTg2RmdRKzhMV0JrNlE1VmpFMVBRTElWUmwvU1pkMU9VOG1YMmJjK0lML2NPQmNUUzRLTDRmbUMxOW1VRk5ybjZWTEdWbGpyemRoSVFxTHFNaDhtZ3k5aTlZVU9SRnE5TmVnWHNSUm1LRmhVN0huNzF1TFBncHpleWN4NGhGK0xnM2xWQk9iNURTY01FWXZQbFVDNWxIRUNuU01lTG1sVVEwWjBPUXBDbG5JTldFNWpJeHJMWkRSSnE3SzBVTThQT1ByeEt3WldnRFBEQy9CZWdJSDl5UHg1dnN1eWZ1UlFFZGVRaWNyNWVSYUs3cW9NbEczQkxJbGVSZDBEQktmQ0thT2lleEN4akFUT0tubDdDZEtFeHB0Nm5ZNlNGWHZQVkp5M2lZR1pzVkVyQ1BoeFBVd2RVNnR4TFUvUkhpS2srRlRwSmR5R0NQSGwxOFN2QURiZ2ptRnE5cTV6Z25oMDdSbmNjSnpyajFuZkFJTVNZL2Ntc3dib0d6bzlNemt5SlRrVi9Gc0wwOG5ZZm9jUHc5ZHlLaVpoOFZoSE5tRER3ZzN6ZlRlRmpVODZiR2svZzRiUC9ndGdxakJNUXJMcEFvV2pHemNld2JKTHFQTFVUY0l4TWQ3Y1RFOGVISGxrUDVEQUtoWW5JM0wyTERQdmhQRFhaaWtYNEZnd0N6clFveWRSd0NaSDhrbzRzZU9EV1hHMlRETmdyeEdYd0NNYXN5Qm1ZaTZ5SjJKSFBSYk9uYWFkT29hK2QwRlhPbWZaUGtvWlVGc3ZwU3VYQ0cwaVBVZmk5Q29xckpuZFdvVVlwTXl1WGxocUdvcC9vZ2NpRDkrZ1M0WXFVeWtoTHFsVDJHdU5Tc2pkN0VUL2Y5cU5vcmlTYXpjd2JVeU0xRkM4SVF4N1VPWFNDdHpoVjMyU1hGbGNoY04vKzRRaWwwNGcraXhPSDVRdXpUcTFGMzlSOU1xdGdqVFNNbTliaGdrRnJmVGx5d0M5bnhSZzNHamJxVFFzTVJKQkFaMzJMZjhYaFJpeTNsaXRoeXBvRDRxVGt0T1A5ZUQ4blI5cTJYSFZtUFRiTHFpLzVZMXY1TnFvaDV0b012c2kyMFR0cm0vU0Exc0Mrd01hRTN2aS9RWUw5cTNLbnZVdlQxT1Yyd2FZOFltWnFobVNzS3orWFVzcjRVTGpMVW5HQnE0T0kvQlo5amFuMHdlalgydGQ2NUhhbm54dkNOVHQzd1FDOW5aQ2VYWWpvNXd6cCtsRVBGNVc5NUZ5UEljL2o0d0JVV0lRVmUvQThwTy9NV3IzeWY3MWExYzlnYmhRYTBVT2lLWXBGMmoyeHZzWVpQYTBlcHJhMGJMYW5HTGtSV090cUl4QXZCUW5KSk5jL3JRN3NlUnJ4ZjV3YmZWbk51bHVJK1YwS2tGYm1YYlZRTmRWNkRsM01DQ0h2S3JWZ1M1REdrLzJWZVJ0djB3QVIrdWI4cFlrZUZHeThtSWlGdUZLQXNCOVpSdDFMaDRuOG1xcFJYZ1BpTklYWmplaSsweW8vMWwyNEpZaFp0UUNVRmdEZHRsMElHNTRIY1gxRk56VERsUXY4ZFh6R1I2aXMvNVpSR1dudEZmeDNrSWxjMGZhNHpZV3NKSUluOHhndTdTUWxTazdVVWF5ZS9zQWVKSnIxeS9Vdjd2K1IvanFzZmllZ0Jvcm1EblNEWXVGSHN0eGhRbGVYc1Y5bHdWcXFsVkppTG83cDhTSkhzUWdMamc5K2M1QlgzRHZUZm1rb2RldFdpcldOcnlBdHZBcnNOQ0s2bTFtcS84ODMvMng3dmhhakM2dTJDd3FFSTJaNnVSbjAvRW1HZHJEZkZRdzNGOTR2Q2M0djBMVUVBT05YM3N1TkVpSXVIVERwM1Zpc1JxYUpPTnV1YnZmQWF6ZWhWYVVicmpsVnNDQ1NjdHExUWVWbVdZNzl1a3VUb2pZdzFVWGJIRTAwOEVZZ2cwZTVPWnNHR2FHd0ZleEFkL1JRblhQVVhxSUlGM2tNZ21QQlgrRWJCb090NmNvZFJ5Snc1amhTRVpzSjFjRUt0LzhwRlBBU2RGR09zb3g2amlFUmh5K3lva0VmTmNCejVyNlVkVkRBWXZUN01iS3ZIT283YWdYS0FjREdXZmZrZ2RIaUs2emFKWTcwQ2U4bXgxbjFiWGQ0TnhlNkdJMklDVVh4SWpCRVBEeEVDNnBtZjBRN2tJQ0JBdERPMXIwZUtJZi9KWTVqcklVeXJuTE1SN3FCbUk4UnkxelpwUjlUc0ZHQmV5VG4vZ1hnR3JqSmJXQXlGNnJiejErNjBLWHN6NE51bk8yZmZxUFo3Y2h0VzJ0VVYxNlR1dkNGTnJUVjVYbkdUN2FYZXBDKzJ1akFYV3NZSFZkK21ZbWxPWVdCdUxhMnFWNVhlSVRXMnplOGt4QzMxUFNxNlFYd3dyd0dWbVdzK3JUMmVSYkl1VVoweWhmRThjM054ZnBGVklJTzhpV2ZUU3prSmdtbWZhSnVaR3BEQ0ZISTRaZG51Y0VOVStCRkVuZ1R1QXZOY0JNUzlBd3pDRGFQY3NxL0FQVkVoTWo5dnlwN2V2R2tjamVzMWJPZ3dPdlpFUW5lVWliZG0rUC9sVTRvZUxPWkdZTFV0YWJlWTBhZVA4OThkbzExSXB5aERNTzF3Mk5pQTVZS1cwaStMQ1dkTWw1RlJVdzVSSlA2Y0oyODBTaEhBL3NUKzV5NWpDREVzVC9KYXpWbTJZRG5wZzByeU0yTlZqUXVHV21aWWg3TlJ4TlhMNkEyM2dOK1BydnkvcWxDZVlHdmNPdW41V0xpcGNVd3hMNkVYOHhBVE1OTjkyTjk1czZ3U3piK3pGZ2xEQUFNOEFlZkFpTEJ0N1hlTzVLQXhZcGFKeTg0VHpNZHNOQ3VNekhCVnFPb0RtazRWTGRZVlhhTUdzUCtodFZ3TVZ4aU5PazJhY01kWnpScWNReklpMVZvL1dzdXlHaHczWEFZakRQWElHZVVNWlJmTzFtME9oalpNUEJMQi9YYUs1Y1JNcFFaeFNndGpjb3U2M3dueXN3dU9LVWZKcU5zamxscVlFSXdwRGc5RXdaZnVHNG5vbk1JVFlyL2xyUlNzV3MzVWNGWlNja214YVZsWmtpVG9nSWtkOWdmdlJWaDVTOEZFWCtNNUZJTkdYQ3p5cGNzd01rZzQzYTJVMnp2OEh5eUQ4c3hQNXBPR2hONFlmU0dJL1ZaeDUwQ3dqam5MT1JIZVhJTEpmMWdvL250K0tvNndpUHpOZWJrV1YrTTMwcThuVTFVbktDRU9yUzFDaUJ6SXVRNHUrTGR1WHpva1hRQWVhR3lTRTd6dFpINFhjR2ErbGVNeTNsS1FvS2k4bGtGTjAvelRvbzJBamEwR1FISWs1M1M4TngzNzNmeG90VVVacmJnSVowNTFqcEdzVDYrM3lYMUNPRVZoVWRlNnFmUzFYaXE4b1MvWnJ5bVpmMHY0L2l5ckVlTjBTakU3cnd2aDBVWVgxODVmNjA2ZTVZNWNVWDFpaGE5VFhrM2R6T2NMaSt5NXlVam9rWDF6SHFPL1R3UkVpTkZibEZuR0hhaG93TzdvUEYzczlkTzBZSnVIekN2cmxmaFZKTFhGRXVpNE1SdncvVXBkd1hzem04Zy9Vcy9nV0NTckoxRENyU1JkUytOZ0x5QTVBL1dqOUpsdzJhVWdCeUxoRWxaVFh2UU16cnNxV0JsMk5VRWFJL1VCV1RhaysxOWowWjIraGRnMGZXQ2ZSWTFCZG9Td1dJYVJMdjE1UmpUSjVmNG1KSEZ5RFAzKzA1Q1FSRUYxYUVzL213RGYrbElvSnhQcVQxTTNSc3hJSjBzZnJFUmVTNHVEb1BQeFpPNWxEYlM1WmhZbkFOcjNiSmRESkR2UXIzV0djNTRyUUlwbFUrcG4vcm05RUpucjBFNHhBRG16ZEVZaDh2VUZTT0dOOWJoVVdJSGg3SXl3WTVETERVVEtFR2dwd2JtUFNwRkc4WjZTS0JYbWdISzBXUCtRQThiTUFEVG84Z0FWdkZIMXkwMWdZRzlpbXJtZGR2ZnV1OHdsS2MxT21IQjI0TWRoMTE1SW5lTVUzSXpnWFVLRHF1cFVLQ2JIeWU5djJrWU9RUHBRNDJlMXU2aHhadDF0YUo3c1VJNlU0ek9WM1VQQ1lHS0hraW8zVlZnaE02K25jMzF1MURpSTA5TlFBbGlWS2N2czRCRTBvREFCTnNRelAxOHBkRFdsLzZUTzRteGRXNUJVcVlOcWxaRjc2NEc0cWZHcmg3czNaOWtrMW0xOHhuR3BzZnlNR2U0Rm1FSEZDazA1YktmTHpWcU04VFB1RCtvdU15VEVDTnhOaGZHRHFZeHNIeU9aQVlVa04wbVpadXpiUHpmWm1wTjNBKzExRGtBd0dSbXFVNURzcEU1QjZOSXhXTFZjdnl1V1hZcVpEbmRxRUw1OTFPQkJtSmR3RXZnNE4zeFdPR09NU0g4ZXpIMzVROUNDZ2k1SW4zUVhYUk4wMzZJdk80SUlESVBoTVljRFlTYm5ocDA2c3pMOGF5WHVtN1hmQXhhOUM0b0lkamlDNVFNMlhOZUg2cktOdDdaUlYxckE2aTBRNlFtK2FyNGtGY3FrRTN4NkEvUVQ1bDY5NWNuMEoyZVFJQ3psQnJwYUE4K0dOZCt1eHlleTh6S2VDbVcyZmEyTDRjcDk2VTliMHNIaDAzQWZyMTZXWS83ZFZJbzdkaVpiS0ptUUhab2FIYTczSVJtdXdLcTh3Rm1haldlNXRKYmFJQVhLRjFDbW5ZVXNFelhvK2htd05NWmRHMlFoVFJmODlDSThVNG9WcEVaWGlHbEZlNFZBYnh4ZnJTanQvNFhYRUNxRDR3R3VUbTcvL3RibFJqUWc0K2RDQ2JkMmhhRU1uZ2dtd0xpWmtrWjhhVXdDSGpJZzhwTjhIZWl1Nm9WYzFMYTRzdnJLNVhLQTliRldIV0JOQ3R5US9QTk5IQWJjYVI4aVRpRzQzdzA3d2plMFo2MW94TmFIT2pwNGt1N2k1dHRrRVd0WFc3VzZZYmNvTjhuRG9MZms0L2FscjdQNnNUR0ZINDdmWmw4NU5XNkZCc1RUaG1UZXBRZFBFMk1WMjR4RkJFN1IxazZHak9DQWg5dnA4UEdTSm9RT2l6VS9QL25tenQxd3BqS2J5UVFPV3NOSllaSlduL0ptL3FwN0FkeTdOUldid2N0QzVhMGxLU2ZjR0kxTmpMMGJQV0Jvd2FoQzlJZEdLbnd3OXRjWGtnb2R3b0ljL2lrdzNmSExVY0ZXS0VUMjdPSnlRR1N0dmhzaHlKOS9WUU93dndqaFZ4dFFyTkRvQU5LamRpMkFEU2F6ZlduazJLTGtCRkhjR3EvQnhRY0hiSFpTL2pVaXVLeWFsSW9FMEN1TmIwSUdTT3ZxMnNPV0VVNm5tVDJEOHhCUjF5NUJIdXBVNHVBbzBuRFhVUjZIbXYwMUdDL2ZHeUd3R1gvWTgwR2M4SE5rVVFiN1ZxR2dpT2JBVVJvY3JjL1BNVDl6MU9GQkVnb3JXOWpaWGpNVksvQkkzQlkwZ1JwcVQzcjMxNEFxcXhNRGhxdDVMNDBLeTFYR28xWlFIa0JIWUZDU3dEWVpaRDlKOSttNXVIakV3ZDlVYnM1UThEaURoaEd1VUlxVC9CZk1wZ0NHYTlWdDJXdVFUN0o0QjNIREdQVS9EY3B6OVB2RE9lZTl5MzNnMkk4Qit4RlU1cTRaZFQvYTk4Vmx5c1NnUVlsZUJ0Z1J3Y0w3YjFCY3J2NUFrVlRDOXBiQUMzLzB1ci9Wc2VieDRmU0ZSV3pJS3R1bnJBUXpxTldoM0ZoMk05RDBjdmVEMmpWK3Zka0plOXdDMFRFNkMvMHBrSWNQT1lsd2ovcERlaHRvUmdNcE1LY2RvWFNzTjQ3eHRHWXdTR21hcExZbEQ2L1A5ZkVXTGIzRW1HWjhXOWxxM1hvSHhaMCt2VjlrcGhySmI4MXFYTmFSNWpnTkkyVXluYlcwcmpRckFhNzRQWlRpNWZOVTFnTWhvSnl3eFNQV2YwbFQ1S2dEM3ovOEVac2c5OHlPYmhrT0lLWVYxcmJxSy9iT1lmbllNSG93Y2hWT04wWnhBOEU5aFFFQ0hwK0VoeEtaSy9kTmo0PQ==', '2025-06-08 22:47:18', '2027-06-08 22:47:18', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendedores`
--

CREATE TABLE `vendedores` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `btc_wallet` varchar(100) NOT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp(),
  `eth_wallet` varchar(50) DEFAULT NULL,
  `wasabi_wallet` varchar(50) DEFAULT NULL,
  `criptomoeda` varchar(10) NOT NULL DEFAULT 'BTC',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vendedores`
--

INSERT INTO `vendedores` (`id`, `nome`, `email`, `senha`, `btc_wallet`, `data_cadastro`, `eth_wallet`, `wasabi_wallet`, `criptomoeda`, `updated_at`) VALUES
(7, 'admin_CTO', 'z33m4rketofficial@pronton.me', '$2y$10$tclv1wXqu/rdENwPTYVeBewI3L0wIlrFusrT0wwf.mDK3pBq4rgbi', '', '2025-06-01 02:56:26', NULL, NULL, 'BTC', '2025-06-05 22:03:40'),
(8, 'mtfckZee_psyc', 'z33m4rketofficial_vender@pronton.me', '$2y$10$WxN9bAyBnoo2kK.f2TXxBOliZK0IonCjIAEgXOMXhuxizq1O2yVN6', '', '2025-06-01 18:53:16', NULL, NULL, 'BTC', '2025-06-05 22:03:40');

-- --------------------------------------------------------

--
-- Estrutura para tabela `withdrawal_queue`
--

CREATE TABLE `withdrawal_queue` (
  `id` int(11) NOT NULL,
  `withdrawal_id` int(11) NOT NULL,
  `crypto` varchar(10) NOT NULL,
  `to_address` varchar(100) NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `fee` decimal(18,8) NOT NULL,
  `status` enum('queued','processing','completed','failed') DEFAULT 'queued',
  `attempts` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_at` timestamp NULL DEFAULT NULL,
  `error_message` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `withdrawal_requests`
--

CREATE TABLE `withdrawal_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `to_address` varchar(100) NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `fee` decimal(18,8) NOT NULL,
  `crypto` varchar(10) NOT NULL,
  `txid` varchar(100) DEFAULT NULL,
  `confirmations` int(11) DEFAULT 0,
  `status` enum('pending','confirmed','failed','cancelled') DEFAULT 'pending',
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `approval_required` tinyint(1) DEFAULT 0,
  `approval_reason` text DEFAULT NULL,
  `risk_score` int(11) DEFAULT 0,
  `method` enum('hot_wallet','cold_storage') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `xmr_transactions`
--

CREATE TABLE `xmr_transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tx_hash` varchar(100) NOT NULL,
  `amount` decimal(18,8) NOT NULL,
  `type` enum('deposit','withdrawal') NOT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  `address` varchar(100) DEFAULT NULL,
  `fee` decimal(18,8) DEFAULT 0.00000000,
  `block_height` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_action` (`user_id`,`action`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Índices de tabela `admin_notifications`
--
ALTER TABLE `admin_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_read` (`read_at`);

--
-- Índices de tabela `balance_history`
--
ALTER TABLE `balance_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_crypto` (`user_id`,`crypto`),
  ADD KEY `idx_reference` (`reference_type`,`reference_id`);

--
-- Índices de tabela `bitcoin_mixing`
--
ALTER TABLE `bitcoin_mixing`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mixing_id` (`mixing_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_input_address` (`input_address`);

--
-- Índices de tabela `btc_balance_history`
--
ALTER TABLE `btc_balance_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Índices de tabela `btc_transactions`
--
ALTER TABLE `btc_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_btc_transactions_user_id` (`user_id`),
  ADD KEY `idx_btc_transactions_tx_hash` (`tx_hash`),
  ADD KEY `idx_btc_user_status` (`user_id`,`status`),
  ADD KEY `idx_btc_created` (`created_at`);

--
-- Índices de tabela `btc_wallet_changes`
--
ALTER TABLE `btc_wallet_changes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `cold_storage_requests`
--
ALTER TABLE `cold_storage_requests`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `compras_ibfk_1` (`produto_id`);

--
-- Índices de tabela `compras_seguras`
--
ALTER TABLE `compras_seguras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_status` (`user_id`,`status`),
  ADD KEY `idx_vendor_status` (`vendedor_id`,`status`),
  ADD KEY `idx_payment_address` (`payment_address`),
  ADD KEY `idx_created` (`created_at`);

--
-- Índices de tabela `crypto_rates`
--
ALTER TABLE `crypto_rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Índices de tabela `encrypted_messages`
--
ALTER TABLE `encrypted_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_recipient` (`recipient_id`),
  ADD KEY `idx_sender` (`sender_id`);

--
-- Índices de tabela `eth_transactions`
--
ALTER TABLE `eth_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_eth_transactions_user_id` (`user_id`);

--
-- Índices de tabela `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `hot_wallet_utxos`
--
ALTER TABLE `hot_wallet_utxos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_utxo` (`txid`,`vout`),
  ADD KEY `idx_crypto_spent` (`crypto`,`spent`),
  ADD KEY `idx_confirmed` (`confirmed`);

--
-- Índices de tabela `login_logs`
--
ALTER TABLE `login_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_ip_address` (`ip_address`),
  ADD KEY `idx_login_method` (`login_method`),
  ADD KEY `idx_tor_used` (`tor_used`),
  ADD KEY `idx_pgp_used` (`pgp_used`);

--
-- Índices de tabela `multisig_configs`
--
ALTER TABLE `multisig_configs`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `multisig_transactions`
--
ALTER TABLE `multisig_transactions`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `payment_monitoring`
--
ALTER TABLE `payment_monitoring`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_address` (`payment_address`),
  ADD KEY `idx_status_check` (`status`,`last_check`);

--
-- Índices de tabela `pgp_keys`
--
ALTER TABLE `pgp_keys`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Índices de tabela `pgp_signatures`
--
ALTER TABLE `pgp_signatures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_hash` (`user_id`,`data_hash`);

--
-- Índices de tabela `platform_wallets`
--
ALTER TABLE `platform_wallets`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vendedor_id` (`vendedor_id`);

--
-- Índices de tabela `purchase_logs`
--
ALTER TABLE `purchase_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_action` (`user_id`,`action`);

--
-- Índices de tabela `purchase_reviews`
--
ALTER TABLE `purchase_reviews`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `rate_limiting_logs`
--
ALTER TABLE `rate_limiting_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_action` (`user_id`,`action`),
  ADD KEY `idx_created` (`created_at`);

--
-- Índices de tabela `rate_limits`
--
ALTER TABLE `rate_limits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Índices de tabela `security_alerts`
--
ALTER TABLE `security_alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Índices de tabela `security_logs`
--
ALTER TABLE `security_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_action` (`user_id`,`action`),
  ADD KEY `idx_level_created` (`level`,`created_at`);

--
-- Índices de tabela `system_config`
--
ALTER TABLE `system_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `config_key` (`config_key`);

--
-- Índices de tabela `system_logs`
--
ALTER TABLE `system_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_level_category` (`level`,`category`),
  ADD KEY `idx_created` (`created_at`);

--
-- Índices de tabela `tor_hidden_services`
--
ALTER TABLE `tor_hidden_services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `onion_address` (`onion_address`);

--
-- Índices de tabela `tor_request_logs`
--
ALTER TABLE `tor_request_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Índices de tabela `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `two_fa_logs`
--
ALTER TABLE `two_fa_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_event` (`user_id`,`event_type`),
  ADD KEY `idx_created` (`created_at`);

--
-- Índices de tabela `used_totp_codes`
--
ALTER TABLE `used_totp_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_time` (`user_id`,`time_slice`),
  ADD KEY `idx_cleanup` (`used_at`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_wallet` (`btc_wallet`);

--
-- Índices de tabela `user_2fa`
--
ALTER TABLE `user_2fa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `idx_user_active` (`user_id`,`is_active`);

--
-- Índices de tabela `user_access_logs`
--
ALTER TABLE `user_access_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_is_tor` (`is_tor`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Índices de tabela `user_backup_codes`
--
ALTER TABLE `user_backup_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_unused` (`user_id`,`used_at`);

--
-- Índices de tabela `user_notifications`
--
ALTER TABLE `user_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_unread` (`user_id`,`read_at`);

--
-- Índices de tabela `user_pgp_keys`
--
ALTER TABLE `user_pgp_keys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_pgp` (`user_id`),
  ADD KEY `idx_key_id` (`key_id`),
  ADD KEY `idx_fingerprint` (`fingerprint`);

--
-- Índices de tabela `vendedores`
--
ALTER TABLE `vendedores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `withdrawal_queue`
--
ALTER TABLE `withdrawal_queue`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created` (`created_at`);

--
-- Índices de tabela `withdrawal_requests`
--
ALTER TABLE `withdrawal_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_status` (`user_id`,`status`),
  ADD KEY `idx_txid` (`txid`),
  ADD KEY `idx_created` (`created_at`);

--
-- Índices de tabela `xmr_transactions`
--
ALTER TABLE `xmr_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_xmr_transactions_user_id` (`user_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `admin_notifications`
--
ALTER TABLE `admin_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `balance_history`
--
ALTER TABLE `balance_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `bitcoin_mixing`
--
ALTER TABLE `bitcoin_mixing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `btc_balance_history`
--
ALTER TABLE `btc_balance_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `btc_transactions`
--
ALTER TABLE `btc_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `btc_wallet_changes`
--
ALTER TABLE `btc_wallet_changes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `cold_storage_requests`
--
ALTER TABLE `cold_storage_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `compras`
--
ALTER TABLE `compras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT de tabela `compras_seguras`
--
ALTER TABLE `compras_seguras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `crypto_rates`
--
ALTER TABLE `crypto_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `encrypted_messages`
--
ALTER TABLE `encrypted_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `eth_transactions`
--
ALTER TABLE `eth_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `hot_wallet_utxos`
--
ALTER TABLE `hot_wallet_utxos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `login_logs`
--
ALTER TABLE `login_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `multisig_configs`
--
ALTER TABLE `multisig_configs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `multisig_transactions`
--
ALTER TABLE `multisig_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `payment_monitoring`
--
ALTER TABLE `payment_monitoring`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pgp_keys`
--
ALTER TABLE `pgp_keys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pgp_signatures`
--
ALTER TABLE `pgp_signatures`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `platform_wallets`
--
ALTER TABLE `platform_wallets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de tabela `purchase_logs`
--
ALTER TABLE `purchase_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `purchase_reviews`
--
ALTER TABLE `purchase_reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `rate_limiting_logs`
--
ALTER TABLE `rate_limiting_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `rate_limits`
--
ALTER TABLE `rate_limits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `security_alerts`
--
ALTER TABLE `security_alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `security_logs`
--
ALTER TABLE `security_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `system_config`
--
ALTER TABLE `system_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `system_logs`
--
ALTER TABLE `system_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tor_hidden_services`
--
ALTER TABLE `tor_hidden_services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tor_request_logs`
--
ALTER TABLE `tor_request_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `two_fa_logs`
--
ALTER TABLE `two_fa_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `used_totp_codes`
--
ALTER TABLE `used_totp_codes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `user_2fa`
--
ALTER TABLE `user_2fa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `user_access_logs`
--
ALTER TABLE `user_access_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=199;

--
-- AUTO_INCREMENT de tabela `user_backup_codes`
--
ALTER TABLE `user_backup_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `user_notifications`
--
ALTER TABLE `user_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `user_pgp_keys`
--
ALTER TABLE `user_pgp_keys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `vendedores`
--
ALTER TABLE `vendedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `withdrawal_queue`
--
ALTER TABLE `withdrawal_queue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `withdrawal_requests`
--
ALTER TABLE `withdrawal_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `xmr_transactions`
--
ALTER TABLE `xmr_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `btc_balance_history`
--
ALTER TABLE `btc_balance_history`
  ADD CONSTRAINT `btc_balance_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `btc_transactions`
--
ALTER TABLE `btc_transactions`
  ADD CONSTRAINT `btc_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `eth_transactions`
--
ALTER TABLE `eth_transactions`
  ADD CONSTRAINT `eth_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `login_logs`
--
ALTER TABLE `login_logs`
  ADD CONSTRAINT `login_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `pgp_keys`
--
ALTER TABLE `pgp_keys`
  ADD CONSTRAINT `pgp_keys_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `produtos`
--
ALTER TABLE `produtos`
  ADD CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`vendedor_id`) REFERENCES `vendedores` (`id`);

--
-- Restrições para tabelas `rate_limits`
--
ALTER TABLE `rate_limits`
  ADD CONSTRAINT `rate_limits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `user_notifications`
--
ALTER TABLE `user_notifications`
  ADD CONSTRAINT `user_notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `xmr_transactions`
--
ALTER TABLE `xmr_transactions`
  ADD CONSTRAINT `xmr_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
