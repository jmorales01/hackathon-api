 
-- Procedimiento para traer todos los datos de los cursos que le pertenecen a un profesor.
SELECT cursos.id AS id_curso, cursos.nombre AS nombre_curso, cursos.id_profesor, profesores.nombre AS nombre_profesor, profesores.email AS email_profesor
FROM cursos
JOIN profesores ON cursos.id_profesor = profesores.id
WHERE profesores.id = 1;


-- Procedimiento para eliminar todas las salas que están asignadas a un curso.

DROP PROCEDURE IF EXISTS eliminar_salas_por_curso_proc;

DELIMITER $$

CREATE PROCEDURE eliminar_salas_por_curso_proc(IN p_id_curso INT)
BEGIN
    DECLARE msg VARCHAR(255);

    -- Eliminar todas las salas del curso especificado
    DELETE FROM salas WHERE id_curso = p_id_curso;

    -- Preparar el mensaje de retorno
    SET msg = CONCAT('Salas eliminadas.');

    -- Retornar el mensaje
    SELECT msg AS mensaje;
END$$

DELIMITER ;

CALL eliminar_salas_por_curso_proc(1);

-- Procedimiento para eliminar 1 sala que pertenece a un curso.

DROP PROCEDURE IF EXISTS eliminar_sala_por_curso;

DELIMITER $$

CREATE PROCEDURE eliminar_sala_por_curso(p_id_curso INT, p_id_sala INT)
BEGIN
    DECLARE msg VARCHAR(255);
    
        -- Eliminar la sala
        DELETE FROM salas WHERE id = p_id_sala AND id_curso = p_id_curso;

        -- Preparar el mensaje de retorno
        SET msg = CONCAT('Sala eliminada.');

    SELECT msg AS mensaje;
END$$
DELIMITER ;

CALL eliminar_sala_por_curso(1, 1);


-- Procedimiento para unir al estudiante en una sala de 1 curso.

DROP PROCEDURE IF EXISTS unirse_a_sala;

DELIMITER $$

CREATE PROCEDURE unirse_a_sala(
    IN p_id_estudiante INT,
    IN p_id_curso INT,
    IN p_id_sala INT
)
BEGIN
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
            SET msg = 'Usted ya está inscrito en una del curso.';
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

CALL unirse_a_sala(1, 1, 1);

-- Procedimiento para eliminar al estudiante de 1 curso.

DROP PROCEDURE IF EXISTS eliminar_estudiante_de_sala;

DELIMITER $$

CREATE PROCEDURE eliminar_estudiante_de_sala(
    IN p_id_estudiante INT,
    IN p_id_curso INT,
    IN p_id_sala INT
)
BEGIN
    DECLARE msg VARCHAR(255);

    -- Eliminar al estudiante de la sala
    DELETE FROM participacion_salas 
    WHERE id_estudiante = p_id_estudiante AND id_sala = p_id_sala;

    -- Retornar el mensaje de éxito
    SET msg = CONCAT('Se ha retirado de la sala.');
    SELECT msg AS mensaje;
END$$

DELIMITER ;

CALL eliminar_estudiante_de_sala(1, 1, 1);

-- Procedimiento para crear una tarea

DROP PROCEDURE IF EXISTS crear_tarea;

DELIMITER //

CREATE PROCEDURE crear_tarea(
    IN _id_sala INT,
    IN _nombre VARCHAR(100),
    IN _descripcion TEXT,
    IN _asignado_a INT,
    IN _estado VARCHAR(10) -- Añadido el parámetro para el estado
)
BEGIN
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
END//

DELIMITER ;