
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