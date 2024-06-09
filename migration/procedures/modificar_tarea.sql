DELIMITER $$

CREATE PROCEDURE modificar_tarea(
    IN p_id_tarea INT,
    IN p_nombre VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_asignado_a INT,
    IN p_estado VARCHAR(10)
)
BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE sala_id INT;
    DECLARE estudiante_pertenece_sala INT;

	-- Etiqueta de inicio para el control de flujo
    etiqueta: BEGIN

        -- Verificar si la tarea existe y obtener el id de la sala
        SELECT id_sala INTO sala_id
        FROM tareas
        WHERE id = p_id_tarea;

        IF sala_id IS NULL THEN
            SET msg = CONCAT('La tarea no existe.');
            SELECT msg AS mensaje;
            LEAVE etiqueta;
        END IF;

        -- Verificar si el estudiante pertenece a la sala
        SELECT COUNT(*) INTO estudiante_pertenece_sala
        FROM participacion_salas
        WHERE id_estudiante = p_asignado_a AND id_sala = sala_id;

        IF estudiante_pertenece_sala = 0 THEN
            SET msg = 'El estudiante no pertenece a la sala.';
            SELECT msg AS mensaje;
            LEAVE etiqueta;
        END IF;

        -- Actualizar la tarea
        UPDATE tareas
        SET nombre = p_nombre,
            descripcion = p_descripcion,
            asignado_a = p_asignado_a,
            estado = p_estado
        WHERE id = p_id_tarea;

        -- Retornar el mensaje de éxito
        SET msg = 'Tarea actualizada.';
        -- Retornar el mensaje final
        SELECT msg AS mensaje;
    END etiqueta;
END$$

DELIMITER ;