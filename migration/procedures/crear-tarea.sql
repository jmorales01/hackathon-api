
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