-- ============================================================
-- DDL real do banco MySQL `analise_setorial` (exportado via SHOW CREATE TABLE)
-- Dados ficticios de demonstracao.
-- ============================================================

CREATE DATABASE IF NOT EXISTS analise_setorial CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE analise_setorial;

CREATE TABLE `dim_comprador` (
  `pk_comprador` int NOT NULL AUTO_INCREMENT,
  `descricao_comprador` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`pk_comprador`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dim_loja` (
  `pk_loja` int NOT NULL AUTO_INCREMENT,
  `descricao_loja` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`pk_loja`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dim_mercadologico` (
  `pk_mercadologico` int NOT NULL AUTO_INCREMENT,
  `descricao_mercadologico` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_comprador` int DEFAULT NULL,
  PRIMARY KEY (`pk_mercadologico`),
  KEY `fk_comprador` (`fk_comprador`),
  CONSTRAINT `dim_mercadologico_ibfk_1` FOREIGN KEY (`fk_comprador`) REFERENCES `dim_comprador` (`pk_comprador`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dim_produto` (
  `pk_produto` int NOT NULL AUTO_INCREMENT,
  `descricao_produto` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_identificacao` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_mercadologico` int NOT NULL,
  `fk_submercadologico` int NOT NULL,
  `id_unico_submercadologico` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`pk_produto`),
  KEY `fk_mercadologico` (`fk_mercadologico`),
  KEY `fk_dim_produto_submerc` (`fk_submercadologico`,`fk_mercadologico`),
  CONSTRAINT `dim_produto_ibfk_1` FOREIGN KEY (`fk_mercadologico`) REFERENCES `dim_mercadologico` (`pk_mercadologico`),
  CONSTRAINT `fk_dim_produto_submerc` FOREIGN KEY (`fk_submercadologico`, `fk_mercadologico`) REFERENCES `dim_submercadologico` (`pk_submercadologico`, `fk_mercadologico`)
) ENGINE=InnoDB AUTO_INCREMENT=999019 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dim_submercadologico` (
  `pk_submercadologico` int NOT NULL,
  `descricao_submercadologico` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_mercadologico` int NOT NULL,
  `id_unico_submercadologico` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`pk_submercadologico`,`fk_mercadologico`),
  KEY `fk_mercadologico` (`fk_mercadologico`),
  CONSTRAINT `dim_submercadologico_ibfk_1` FOREIGN KEY (`fk_mercadologico`) REFERENCES `dim_mercadologico` (`pk_mercadologico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fato_analise_setorial` (
  `pk_fato_analise_setorial` int NOT NULL AUTO_INCREMENT,
  `fk_produto` int NOT NULL,
  `fk_loja` int NOT NULL,
  `quantidade` int NOT NULL,
  `venda` decimal(10,2) NOT NULL,
  `lucro` decimal(10,2) NOT NULL,
  `data` date NOT NULL,
  PRIMARY KEY (`pk_fato_analise_setorial`),
  KEY `fk_produto` (`fk_produto`),
  KEY `fk_loja` (`fk_loja`),
  CONSTRAINT `fato_analise_setorial_ibfk_1` FOREIGN KEY (`fk_produto`) REFERENCES `dim_produto` (`pk_produto`),
  CONSTRAINT `fato_analise_setorial_ibfk_2` FOREIGN KEY (`fk_loja`) REFERENCES `dim_loja` (`pk_loja`)
) ENGINE=InnoDB AUTO_INCREMENT=57140 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
