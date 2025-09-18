--q1
select e.employee_id, e.first_name, d.department_id, d.department_name
from employees e
cross join departments d;

--q2
select d.department_id, d.department_name,
       e.employee_id, e.first_name, e.last_name
from departments d
left join employees e on d.department_id = e.department_id
order by d.department_id;

--q3
select e.employee_id,
       e.first_name || ' ' || e.last_name as employee_name,
       m.first_name || ' ' || m.last_name as manager_name
from employees e
left join employees m on e.manager_id = m.employee_id
order by e.employee_id;

--q4
select e.employee_id, e.first_name, e.last_name
from employees e
where not exists (
  select 1 from employee_projects ep where ep.emp_id = e.employee_id
);

