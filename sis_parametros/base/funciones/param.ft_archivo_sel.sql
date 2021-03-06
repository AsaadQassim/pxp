CREATE OR REPLACE FUNCTION "param"."ft_archivo_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Parametros Generales
 FUNCION: 		param.ft_archivo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'param.tarchivo'
 AUTOR: 		 (admin)
 FECHA:	        05-12-2016 15:04:48
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'param.ft_archivo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PM_ARCH_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	if(p_transaccion='PM_ARCH_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						arch.id_archivo,
						arch.estado_reg,
						arch.folder,
						arch.extension,
						arch.id_tabla,
						arch.nombre_archivo,
						arch.id_tipo_archivo,
						arch.fecha_reg,
						arch.usuario_ai,
						arch.id_usuario_reg,
						arch.id_usuario_ai,
						arch.id_usuario_mod,
						arch.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from param.tarchivo arch
						inner join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PM_ARCH_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARCH_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_archivo)
					    from param.tarchivo arch
					    inner join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PM_ARCOD_SEL'
 	#DESCRIPCION:	lista de registros
 	#AUTOR:		admin
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARCOD_SEL')then

		begin
			v_consulta:='select
						arch.id_archivo,
						arch.estado_reg,
						arch.folder,
						arch.extension,
						arch.id_tabla,
						arch.nombre_archivo,
						tipar.id_tipo_archivo,
						arch.fecha_reg,
						arch.usuario_ai,
						arch.id_usuario_reg,
						arch.id_usuario_ai,
						arch.id_usuario_mod,
						arch.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tipar.tabla,
						tipar.nombre,
						tipar.codigo
						from param.ttipo_archivo tipar
  left join param.tarchivo arch on arch.id_tipo_archivo = tipar.id_tipo_archivo and arch.id_tabla = '||v_parametros.id_tabla||'

  left join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
  left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
where
				         ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;
		end;
	/*********************************
 	#TRANSACCION:  'PM_ARCOD_CONT'
 	#DESCRIPCION:	conteo de registros
 	#AUTOR:		admin
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARCOD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(tipar.id_tipo_archivo)
					    from param.ttipo_archivo tipar
  left join param.tarchivo arch on arch.id_tipo_archivo = tipar.id_tipo_archivo and arch.id_tabla = '||v_parametros.id_tabla||'

  left join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
  left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
/*********************************
 	#TRANSACCION:  'PM_ARVER_SEL'
 	#DESCRIPCION:	conteo de registros
 	#AUTOR:		admin
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARVER_SEL')then

		begin


			--Sentencia de la consulta de conteo de registros
			v_consulta:='WITH RECURSIVE t(version,id_archivo_fk, id_archivo) AS (
										SELECT
											2 AS version,
											arch.id_archivo_fk,
											arch.id_archivo,
											arch.extension,
											arch.nombre_archivo,
											arch.id_tipo_archivo
										FROM param.tarchivo arch
										WHERE arch.id_archivo_fk = '||v_parametros.id_archivo||'

										UNION ALL
										SELECT
											version - 1,
											arch.id_archivo_fk,
											arch.id_archivo,
											arch.extension,
											arch.nombre_archivo,
											arch.id_tipo_archivo
										FROM param.tarchivo arch
											INNER JOIN t t ON t.id_archivo = arch.id_archivo_fk
									)
									SELECT
										arch.id_archivo,
										arch.estado_reg,
										arch.folder,
										arch.extension,
										arch.id_tabla,
										arch.nombre_archivo,
										arch.id_tipo_archivo,
										arch.fecha_reg,
										arch.usuario_ai,
										arch.id_usuario_reg,
										arch.id_usuario_ai,
										arch.id_usuario_mod,
										arch.fecha_mod,
										usu1.cuenta as usr_reg,
										usu2.cuenta as usr_mod,
										tipar.codigo,
										tipar.nombre,
										recursivo.version::varchar
									from t recursivo
										inner join param.tarchivo arch on arch.id_archivo = recursivo.id_archivo
										inner join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
										left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
									INNER JOIN param.ttipo_archivo tipar on tipar.id_tipo_archivo = arch.id_tipo_archivo
									WHERE ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
					
EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "param"."ft_archivo_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
