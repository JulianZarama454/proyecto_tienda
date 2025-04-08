-- By Gaboh - 20250311
-- Base de datos: `the_vibeX`

CREATE DATABASE IF NOT EXISTS `the_vibeX` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE the_vibeX;

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- --------------------
-- TABLAS PARAMÉTRICAS
-- --------------------

-- Proveedores
CREATE TABLE IF NOT EXISTS `proveedores` (
  `id_proveedor` TINYINT NOT NULL AUTO_INCREMENT,
  `nombre_proveedor` VARCHAR(20) COLLATE utf8_unicode_ci NOT NULL,
  `telefono` VARCHAR(20) COLLATE utf8_unicode_ci NOT NULL,
  `email` VARCHAR(150) COLLATE utf8_unicode_ci NOT NULL,
  `direccion` VARCHAR(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Categorías
CREATE TABLE IF NOT EXISTS `categoria` (
  `id_categoria` TINYINT NOT NULL AUTO_INCREMENT,
  `nombre_categoria` VARCHAR(20) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Usuarios
CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` TINYINT NOT NULL AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(15) COLLATE utf8_unicode_ci NOT NULL,
  `email` VARCHAR(15) COLLATE utf8_unicode_ci NOT NULL,
  `contraseña` VARCHAR(15) COLLATE utf8_unicode_ci NOT NULL,
  `direccion` VARCHAR(100) COLLATE utf8_unicode_ci NOT NULL,
  `telefono` VARCHAR(20) COLLATE utf8_unicode_ci NOT NULL,
  `tipo_usuario` ENUM('usuario', 'admin'),
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Productos
CREATE TABLE IF NOT EXISTS `productos` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `Descripccion` VARCHAR(30) COLLATE utf8_unicode_ci NOT NULL,
  `Precio` DECIMAL(10,2) NOT NULL,
  `nombre_producto` VARCHAR(30) COLLATE utf8_unicode_ci NOT NULL,
  `id_categoria_producto` TINYINT NOT NULL,
  `id_proveedor_producto` TINYINT NOT NULL,
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `productos`
  ADD KEY (`id_categoria_producto`),
  ADD CONSTRAINT `fk_id_categoria_producto` FOREIGN KEY (`id_categoria_producto`) REFERENCES `categoria` (`id_categoria`)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD KEY (`id_proveedor_producto`),
  ADD CONSTRAINT `fk_id_proveedor_producto` FOREIGN KEY (`id_proveedor_producto`) REFERENCES `proveedores` (`id_proveedor`)
    ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Carrito de compras
CREATE TABLE IF NOT EXISTS `carrito_compras` (
  `id_carrito` INT NOT NULL AUTO_INCREMENT,
  `id_usuario_carrito_compras` TINYINT NOT NULL,
  PRIMARY KEY (`id_carrito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `carrito_compras`
  ADD KEY (`id_usuario_carrito_compras`),
  ADD CONSTRAINT `fk_id_usuario_carrito_compras` FOREIGN KEY (`id_usuario_carrito_compras`) REFERENCES `usuario` (`id_usuario`)
    ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Órdenes
CREATE TABLE IF NOT EXISTS `ordenes` (
  `id_ordenes` TINYINT NOT NULL AUTO_INCREMENT,
  `id_usuario_ordenes` TINYINT NOT NULL,
  `fecha` DATETIME,
  `Estado` ENUM('pendiente', 'enviado', 'entregado', 'cancelado'),
  PRIMARY KEY (`id_ordenes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `ordenes`
  ADD KEY (`id_usuario_ordenes`),
  ADD CONSTRAINT `fk_id_usuario_ordenes` FOREIGN KEY (`id_usuario_ordenes`) REFERENCES `usuario` (`id_usuario`)
    ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Detalles de órdenes
CREATE TABLE IF NOT EXISTS `detalles_ordenes` (
  `id_detalles_ordenes` TINYINT NOT NULL AUTO_INCREMENT,
  `id_producto_detalles_ordenes` INT NOT NULL,
  `detalles` TEXT COLLATE utf8_unicode_ci NOT NULL,
  `cantidad` INT NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_detalles_ordenes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `detalles_ordenes`
  ADD KEY (`id_producto_detalles_ordenes`),
  ADD CONSTRAINT `fk_id_producto_detalles_ordenes` FOREIGN KEY (`id_producto_detalles_ordenes`) REFERENCES `productos` (`id_producto`)
    ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Envíos
CREATE TABLE IF NOT EXISTS `envios` (
  `id_envio` TINYINT NOT NULL AUTO_INCREMENT,
  `id_orden_envios` TINYINT NOT NULL UNIQUE,
  `Estado` ENUM('pendiente', 'encamino', 'entregado') NOT NULL,
  `fecha_envio` DATETIME NOT NULL,
  `fecha_entrega` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id_envio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `envios`
  ADD KEY (`id_orden_envios`),
  ADD CONSTRAINT `fk_id_orden_envios` FOREIGN KEY (`id_orden_envios`) REFERENCES `ordenes` (`id_ordenes`)
    ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Devoluciones y reembolsos
CREATE TABLE IF NOT EXISTS `devoluciones_y_reembolsos` (
  `id_devoluciones_y_reembolsos` INT NOT NULL AUTO_INCREMENT,
  `id_usuario_devoluciones_y_reembolsos` TINYINT NOT NULL,
  `id_orden_devoluciones_y_reembolsos` TINYINT NOT NULL UNIQUE,
  `Estado` ENUM('pendiente', 'aprueba', 'rechazado') NOT NULL,
  `fecha_solicitud` DATETIME,
  PRIMARY KEY (`id_devoluciones_y_reembolsos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `devoluciones_y_reembolsos`
  ADD KEY (`id_usuario_devoluciones_y_reembolsos`),
  ADD CONSTRAINT `fk_id_usuario_devoluciones_y_reembolsos` FOREIGN KEY (`id_usuario_devoluciones_y_reembolsos`) REFERENCES `usuario` (`id_usuario`)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD KEY (`id_orden_devoluciones_y_reembolsos`),
  ADD CONSTRAINT `fk_id_orden_devoluciones_y_reembolsos` FOREIGN KEY (`id_orden_devoluciones_y_reembolsos`) REFERENCES `ordenes` (`id_ordenes`)
    ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Notificaciones
CREATE TABLE IF NOT EXISTS `notificaciones` (
  `id_notificaciones` INT NOT NULL AUTO_INCREMENT,
  `id_usuario_notificaciones` TINYINT NOT NULL,
  `mensaje` TEXT COLLATE utf8_unicode_ci NOT NULL,
  `fecha` DATETIME,
  `estado` ENUM('no leido', 'leido'),
  PRIMARY KEY (`id_notificaciones`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
