-- Procedimiento para insertar un mensaje en una sala

DELIMITER //

CREATE PROCEDURE insertar_mensaje(
    IN p_id_sala INT,
    IN p_mensaje TEXT,
    IN p_id_estudiante INT,
    OUT p_resultado VARCHAR(10)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_resultado = 'error';
    END;

    INSERT INTO chats (id_sala, mensaje, id_estudiante, timestamp)
    VALUES (p_id_sala, p_mensaje, p_id_estudiante, CURRENT_TIMESTAMP);

    SET p_resultado = 'ok';
END//

DELIMITER ;