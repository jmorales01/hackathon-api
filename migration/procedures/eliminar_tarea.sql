-- Procedimiento para eliminar una tarea de 1 curso

DELIMITER $$

CREATE PROCEDURE eliminar_tarea(
    IN p_id_tarea INT
)
BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE tarea_existe INT;
-- Etiqueta de inicio para el control de flujo
    etiqueta: BEGIN
        -- Verificar si la tarea existe
        SELECT COUNT(*) INTO tarea_existe
        FROM tareas
        WHERE id = p_id_tarea;

        IF tarea_existe = 0 THEN
            SET msg = CONCAT('La tarea no existe.');
            SELECT msg AS mensaje;
            LEAVE etiqueta;
        END IF;

        -- Eliminar la tarea
        DELETE FROM tareas
        WHERE id = p_id_tarea;

        -- Retornar el mensaje de éxito
        SET msg = CONCAT('La tarea ha sido eliminada.');
        SELECT msg AS mensaje;
    END etiqueta;
END$$