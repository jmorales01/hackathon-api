-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: db
-- Tiempo de generación: 09-06-2024 a las 07:13:47
-- Versión del servidor: 8.0.27
-- Versión de PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `utp`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`%` PROCEDURE `asignar_estudiantes_a_salas_aleatorio` (IN `_id_curso` INT)   BEGIN
    DECLARE _id_estudiante INT;
    DECLARE _id_sala INT;
    DECLARE _max_participantes INT;
    DECLARE _num_participantes INT;
    DECLARE _done INT DEFAULT 0;

    -- Curso cursor para iterar sobre los estudiantes del curso
    DECLARE cur_estudiantes CURSOR FOR
        SELECT id_estudiante
        FROM inscripcion_cursos
        WHERE id_curso = _id_curso
        ORDER BY RAND(); -- Ordenar aleatoriamente los estudiantes

    -- Curso cursor para iterar sobre las salas del curso, ordenadas aleatoriamente
    DECLARE cur_salas CURSOR FOR
        SELECT id, max_participantes
        FROM salas
        WHERE id_curso = _id_curso
        ORDER BY RAND(); -- Ordenar aleatoriamente las salas

    -- Handlers para manejar el fin de los cursores
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = 1;

    -- Abrir cursor de estudiantes
    OPEN cur_estudiantes;

    -- Iterar sobre cada estudiante
    estudiante_loop:LOOP
        FETCH cur_estudiantes INTO _id_estudiante;
        IF _done THEN
            LEAVE estudiante_loop;
        END IF;

        -- Verificar si el estudiante ya está asignado a alguna sala del curso
        SELECT COUNT(*) INTO _num_participantes
        FROM participacion_salas ps
        JOIN salas s ON ps.id_sala = s.id
        WHERE s.id_curso = _id_curso AND ps.id_estudiante = _id_estudiante;

        IF _num_participantes > 0 THEN
            -- Si el estudiante ya está asignado, no hacer nada y continuar con el siguiente estudiante
            ITERATE estudiante_loop;
        END IF;

        -- Resetear el handler done para las salas
        SET _done = 0;

        -- Abrir cursor de salas
        OPEN cur_salas;

        sala_loop: LOOP
            FETCH cur_salas INTO _id_sala, _max_participantes;
            IF _done THEN
                LEAVE sala_loop;
            END IF;

            -- Contar los participantes actuales en la sala
            SELECT COUNT(*) INTO _num_participantes
            FROM participacion_salas
            WHERE id_sala = _id_sala;

            -- Si hay espacio en la sala, insertar al estudiante
            IF _num_participantes < _max_participantes THEN
                INSERT INTO participacion_salas (id_sala, id_estudiante)
                VALUES (_id_sala, _id_estudiante);
                LEAVE sala_loop; -- Salir del loop de salas
            END IF;
        END LOOP;

        -- Cerrar el cursor de salas
        CLOSE cur_salas;
    END LOOP;

    -- Cerrar el cursor de estudiantes
    CLOSE cur_estudiantes;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `crear_salas` (IN `curso_id` INT, IN `cantidad_salas` INT, IN `cantidad_alumnos_por_sala` INT)   BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= cantidad_salas DO
        INSERT INTO salas (id_curso, nombre, max_participantes)
        VALUES (curso_id, CONCAT('Sala ', i), cantidad_alumnos_por_sala);
        SET i = i + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `crear_tarea` (IN `_id_sala` INT, IN `_nombre` VARCHAR(100), IN `_descripcion` TEXT, IN `_asignado_a` INT, IN `_estado` VARCHAR(10))   BEGIN
    DECLARE _num_participantes INT;

    -- Verificar si el estudiante está en la sala
    SELECT COUNT(*) INTO _num_participantes
    FROM participacion_salas
    WHERE id_sala = _id_sala AND id_estudiante = _asignado_a;

    IF _num_participantes = 0 THEN
        -- El estudiante no está en la sala
        SELECT 'El estudiante no está en la sala' AS mensaje;
    ELSE
        -- Crear la tarea
        INSERT INTO tareas (id_sala, nombre, descripcion, asignado_a, estado)
        VALUES (_id_sala, _nombre, _descripcion, _asignado_a, _estado);

        -- Confirmar creación de la tarea
        SELECT 'Tarea creada' AS mensaje;
    END IF;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `eliminar_estudiante_de_sala` (IN `p_id_estudiante` INT, IN `p_id_curso` INT, IN `p_id_sala` INT)   BEGIN
    DECLARE msg VARCHAR(255);

    -- Eliminar al estudiante de la sala
    DELETE FROM participacion_salas 
    WHERE id_estudiante = p_id_estudiante AND id_sala = p_id_sala;

    -- Retornar el mensaje de éxito
    SET msg = CONCAT('Se ha retirado de la sala.');
    SELECT msg AS mensaje;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `eliminar_salas_por_curso_proc` (IN `p_id_curso` INT)   BEGIN
    DECLARE msg VARCHAR(255);

    -- Eliminar todas las salas del curso especificado
    DELETE FROM salas WHERE id_curso = p_id_curso;

    -- Preparar el mensaje de retorno
    SET msg = CONCAT('Salas eliminadas.');

    -- Retornar el mensaje
    SELECT msg AS mensaje;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `eliminar_sala_por_curso` (`p_id_curso` INT, `p_id_sala` INT)   BEGIN
    DECLARE msg VARCHAR(255);
    
        -- Eliminar la sala
        DELETE FROM salas WHERE id = p_id_sala AND id_curso = p_id_curso;

        -- Preparar el mensaje de retorno
        SET msg = CONCAT('Sala eliminada.');

    SELECT msg;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `unirse_a_sala` (IN `p_id_estudiante` INT, IN `p_id_curso` INT, IN `p_id_sala` INT)   BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE estudiante_existente INT;
    DECLARE capacidad_restante INT;

    -- Etiqueta de inicio para el control de flujo
    etiqueta: BEGIN

        -- Verificar si el estudiante ya está inscrito en otra sala del mismo curso
        SELECT COUNT(*) INTO estudiante_existente
        FROM participacion_salas ps
        JOIN salas s ON ps.id_sala = s.id
        WHERE ps.id_estudiante = p_id_estudiante AND s.id_curso = p_id_curso;

        IF estudiante_existente > 0 THEN
            SET msg = 'Usted ya está inscrito en una sala del curso.';
            LEAVE etiqueta;
        END IF;

        -- Verificar la capacidad de la sala
        SELECT (s.max_participantes - COUNT(ps.id_estudiante)) INTO capacidad_restante
        FROM salas s
        LEFT JOIN participacion_salas ps ON s.id = ps.id_sala
        WHERE s.id = p_id_sala
        GROUP BY s.max_participantes;

        IF capacidad_restante <= 0 THEN
            SET msg = 'La sala está llena y no puede aceptar más estudiantes.';
            LEAVE etiqueta;
        END IF;

        -- Insertar el estudiante en la sala
        INSERT INTO participacion_salas (id_sala, id_estudiante)
        VALUES (p_id_sala, p_id_estudiante);

        -- Retornar el mensaje de éxito
        SET msg = 'Se ha unido correctamente.';
    END etiqueta;

    -- Retornar el mensaje final
    SELECT msg AS mensaje;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `chats`
--

CREATE TABLE `chats` (
  `id` int NOT NULL,
  `id_sala` int NOT NULL,
  `mensaje` text NOT NULL,
  `id_estudiante` int NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `chats`
--

INSERT INTO `chats` (`id`, `id_sala`, `mensaje`, `id_estudiante`, `timestamp`) VALUES
(5, 3, 'Does anyone have the notes from the last class?', 5, '2024-06-08 21:57:17'),
(6, 3, 'I can share mine.', 6, '2024-06-08 21:57:17'),
(7, 4, 'Can someone explain the lab experiment?', 7, '2024-06-08 21:57:17'),
(8, 4, 'Sure, let\'s discuss.', 8, '2024-06-08 21:57:17'),
(9, 5, 'When is the next exam?', 9, '2024-06-08 21:57:17'),
(10, 5, 'It\'s scheduled for next week.', 10, '2024-06-08 21:57:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos`
--

CREATE TABLE `cursos` (
  `id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `id_profesor` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `cursos`
--

INSERT INTO `cursos` (`id`, `nombre`, `id_profesor`) VALUES
(1, 'Mathematics 101', 1),
(2, 'Physics 201', 2),
(3, 'Chemistry 301', 3),
(4, 'Biology 401', 4),
(5, 'History 501', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiantes`
--

CREATE TABLE `estudiantes` (
  `id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `estudiantes`
--

INSERT INTO `estudiantes` (`id`, `nombre`, `email`) VALUES
(1, 'Michael Wilson', 'michael.wilson@example.com'),
(2, 'Sarah Taylor', 'sarah.taylor@example.com'),
(3, 'David Moore', 'david.moore@example.com'),
(4, 'Laura Martinez', 'laura.martinez@example.com'),
(5, 'James Anderson', 'james.anderson@example.com'),
(6, 'Linda Thomas', 'linda.thomas@example.com'),
(7, 'Daniel Jackson', 'daniel.jackson@example.com'),
(8, 'Patricia White', 'patricia.white@example.com'),
(9, 'Christopher Harris', 'christopher.harris@example.com'),
(10, 'Barbara Martin', 'barbara.martin@example.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscripcion_cursos`
--

CREATE TABLE `inscripcion_cursos` (
  `id` int NOT NULL,
  `id_curso` int NOT NULL,
  `id_estudiante` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `inscripcion_cursos`
--

INSERT INTO `inscripcion_cursos` (`id`, `id_curso`, `id_estudiante`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(5, 3, 5),
(6, 3, 6),
(7, 4, 7),
(8, 5, 8),
(9, 5, 9),
(10, 5, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `participacion_salas`
--

CREATE TABLE `participacion_salas` (
  `id` int NOT NULL,
  `id_sala` int NOT NULL,
  `id_estudiante` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `participacion_salas`
--

INSERT INTO `participacion_salas` (`id`, `id_sala`, `id_estudiante`) VALUES
(5, 3, 5),
(6, 3, 6),
(7, 4, 7),
(8, 4, 8),
(12, 8, 9),
(13, 8, 10),
(11, 9, 8),
(15, 12, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesores`
--

CREATE TABLE `profesores` (
  `id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `profesores`
--

INSERT INTO `profesores` (`id`, `nombre`, `email`) VALUES
(1, 'John Smith', 'john.smith@example.com'),
(2, 'Jane Doe', 'jane.doe@example.com'),
(3, 'Alice Johnson', 'alice.johnson@example.com'),
(4, 'Robert Brown', 'robert.brown@example.com'),
(5, 'Emily Davis', 'emily.davis@example.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salas`
--

CREATE TABLE `salas` (
  `id` int NOT NULL,
  `id_curso` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `max_participantes` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `salas`
--

INSERT INTO `salas` (`id`, `id_curso`, `nombre`, `max_participantes`) VALUES
(3, 2, 'Physics 201 Group A', 5),
(4, 2, 'Physics 201 Group B', 5),
(5, 3, 'Chemistry 301 Group A', 5),
(6, 4, 'Biology 401 Group A', 5),
(7, 2, 'History 501 Group A', 5),
(8, 5, 'Sala 1', 2),
(9, 5, 'Sala 2', 2),
(12, 1, 'Sala 2', 5),
(13, 1, 'Sala 3', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas`
--

CREATE TABLE `tareas` (
  `id` int NOT NULL,
  `id_sala` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `asignado_a` int DEFAULT NULL,
  `estado` varchar(10) DEFAULT 'pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `tareas`
--

INSERT INTO `tareas` (`id`, `id_sala`, `nombre`, `descripcion`, `asignado_a`, `estado`) VALUES
(5, 3, '', 'Research on chemical reactions', 5, 'pendiente'),
(6, 3, '', 'Submit homework on time', 6, 'pendiente'),
(7, 4, '', 'Study for the final exam', 7, 'pendiente'),
(8, 4, '', 'Participate in group discussion', 8, 'pendiente'),
(10, 5, '', 'Create a presentation on ancient civilizations', 10, 'pendiente'),
(15, 8, 'Tarea 1', 'Descripción de la tarea', 9, 'pendiente');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_sala` (`id_sala`),
  ADD KEY `id_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_profesor` (`id_profesor`);

--
-- Indices de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `inscripcion_cursos`
--
ALTER TABLE `inscripcion_cursos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `inscripcion_cursos_unique` (`id_curso`,`id_estudiante`),
  ADD KEY `id_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `participacion_salas`
--
ALTER TABLE `participacion_salas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `participacion_salas_unique` (`id_sala`,`id_estudiante`),
  ADD KEY `id_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `profesores`
--
ALTER TABLE `profesores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `salas`
--
ALTER TABLE `salas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_sala` (`id_sala`),
  ADD KEY `asignado_a` (`asignado_a`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `chats`
--
ALTER TABLE `chats`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `cursos`
--
ALTER TABLE `cursos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `inscripcion_cursos`
--
ALTER TABLE `inscripcion_cursos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `participacion_salas`
--
ALTER TABLE `participacion_salas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `profesores`
--
ALTER TABLE `profesores`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `salas`
--
ALTER TABLE `salas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tareas`
--
ALTER TABLE `tareas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `chats`
--
ALTER TABLE `chats`
  ADD CONSTRAINT `chats_ibfk_1` FOREIGN KEY (`id_sala`) REFERENCES `salas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chats_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD CONSTRAINT `cursos_ibfk_1` FOREIGN KEY (`id_profesor`) REFERENCES `profesores` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `inscripcion_cursos`
--
ALTER TABLE `inscripcion_cursos`
  ADD CONSTRAINT `inscripcion_cursos_ibfk_1` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inscripcion_cursos_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `participacion_salas`
--
ALTER TABLE `participacion_salas`
  ADD CONSTRAINT `participacion_salas_ibfk_1` FOREIGN KEY (`id_sala`) REFERENCES `salas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `participacion_salas_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `salas`
--
ALTER TABLE `salas`
  ADD CONSTRAINT `salas_ibfk_1` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD CONSTRAINT `tareas_ibfk_1` FOREIGN KEY (`id_sala`) REFERENCES `salas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tareas_ibfk_2` FOREIGN KEY (`asignado_a`) REFERENCES `estudiantes` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
