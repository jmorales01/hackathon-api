
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
    cursos.id AS id_curso, 
    cursos.nombre AS nombre_curso, 
    cursos.descripcion, 
    cursos.imagen, 
    cursos.id_profesor, 
    profesores.nombre AS nombre_profesor, 
    profesores.email AS email_profesor
FROM 
    cursos
JOIN 
    profesores ON cursos.id_profesor = profesores.id
WHERE 
    profesores.id = 1;

