
-- Procedimiento para traer todos los datos de las salas que están asignadas a cada curso.
SELECT 
    s.id AS sala_id,
    s.nombre AS sala_nombre,
    s.max_participantes,
    COUNT(ps.id_estudiante) AS numero_participantes
FROM salas s
LEFT JOIN participacion_salas ps ON s.id = ps.id_sala
WHERE s.id_curso = 1
GROUP BY s.id, s.nombre, s.max_participantes;


-- Procedimiento para traer todos los datos de los cursos que le pertenecen a un profesor.

SELECT 
    c.id AS id_curso, 
    c.nombre AS nombre_curso, 
    c.descripcion, 
    c.imagen, 
    c.id_profesor, 
    p.nombre AS nombre_profesor, 
    p.email AS email_profesor
FROM cursos as c
JOIN profesores as p ON c.id_profesor = p.id
WHERE p.id = 1;