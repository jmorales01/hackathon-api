 
-- Eliminar al estudiante de la sala
DELETE FROM participacion_salas 
WHERE id_estudiante = p_id_estudiante AND id_sala = p_id_sala;



-- Eliminar todas las salas del curso especificado
DELETE FROM salas WHERE id_curso = p_id_curso;


-- Procedimiento para eliminar 1 sala que pertenece a un curso.
DELETE FROM salas WHERE id = p_id_sala AND id_curso = p_id_curso;


-- Consultar los estudiantes de una sala
SELECT 
    e.id,
    e.nombre,
    e.email
FROM participacion_salas as p
INNER JOIN estudiantes as e ON p.id_estudiante = e.id
WHERE p.id_sala = 8;

