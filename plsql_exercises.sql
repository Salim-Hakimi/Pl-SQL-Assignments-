-- PL/SQL Questions and Answers File

--------------------------------------------------------------------------------
-- 1. Salary Adjustment Policy
--------------------------------------------------------------------------------
-- Question:
-- HR wants salary increase:
-- <30000 → +15%
-- 30000–50000 → +10%
-- else → +5%

DECLARE
    v_emp_id     NUMBER := 101;
    v_salary     NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM employees
    WHERE emp_id = v_emp_id;

    IF v_salary < 30000 THEN
        v_salary := v_salary * 1.15;
    ELSIF v_salary BETWEEN 30000 AND 50000 THEN
        v_salary := v_salary * 1.10;
    ELSE
        v_salary := v_salary * 1.05;
    END IF;

    DBMS_OUTPUT.PUT_LINE('New Salary = ' || v_salary);
END;
/

--------------------------------------------------------------------------------
-- 2. Exam Grading System
--------------------------------------------------------------------------------
-- Question:
-- ≥90 Excellent, 70–89 Good, 50–69 Pass, <50 Fail

DECLARE
    v_marks NUMBER := 88;
BEGIN
    IF v_marks >= 90 THEN
        DBMS_OUTPUT.PUT_LINE('Excellent');
    ELSIF v_marks BETWEEN 70 AND 89 THEN
        DBMS_OUTPUT.PUT_LINE('Good');
    ELSIF v_marks BETWEEN 50 AND 69 THEN
        DBMS_OUTPUT.PUT_LINE('Pass');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Fail');
    END IF;
END;
/

--------------------------------------------------------------------------------
-- 3. Loan Eligibility Check
--------------------------------------------------------------------------------

DECLARE
    v_salary NUMBER := 45000;
    v_age    NUMBER := 45;
BEGIN
    IF v_salary > 40000 AND v_age < 60 THEN
        DBMS_OUTPUT.PUT_LINE('Loan Approved');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Not Eligible');
    END IF;
END;
/

--------------------------------------------------------------------------------
-- 4. Stock Discount Application
--------------------------------------------------------------------------------

DECLARE
    price       NUMBER := 7500;
    final_price NUMBER;
BEGIN
    IF price > 10000 THEN
        final_price := price * 0.80;
    ELSIF price BETWEEN 5000 AND 10000 THEN
        final_price := price * 0.90;
    ELSE
        final_price := price;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Final Price = ' || final_price);
END;
/

--------------------------------------------------------------------------------
-- 5. Employee Bonus Allocation
--------------------------------------------------------------------------------

DECLARE
    v_emp_id    NUMBER := 105;
    v_hire_date DATE;
    v_years     NUMBER;
    v_bonus     NUMBER;
BEGIN
    SELECT hire_date INTO v_hire_date
    FROM employees
    WHERE emp_id = v_emp_id;

    v_years := TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);

    IF v_years > 5 THEN
        v_bonus := 5000;
    ELSE
        v_bonus := 2000;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Years of Service = ' || v_years);
    DBMS_OUTPUT.PUT_LINE('Bonus = ' || v_bonus);
END;
/

--------------------------------------------------------------------------------
-- 6. ATM Cash Breakdown
--------------------------------------------------------------------------------

DECLARE
    amount NUMBER := 3650;
    n500 NUMBER;
    n100 NUMBER;
    n50 NUMBER;
BEGIN
    n500 := amount / 500;
    amount := MOD(amount, 500);

    n100 := amount / 100;
    amount := MOD(amount, 100);

    n50 := amount / 50;

    DBMS_OUTPUT.PUT_LINE('500 Notes: ' || n500);
    DBMS_OUTPUT.PUT_LINE('100 Notes: ' || n100);
    DBMS_OUTPUT.PUT_LINE('50 Notes: ' || n50);
END;
/

--------------------------------------------------------------------------------
-- 7. Restaurant Bill
--------------------------------------------------------------------------------

DECLARE
    total NUMBER := 0;
    price NUMBER;
BEGIN
    FOR i IN 1..5 LOOP
        price := i * 100;
        total := total + price;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total Bill = ' || total);
END;
/

--------------------------------------------------------------------------------
-- 8. Cinema Seat Booking
--------------------------------------------------------------------------------

DECLARE
    start_seat NUMBER := 21;
    count_seats NUMBER := 10;
BEGIN
    FOR s IN start_seat .. start_seat + count_seats - 1 LOOP
        DBMS_OUTPUT.PUT_LINE('Seat ' || s || ' booked');
    END LOOP;
END;
/

--------------------------------------------------------------------------------
-- 9. Electricity Bill
--------------------------------------------------------------------------------

DECLARE
    units NUMBER := 350;
    bill NUMBER := 0;
BEGIN
    FOR u IN 1..units LOOP
        IF u <= 100 THEN
            bill := bill + 3;
        ELSIF u <= 300 THEN
            bill := bill + 5;
        ELSE
            bill := bill + 7;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total Bill = ' || bill);
END;
/

--------------------------------------------------------------------------------
-- 10. Library Late Fees
--------------------------------------------------------------------------------

DECLARE
    days NUMBER := 12;
    fine NUMBER := 0;
BEGIN
    FOR d IN 1..days LOOP
        IF d <= 5 THEN
            fine := fine + 10;
        ELSE
            fine := fine + 20;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total Fine = ' || fine);
END;
/

--------------------------------------------------------------------------------
-- 11. Compound Interest
--------------------------------------------------------------------------------

DECLARE
    amount NUMBER := 10000;
    rate   NUMBER := 0.05;
    years  NUMBER := 3;
BEGIN
    FOR i IN 1..years LOOP
        amount := amount + (amount * rate);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Final Amount = ' || amount);
END;
/

--------------------------------------------------------------------------------
-- 12. Attendance
--------------------------------------------------------------------------------

DECLARE
    att VARCHAR2(10);
BEGIN
    FOR d IN 1..30 LOOP
        IF MOD(d, 2) = 0 THEN
            att := 'Present';
        ELSE
            att := 'Absent';
        END IF;
        DBMS_OUTPUT.PUT_LINE('Day ' || d || ': ' || att);
    END LOOP;
END;
/

--------------------------------------------------------------------------------
-- 13. Cursor - Employees in Dept
--------------------------------------------------------------------------------

DECLARE
    CURSOR c_emp IS
        SELECT emp_name, salary
        FROM employees
        WHERE dept_id = 20;
BEGIN
    FOR r IN c_emp LOOP
        DBMS_OUTPUT.PUT_LINE(r.emp_name || ' - ' || r.salary);
    END LOOP;
END;
/

--------------------------------------------------------------------------------
-- 14. Cursor FOR UPDATE
--------------------------------------------------------------------------------

DECLARE
    CURSOR c_sal IS
        SELECT emp_id, salary
        FROM employees
        WHERE job_title = 'Salesman'
        FOR UPDATE;
BEGIN
    FOR r IN c_sal LOOP
        UPDATE employees
        SET salary = r.salary + 2000
        WHERE emp_id = r.emp_id;
    END LOOP;
    COMMIT;
END;
/

--------------------------------------------------------------------------------
-- 15. Top Student Finder
--------------------------------------------------------------------------------

DECLARE
    CURSOR c_top IS
        SELECT class_id, student_name, gpa
        FROM students
        WHERE gpa = (
            SELECT MAX(gpa)
            FROM students s2
            WHERE s2.class_id = students.class_id
        );
BEGIN
    FOR r IN c_top LOOP
        DBMS_OUTPUT.PUT_LINE(r.class_id || ' - ' || r.student_name || ' - GPA:' || r.gpa);
    END LOOP;
END;
/

--------------------------------------------------------------------------------
-- 16. Customer Credit Check
--------------------------------------------------------------------------------

DECLARE
    CURSOR c_cust IS
        SELECT customer_name, unpaid_amount
        FROM customers
        WHERE unpaid_amount > 5000;
BEGIN
    FOR r IN c_cust LOOP
        DBMS_OUTPUT.PUT_LINE(r.customer_name || ' owes ' || r.unpaid_amount);
    END LOOP;
END;
/

--------------------------------------------------------------------------------
-- 17. Service Years Report
--------------------------------------------------------------------------------

DECLARE
    CURSOR c_serv IS
        SELECT emp_name,
               TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) years
        FROM employees;
BEGIN
    FOR r IN c_serv LOOP
        DBMS_OUTPUT.PUT_LINE(r.emp_name || ': ' || r.years || ' years');
    END LOOP;
END;
/

--------------------------------------------------------------------------------
-- 18. Low Stock Notification
--------------------------------------------------------------------------------

DECLARE
    CURSOR c_stock IS
        SELECT product_name, stock
        FROM inventory
        WHERE stock < 10;
BEGIN
    FOR r IN c_stock LOOP
        DBMS_OUTPUT.PUT_LINE(r.product_name || ' → Reorder Needed');
    END LOOP;
END;
/

--------------------------------------------------------------------------------
-- 19. Department Salary Report
--------------------------------------------------------------------------------

DECLARE
    CURSOR c_dept IS
        SELECT dept_id, SUM(salary) total_salary
        FROM employees
        GROUP BY dept_id;
BEGIN
    FOR r IN c_dept LOOP
        DBMS_OUTPUT.PUT_LINE('Dept ' || r.dept_id || ' = ' || r.total_salary);
    END LOOP;
END;
/

--------------------------------------------------------------------------------
-- 20. Rent Reminder
--------------------------------------------------------------------------------

DECLARE
    CURSOR c_tenant IS
        SELECT tenant_name
        FROM tenants
        WHERE paid_this_month = 'NO';
BEGIN
    FOR r IN c_tenant LOOP
        DBMS_OUTPUT.PUT_LINE('Reminder sent to: ' || r.tenant_name);
    END LOOP;
END;
/
