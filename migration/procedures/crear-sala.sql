DROP PROCEDURE IF EXISTS crear_salas;

DELIMITER //

CREATE PROCEDURE crear_salas(
    IN curso_id INT,
    IN cantidad_salas INT,
    IN cantidad_alumnos_por_sala INT
)
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= cantidad_salas DO
        INSERT INTO salas (id_curso, nombre, max_participantes)
        VALUES (curso_id, CONCAT('Sala ', i), cantidad_alumnos_por_sala);
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;