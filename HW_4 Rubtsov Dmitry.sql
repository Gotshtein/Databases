-- 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
use geodata;
CREATE algorithm = merge VIEW adress 
	AS SELECT _cities.title city, _regions.title region, _countries.title country
	FROM _cities _cities
		LEFT JOIN (_countries _countries,  _regions _regions) ON
		(_cities.country_id = _countries.id AND _cities.region_id = _regions.id)
;

-- 2. Создать функцию, которая найдет менеджера по имени и фамилии.
-- Имена и Фамилии всех манеджеров
-- # dept_no, first_name, last_name
-- 'd001', 'Vishwani', 'Minakawa'
-- 'd002', 'Isamu', 'Legleitner'
-- 'd003', 'Karsten', 'Sigstam'
-- 'd004', 'Oscar', 'Ghazalie'
-- 'd005', 'Leon', 'DasSarma'
-- 'd006', 'Dung', 'Pesch'
-- 'd007', 'Hauke', 'Zhang'
-- 'd008', 'Hilary', 'Kambil'
-- 'd009', 'Yuchang', 'Weedman'

use employees;
DROP PROCEDURE IF EXISTS manager_name;
delimiter //
CREATE PROCEDURE manager_name (fname VARCHAR(14), lname VARCHAR(16))
BEGIN
SELECT dept_manager.emp_no, departments.dept_no, departments.dept_name
	FROM dept_manager 
		JOIN departments ON dept_manager.dept_no = departments.dept_no
	WHERE to_date > current_date() AND 
		emp_no =(SELECT emp_no FROM employees WHERE first_name = fname AND last_name = lname)
;
END//

-- 3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, 
-- занося запись об этом в таблицу salary.
use employees;
delimiter //
CREATE TRIGGER salary_new 
	BEFORE INSERT ON salaries FOR EACH ROW
begin
	set NEW.salary = 100;
end //