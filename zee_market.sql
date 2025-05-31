-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 31/05/2025 às 05:29
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
-- Estrutura para tabela `compras`
--

CREATE TABLE `compras` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `endereco` text NOT NULL,
  `btc_wallet` varchar(255) NOT NULL,
  `data_compra` timestamp NOT NULL DEFAULT current_timestamp(),
  `vendedor_id` int(11) NOT NULL,
  `concluido` tinyint(1) DEFAULT 0
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

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`) VALUES
(1, 'pedro', 'lonelyfalkoor78@gmail.com', '$2y$10$KjUohwHZYLxgi25lAQINuu7UVcgWcsdgEeEmDZL5p/AF6vEpyL1f6', '2025-05-25 17:44:39'),
(2, 'pedro2', 'pedrophsantos2@gmail.com', '$2y$10$QgFWQ8/o/xgX2Cp1j3jJ0OrGMZb0sFk.zsZZro3fOm1kZdCpyEa5W', '2025-05-25 17:49:12'),
(5, 'felipe', 'felipe@gmail.com', '$2y$10$xSKwSI7aV8zFmAPX5F8bnuP2WG9bBQ9QkX6JSt0XlAoRvDkAtu0pq', '2025-05-30 01:08:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendedores`
--

CREATE TABLE `vendedores` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vendedores`
--

INSERT INTO `vendedores` (`id`, `nome`, `email`, `senha`, `data_cadastro`) VALUES
(1, 'pedro', 'felipe@gmail.com', '$2y$10$Hf5h56KoCaCjuMDFcNV4xOjq7r0FQaZ0RyXt/ClVWh2/SbaWuYVem', '2025-05-29 23:40:07');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produto_id` (`produto_id`);

--
-- Índices de tabela `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vendedor_id` (`vendedor_id`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `vendedores`
--
ALTER TABLE `vendedores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `compras`
--
ALTER TABLE `compras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `vendedores`
--
ALTER TABLE `vendedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`);

--
-- Restrições para tabelas `produtos`
--
ALTER TABLE `produtos`
  ADD CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`vendedor_id`) REFERENCES `vendedores` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
