DECLARE
    basic_salary NUMBER := 3000;
    bonus        NUMBER := 500;
    annual_salary NUMBER;
BEGIN
    annual_salary := (basic_salary + bonus) * 12;

    DBMS_OUTPUT.PUT_LINE('Annual Salary = ' || annual_salary);
END;
/




DECLARE
    m1 NUMBER := 85;
    m2 NUMBER := 90;
    m3 NUMBER := 80;
    avg_marks NUMBER;
BEGIN
    avg_marks := (m1 + m2 + m3) / 3;

    DBMS_OUTPUT.PUT_LINE('Average Marks = ' || avg_marks);
END;
/




DECLARE
    balance NUMBER := 3500;
BEGIN
    IF balance < 1000 THEN
        DBMS_OUTPUT.PUT_LINE('Low Balance');
    ELSIF balance BETWEEN 1000 AND 5000 THEN
        DBMS_OUTPUT.PUT_LINE('Sufficient Balance');
    ELSE
        DBMS_OUTPUT.PUT_LINE('High Balance');
    END IF;
END;
/




DECLARE
    percentage NUMBER := 72;
BEGIN
    CASE
        WHEN percentage BETWEEN 90 AND 100 THEN
            DBMS_OUTPUT.PUT_LINE('A Grade');
        WHEN percentage BETWEEN 75 AND 89 THEN
            DBMS_OUTPUT.PUT_LINE('B Grade');
        WHEN percentage BETWEEN 50 AND 74 THEN
            DBMS_OUTPUT.PUT_LINE('C Grade');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Fail');
    END CASE;
END;
/







DECLARE
    bill NUMBER := 4500;
    discount NUMBER;
    final_bill NUMBER;
BEGIN
    IF bill > 5000 THEN
        discount := bill * 0.20;
    ELSIF bill BETWEEN 2000 AND 5000 THEN
        discount := bill * 0.10;
    ELSE
        discount := 0;
    END IF;

    final_bill := bill - discount;

    DBMS_OUTPUT.PUT_LINE('Final Bill = ' || final_bill);
END;
/



DECLARE
    n NUMBER := 7;
BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(n || ' x ' || i || ' = ' || (n * i));
    END LOOP;
END;
/





BEGIN
    FOR i IN 100..120 LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || i);
    END LOOP;
END;
/



DECLARE
    n NUMBER := 5;
    fact NUMBER := 1;
    i NUMBER := 1;
BEGIN
    WHILE i <= n LOOP
        fact := fact * i;
        i := i + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Factorial = ' || fact);
END;
/




BEGIN
    FOR i IN REVERSE 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/






BEGIN
    FOR rec IN (SELECT emp_id, salary FROM employees WHERE salary < 3000) LOOP
        UPDATE employees
        SET salary = salary * 1.10
        WHERE emp_id = rec.emp_id;

        DBMS_OUTPUT.PUT_LINE('Updated Salary for Emp ID ' || rec.emp_id);
    END LOOP;
END;
/





DECLARE
    v_salary NUMBER := 6000;
BEGIN
    IF v_salary > 8000 THEN
        DBMS_OUTPUT.PUT_LINE('High Earner');
    ELSIF v_salary BETWEEN 4000 AND 8000 THEN
        DBMS_OUTPUT.PUT_LINE('Mid Earner');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Low Earner');
    END IF;
END;
/




DECLARE
    n NUMBER := 10;
    a NUMBER := 0;
    b NUMBER := 1;
    c NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(a);
    DBMS_OUTPUT.PUT_LINE(b);

    FOR i IN 3..n LOOP
        c := a + b;
        DBMS_OUTPUT.PUT_LINE(c);
        a := b;
        b := c;
    END LOOP;
END;
/




DECLARE
    balance NUMBER := 0;
BEGIN
    FOR rec IN (SELECT amount, type FROM transactions) LOOP
        IF rec.type = 'CREDIT' THEN
            balance := balance + rec.amount;
        ELSE
            balance := balance - rec.amount;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Final Balance = ' || balance);
END;
/




CREATE OR REPLACE PROCEDURE emp_details(p_emp_id NUMBER) IS
    v_name employees.emp_name%TYPE;
    v_salary employees.salary%TYPE;
    v_dept departments.dept_name%TYPE;
BEGIN
    SELECT e.emp_name, e.salary, d.dept_name
    INTO v_name, v_salary, v_dept
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    WHERE e.emp_id = p_emp_id;

    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
END;
/
