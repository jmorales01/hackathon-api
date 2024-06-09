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