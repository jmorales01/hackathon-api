DELIMITER $$

CREATE PROCEDURE eliminar_sala_por_curso(p_id_curso INT, p_id_sala INT)
BEGIN
    DECLARE msg VARCHAR(255);
    
        -- Eliminar la sala
        DELETE FROM salas WHERE id = p_id_sala AND id_curso = p_id_curso;

        -- Preparar el mensaje de retorno
        SET msg = CONCAT('Sala eliminada.');

    SELECT msg AS mensaje;

DELIMITER ;