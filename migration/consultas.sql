 
-- Eliminar al estudiante de la sala
DELETE FROM participacion_salas 
WHERE id_estudiante = p_id_estudiante AND id_sala = p_id_sala;



-- Eliminar todas las salas del curso especificado
DELETE FROM salas WHERE id_curso = p_id_curso;


-- Procedimiento para eliminar 1 sala que pertenece a un curso.
DELETE FROM salas WHERE id = p_id_sala AND id_curso = p_id_curso;


-- Consultar los estudiantes de una sala
SELECT 
    estudiantes.id,
    estudiantes.nombre,
    estudiantes.email
FROM 
    participacion_salas
INNER JOIN 
    estudiantes ON participacion_salas.id_estudiante = estudiantes.id
WHERE 
    participacion_salas.id_sala = 8;


-- Consulta para mostrar todos los mensajes de una sala

SELECT c.id, c.id_sala, c.mensaje, c.timestamp, e.id AS id_estudiante, e.nombre AS nombre_estudiante, e.email AS email_estudiante
FROM chats c
INNER JOIN estudiantes e ON c.id_estudiante = e.id
WHERE c.id_sala = 1;

