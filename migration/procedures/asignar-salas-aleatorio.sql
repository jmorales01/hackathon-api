
DROP PROCEDURE IF EXISTS asignar_estudiantes_a_salas_aleatorio;

DELIMITER //

CREATE PROCEDURE asignar_estudiantes_a_salas_aleatorio(
    IN _id_curso INT
)
BEGIN
    DECLARE _id_estudiante INT;
    DECLARE _id_sala INT;
    DECLARE _max_participantes INT;
    DECLARE _num_participantes INT;
    DECLARE _done INT DEFAULT 0;

    -- Curso cursor para iterar sobre los estudiantes del curso
    DECLARE cur_estudiantes CURSOR FOR
        SELECT id_estudiante
        FROM inscripcion_cursos
        WHERE id_curso = _id_curso
        ORDER BY RAND(); -- Ordenar aleatoriamente los estudiantes

    -- Curso cursor para iterar sobre las salas del curso, ordenadas aleatoriamente
    DECLARE cur_salas CURSOR FOR
        SELECT id, max_participantes
        FROM salas
        WHERE id_curso = _id_curso
        ORDER BY RAND(); -- Ordenar aleatoriamente las salas

    -- Handlers para manejar el fin de los cursores
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = 1;

    -- Abrir cursor de estudiantes
    OPEN cur_estudiantes;

    -- Iterar sobre cada estudiante
    estudiante_loop: LOOP
        FETCH cur_estudiantes INTO _id_estudiante;
        IF _done THEN
            LEAVE estudiante_loop;
        END IF;

        -- Verificar si el estudiante ya está asignado a alguna sala del curso
        SELECT COUNT(*) INTO _num_participantes
        FROM participacion_salas ps
        JOIN salas s ON ps.id_sala = s.id
        WHERE s.id_curso = _id_curso AND ps.id_estudiante = _id_estudiante;

        IF _num_participantes > 0 THEN
            -- Si el estudiante ya está asignado, no hacer nada y continuar con el siguiente estudiante
            ITERATE estudiante_loop;
        END IF;

        -- Resetear el handler done para las salas
        SET _done = 0;

        -- Abrir cursor de salas
        OPEN cur_salas;

        sala_loop: LOOP
            FETCH cur_salas INTO _id_sala, _max_participantes;
            IF _done THEN
                LEAVE sala_loop;
            END IF;

            -- Contar los participantes actuales en la sala
            SELECT COUNT(*) INTO _num_participantes
            FROM participacion_salas
            WHERE id_sala = _id_sala;

            -- Si hay espacio en la sala, insertar al estudiante
            IF _num_participantes < _max_participantes THEN
                INSERT INTO participacion_salas (id_sala, id_estudiante)
                VALUES (_id_sala, _id_estudiante);
                LEAVE sala_loop; -- Salir del loop de salas
            END IF;
        END LOOP;

        -- Cerrar el cursor de salas
        CLOSE cur_salas;
    END LOOP;

    -- Cerrar el cursor de estudiantes
    CLOSE cur_estudiantes;
END//

DELIMITER ;