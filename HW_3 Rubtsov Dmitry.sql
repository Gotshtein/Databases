-- База данных «Страны и города мира»:
-- 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
SELECT _cities.title city, _regions.title region, _countries.title country
FROM geodata._cities _cities
LEFT JOIN (geodata._countries _countries,  geodata._regions _regions) ON
(_cities.country_id = _countries.id AND _cities.region_id = _regions.id)
;

-- 2. Выбрать все города из Московской области.
SELECT _cities.title city
FROM geodata._cities _cities
JOIN geodata._regions _regions ON _cities.region_id = _regions.id
WHERE _regions.id = 1053480
;

SELECT _cities.title city
FROM geodata._cities _cities
JOIN geodata._regions _regions ON _cities.region_id = _regions.id
WHERE _regions.title = 'Московская область'
;

-- База данных «Сотрудники»:

-- Ошибка в скрипте employees.sql  при запуске в MySQL 5.7 
-- ERROR 1193 (HY000) at line 38: Unknown system variable 'storage_engine'
-- storage_engine нужно заменить на default_storage_engine
-- https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_default_storage_engine

-- 1. Выбрать среднюю зарплату по отделам.
SELECT departments.dept_no, 
	departments.dept_name, 
	AVG(salaries.salary) 'Средняя зарплата по отделам'
FROM employees.employees employees
LEFT JOIN (employees.salaries salaries, employees.dept_emp dept_emp, employees.departments departments) ON
	(employees.emp_no = salaries.emp_no AND
	employees.emp_no = dept_emp.emp_no AND
	dept_emp.dept_no = departments.dept_no
)
WHERE (salaries.to_date > now() AND dept_emp.to_date > now())
GROUP BY dept_no
ORDER BY dept_no
;
-- 2. Выбрать максимальную зарплату у сотрудника.
SELECT MAX(salaries.salary) 'Максимальная зарплата'
FROM employees.salaries salaries
;
-- 3. Удалить одного сотрудника, у которого максимальная зарплата.
DELETE FROM employees.employees WHERE emp_no = (
SELECT salaries.emp_no FROM employees.salaries salaries 
WHERE salary = (SELECT MAX(salaries.salary) FROM salaries)
)
;
-- 4. Посчитать количество сотрудников во всех отделах.
SELECT dept_emp.dept_no, COUNT(1) 'Количество сотрудников по отделам' FROM employees.dept_emp dept_emp 
WHERE dept_emp.to_date > now() 
GROUP BY dept_emp.dept_no ORDER BY dept_emp.dept_no
;
-- 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
SELECT departments.dept_no, 
	departments.dept_name, 
	COUNT(1) 'Количество сотрудников по отделам', 
	SUM(salaries.salary) 'Сумма заплат'
FROM employees.employees employees
LEFT JOIN (employees.salaries salaries, employees.dept_emp dept_emp, employees.departments departments) ON
	(employees.emp_no = salaries.emp_no AND
	employees.emp_no = dept_emp.emp_no AND
	dept_emp.dept_no = departments.dept_no
)
WHERE (salaries.to_date > now() AND dept_emp.to_date > now())
GROUP BY dept_no
ORDER BY dept_no
;