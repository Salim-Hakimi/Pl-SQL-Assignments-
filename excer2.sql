DECLARE
    CURSOR c_emp IS
        SELECT e.first_name || ' ' || e.last_name AS emp_name,
               e.salary,
               d.department_name
        FROM employees e
        JOIN departments d USING (department_id)
        WHERE salary > (
                SELECT AVG(salary)
                FROM employees
                WHERE department_id = e.department_id
        );
        
    v_name  VARCHAR2(100);
    v_sal   NUMBER;
    v_dep   VARCHAR2(100);
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_name, v_sal, v_dep;
        EXIT WHEN c_emp%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_sal || ' | ' || v_dep);
    END LOOP;
    CLOSE c_emp;
END;
/



DECLARE
    CURSOR c_it IS
        SELECT employee_id, first_name, salary
        FROM employees
        WHERE department_id = 60;  -- IT Dept

    v_id    NUMBER;
    v_name  VARCHAR2(50);
    v_sal   NUMBER;
BEGIN
    OPEN c_it;
    LOOP
        FETCH c_it INTO v_id, v_name, v_sal;
        EXIT WHEN c_it%NOTFOUND;

        UPDATE employees
           SET salary = salary * 1.10
         WHERE employee_id = v_id;

        DBMS_OUTPUT.PUT_LINE(v_name || ' new salary = ' || (v_sal * 1.10));
    END LOOP;
    CLOSE c_it;
END;
/



DECLARE
    CURSOR c_cust IS
        SELECT c.customer_id, c.customer_name,
               COUNT(o.order_id) AS total_orders,
               SUM(o.total_amount) AS total_amt
        FROM customers c
        JOIN orders o USING (customer_id)
        WHERE o.order_date >= SYSDATE - 30
        GROUP BY c.customer_id, c.customer_name;

    v_id     NUMBER;
    v_name   VARCHAR2(100);
    v_count  NUMBER;
    v_amt    NUMBER;
BEGIN
    OPEN c_cust;
    LOOP
        FETCH c_cust INTO v_id, v_name, v_count, v_amt;
        EXIT WHEN c_cust%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || ' | Orders=' || v_count ||
                             ' | Total=' || v_amt);
    END LOOP;
    CLOSE c_cust;
END;
/



DECLARE
    CURSOR c_inv IS
        SELECT i.invoice_id, c.customer_name, i.due_date, i.amount
        FROM invoices i
        JOIN customers c USING (customer_id)
        WHERE i.status = 'Pending'
          AND i.due_date < SYSDATE - 60;

    v_id    NUMBER;
    v_name  VARCHAR2(100);
    v_due   DATE;
    v_amt   NUMBER;
BEGIN
    OPEN c_inv;
    LOOP
        FETCH c_inv INTO v_id, v_name, v_due, v_amt;
        EXIT WHEN c_inv%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_name || ' | Invoice ' || v_id || 
            ' | Due: ' || v_due || 
            ' | Amount: ' || v_amt);
    END LOOP;
    CLOSE c_inv;
END;
/



DECLARE
    CURSOR c_top IS
        SELECT *
        FROM (
            SELECT d.department_name,
                   e.first_name || ' ' || e.last_name AS emp_name,
                   e.salary,
                   ROW_NUMBER() OVER 
                       (PARTITION BY d.department_id ORDER BY salary DESC) AS rn
            FROM employees e
            JOIN departments d USING (department_id)
        )
        WHERE rn <= 3;

    v_dep   VARCHAR2(100);
    v_name  VARCHAR2(100);
    v_sal   NUMBER;
BEGIN
    OPEN c_top;
    LOOP
        FETCH c_top INTO v_dep, v_name, v_sal;
        EXIT WHEN c_top%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_dep || ' | ' || v_name || ' | ' || v_sal);
    END LOOP;
    CLOSE c_top;
END;
/



DECLARE
    CURSOR c_prod IS
        SELECT product_name, category, stock
        FROM products
        WHERE stock < 10;

    v_name  VARCHAR2(100);
    v_cat   VARCHAR2(50);
    v_stock NUMBER;
BEGIN
    OPEN c_prod;
    LOOP
        FETCH c_prod INTO v_name, v_cat, v_stock;
        EXIT WHEN c_prod%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_cat || ' | Stock=' || v_stock);
    END LOOP;
    CLOSE c_prod;
END;
/


DECLARE
    v_avg NUMBER;

    CURSOR c_stu IS
        SELECT student_name, subject, marks
        FROM students
        WHERE marks < v_avg;

    v_name  VARCHAR2(100);
    v_sub   VARCHAR2(50);
    v_marks NUMBER;
BEGIN
    SELECT AVG(marks) INTO v_avg FROM students;

    OPEN c_stu;
    LOOP
        FETCH c_stu INTO v_name, v_sub, v_marks;
        EXIT WHEN c_stu%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_sub || ' | ' || v_marks);
    END LOOP;
    CLOSE c_stu;
END;
/


DECLARE
    CURSOR c_ann IS
        SELECT first_name || ' ' || last_name,
               hire_date,
               TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12) AS years_done
        FROM employees
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12) IN (5,10,15)
          AND TO_CHAR(hire_date,'MM') = TO_CHAR(SYSDATE,'MM');

    v_name VARCHAR2(100);
    v_date DATE;
    v_year NUMBER;
BEGIN
    OPEN c_ann;
    LOOP
        FETCH c_ann INTO v_name, v_date, v_year;
        EXIT WHEN c_ann%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_date || 
                             ' | ' || v_year || ' years');
    END LOOP;
    CLOSE c_ann;
END;
/



DECLARE
    CURSOR c_sales IS
        SELECT s.salesperson_id,
               sp.name,
               SUM(s.amount) AS total_sales
        FROM sales s
        JOIN salespersons sp ON s.salesperson_id = sp.id
        WHERE TO_CHAR(s.sale_date,'MMYYYY') = TO_CHAR(SYSDATE,'MMYYYY')
        GROUP BY s.salesperson_id, sp.name;

    v_id   NUMBER;
    v_name VARCHAR2(100);
    v_tot  NUMBER;
BEGIN
    OPEN c_sales;
    LOOP
        FETCH c_sales INTO v_id, v_name, v_tot;
        EXIT WHEN c_sales%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || 
            ' | Sales=' || v_tot || 
            ' | Commission=' || (v_tot * 0.05));
    END LOOP;
    CLOSE c_sales;
END;
/



DECLARE
    CURSOR c_acc IS
        SELECT user_id, username
        FROM user_accounts
        WHERE last_login < ADD_MONTHS(SYSDATE, -12)
          AND status = 'Active';

    v_id   NUMBER;
    v_user VARCHAR2(50);
BEGIN
    OPEN c_acc;
    LOOP
        FETCH c_acc INTO v_id, v_user;
        EXIT WHEN c_acc%NOTFOUND;

        UPDATE user_accounts
        SET status = 'Inactive'
        WHERE user_id = v_id;

        DBMS_OUTPUT.PUT_LINE(v_user || ' marked inactive');
    END LOOP;
    CLOSE c_acc;
END;
/



DECLARE
    CURSOR c_dep IS
        SELECT d.department_name,
               SUM(e.salary) AS total_salary
        FROM employees e
        JOIN departments d USING (department_id)
        GROUP BY d.department_name;

    v_dep  VARCHAR2(100);
    v_tot  NUMBER;
BEGIN
    OPEN c_dep;
    LOOP
        FETCH c_dep INTO v_dep, v_tot;
        EXIT WHEN c_dep%NOTFOUND;

        IF v_tot > 50000 THEN
            DBMS_OUTPUT.PUT_LINE('WARNING: ' || v_dep ||
                                 ' exceeds budget. Total=' || v_tot);
        END IF;
    END LOOP;
    CLOSE c_dep;
END;
/



DECLARE
    CURSOR c_prom IS
        SELECT e.first_name || ' ' || e.last_name AS emp_name,
               e.salary,
               (
                   SELECT AVG(salary)
                   FROM employees
                   WHERE department_id = e.department_id
               ) AS dep_avg,
               TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12) AS years_done
        FROM employees e;

    v_name VARCHAR2(100);
    v_sal  NUMBER;
    v_avg  NUMBER;
    v_yrs  NUMBER;
BEGIN
    OPEN c_prom;
    LOOP
        FETCH c_prom INTO v_name, v_sal, v_avg, v_yrs;
        EXIT WHEN c_prom%NOTFOUND;

        IF v_yrs > 5 AND v_sal < v_avg THEN
            DBMS_OUTPUT.PUT_LINE(v_name || ' | Eligible for Promotion');
        END IF;
    END LOOP;
    CLOSE c_prom;
END;
/



DECLARE
    CURSOR c_orders (p_cust NUMBER) IS
        SELECT order_id, total_amount
        FROM orders
        WHERE customer_id = p_cust;

    v_oid  NUMBER;
    v_amt  NUMBER;
BEGIN
    OPEN c_orders(&customer_id); -- parameter

    LOOP
        FETCH c_orders INTO v_oid, v_amt;
        EXIT WHEN c_orders%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Order ' || v_oid ||
                             ' | Points=' || (v_amt/10));
    END LOOP;

    CLOSE c_orders;
END;
/



DECLARE
    CURSOR c_pen IS
        SELECT invoice_id, amount, due_date
        FROM invoices
        WHERE status = 'Pending'
          AND due_date < SYSDATE;

    v_id   NUMBER;
    v_amt  NUMBER;
    v_due  DATE;
    v_mon  NUMBER;
BEGIN
    OPEN c_pen;
    LOOP
        FETCH c_pen INTO v_id, v_amt, v_due;
        EXIT WHEN c_pen%NOTFOUND;

        v_mon := TRUNC(MONTHS_BETWEEN(SYSDATE, v_due));

        DBMS_OUTPUT.PUT_LINE('Invoice ' || v_id ||
                             ' | Payable=' || (v_amt + v_amt * 0.02 * v_mon));
    END LOOP;
    CLOSE c_pen;
END;
/



DECLARE
    CURSOR c_prod IS
        SELECT product_name, stock
        FROM products
        WHERE category = 'Electronics';

    v_name  VARCHAR2(100);
    v_stock NUMBER;
    v_stat  VARCHAR2(20);
BEGIN
    OPEN c_prod;
    LOOP
        FETCH c_prod INTO v_name, v_stock;
        EXIT WHEN c_prod%NOTFOUND;

        IF v_stock < 10 THEN
            v_stat := 'Critical';
        ELSIF v_stock < 50 THEN
            v_stat := 'Low';
        ELSE
            v_stat := 'OK';
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_stat);
    END LOOP;
    CLOSE c_prod;
END;
/

DECLARE
    CURSOR c_bonus IS
        SELECT first_name || ' ' || last_name AS emp_name, salary
        FROM employees;

    v_name VARCHAR2(100);
    v_sal  NUMBER;
    v_bonus NUMBER;
BEGIN
    OPEN c_bonus;
    LOOP
        FETCH c_bonus INTO v_name, v_sal;
        EXIT WHEN c_bonus%NOTFOUND;

        IF v_sal < 1000 THEN
            v_bonus := v_sal * 0.15;
        ELSIF v_sal <= 2000 THEN
            v_bonus := v_sal * 0.10;
        ELSE
            v_bonus := v_sal * 0.05;
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_name || ' | Salary=' || v_sal ||
                             ' | Bonus=' || v_bonus);
    END LOOP;
    CLOSE c_bonus;
END;
/



DECLARE
    CURSOR c_high IS
        SELECT c.customer_name,
               COUNT(o.order_id) AS total_orders,
               SUM(o.total_amount) AS total_amt
        FROM customers c
        JOIN orders o USING (customer_id)
        GROUP BY c.customer_name
        HAVING SUM(o.total_amount) > 10000;

    v_name  VARCHAR2(100);
    v_count NUMBER;
    v_amt   NUMBER;
BEGIN
    OPEN c_high;
    LOOP
        FETCH c_high INTO v_name, v_count, v_amt;
        EXIT WHEN c_high%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || ' | Orders=' || v_count ||
                             ' | Total=' || v_amt);
    END LOOP;
    CLOSE c_high;
END;
/
