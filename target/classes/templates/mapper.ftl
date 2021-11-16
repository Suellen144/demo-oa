<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${classPackage}">
	
	<resultMap id="${rmId}" type="${rmType}">
		<id property="id" column="id" />
		<#list fieldList as field>
			<#list field?keys as key>
			<#if key != "id">
		<result property="${field[key]}" column="${key}" />
			</#if>
			</#list>
		</#list>
	</resultMap>
	
	<select id="findAll" resultMap="${rmId}">
		SELECT * FROM ${tableName}
	</select>
	
	<select id="findById" resultMap="${rmId}">
		SELECT * FROM ${tableName} WHERE ID = ${r'#{id}'}
	</select> 
	
	<update id="update">
		UPDATE ${tableName} 
			SET
			<#list fieldList as field>
				<#list field?keys as key>
				<#if key != "id">
				<#if field_has_next>
			  	${key?upper_case}=${r'#{'}${field[key]}},
			  	</#if>
				<#if !field_has_next>
			  	${key?upper_case}=${r'#{'}${field[key]}}
			  	</#if>
				</#if>
				</#list>
			</#list>
		WHERE ID = ${r'#{id}'}
	</update>
	
	<insert id="save" useGeneratedKeys="true" keyProperty="id">
		INSERT INTO ${tableName}(
			<#list fieldList as field>
				<#list field?keys as key>
				<#if key != "id">
				<#if field_has_next>
			  	${key?upper_case},
			  	</#if>
				<#if !field_has_next>
			  	${key?upper_case}
			  	</#if>
				</#if>
				</#list>
			</#list>
			) 
			VALUES (
			<#list fieldList as field>
				<#list field?keys as key>
				<#if key != "id">
				<#if field_has_next>
			  	${r'#{'}${field[key]}},
			  	</#if>
				<#if !field_has_next>
			  	${r'#{'}${field[key]}}
			  	</#if>
				</#if>
				</#list>
			</#list>
			)
	</insert>
	
	<delete id="deleteById">
		DELETE FROM ${tableName} WHERE ID = ${r'#{id}'}
	</delete>
	
</mapper>