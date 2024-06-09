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