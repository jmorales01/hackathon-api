alter table cursos
	add column descripcion varchar(255) after nombre,
	add column img varchar(255) after id_profesor;