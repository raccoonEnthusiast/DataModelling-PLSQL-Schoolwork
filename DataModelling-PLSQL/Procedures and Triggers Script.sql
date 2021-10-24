-- Name: Andrew Phillips
-- ID: 19484112

-- 1.1
SET SERVEROUTPUT ON;
SPOOL 'g:\VehiclePurchasers.csv';

DECLARE
    CURSOR sale_cursor IS 
        SELECT cu.C_ID, cu.C_FNAME, cu.C_LNAME, cu.C_ADDRESS3, sp.V_REGNO, v.V_MAKE, v.V_MODEL, clr.C_COLOUR, sp.SP_TOTAL
        FROM SALES_PURCHASES sp, CUSTOMERS cu, VEHICLES v, LU_COLOURS clr
        WHERE sp.C_ID = cu.C_ID AND sp.V_REGNO = v.V_REGNO AND v.C_NO = clr.C_NO;
    
    sale_row sale_cursor%ROWTYPE;
    rec_output VARCHAR2(200);
BEGIN

    DBMS_OUTPUT.PUT_LINE('C_ID,'||'C_FNAME,'||'C_LNAME,'||'C_ADDRESS3,'||'V_REGNO,'||'V_MAKE,'||'V_MODEL,'||'C_COLOUR,'||'SP_TOTAL');
    FOR sale_row IN sale_cursor LOOP
        rec_output := sale_row.C_ID || ',' ||
                      sale_row.C_FNAME || ',' ||
                      sale_row.C_LNAME || ',' ||
                      sale_row.C_ADDRESS3 || ',' ||
                      sale_row.V_REGNO || ',' ||
                      sale_row.V_MAKE || ',' ||
                      sale_row.V_MODEL || ',' ||
                      sale_row.C_COLOUR || ',$' ||
                      sale_row.SP_TOTAL;
        DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT OFF;

-- 1.2
SET SERVEROUTPUT ON;
SPOOL 'g:\PurchaseSales.csv';

DECLARE
    CURSOR purchase_cursor IS 
        SELECT sp.SP_INVOICE, sp.C_ID, cu.C_FNAME, cu.C_LNAME, cu.C_PH, sp.V_REGNO, v.V_YEAR, v.V_MAKE, v.V_MODEL, sp.SP_ID, spn.SP_FNAME, spn.SP_LNAME, spn.SP_SUP
        FROM SALES_PURCHASES sp, CUSTOMERS cu, VEHICLES v, SALES_PERSONS spn
        WHERE sp.C_ID = cu.C_ID AND sp.V_REGNO = v.V_REGNO AND sp.SP_ID = spn.SP_ID;
    
    purchase_row purchase_cursor%ROWTYPE;
    rec_output VARCHAR2(200);

BEGIN
    DBMS_OUTPUT.PUT_LINE('SP_INVOICE,'||'C_ID,'||'C_FNAME,'||'C_LNAME,'||'C_PH,'||'V_REGNO,'||'V_YEAR,'||'V_MAKE,'||'V_MODEL,'||'SP_ID,'||'SP_FNAME,'||'SP_LNAME,'||'SP_SUP');
    FOR purchase_row IN purchase_cursor LOOP
        rec_output := purchase_row.SP_INVOICE || ',' ||
                      purchase_row.C_ID || ',' ||
                      purchase_row.C_FNAME || ',' ||
                      purchase_row.C_LNAME || ',' ||
                      purchase_row.C_PH || ',' ||
                      purchase_row.V_REGNO || ',' ||
                      purchase_row.V_YEAR || ',' ||
                      purchase_row.V_MAKE || ',' ||
                      purchase_row.V_MODEL || ',' ||
                      purchase_row.SP_ID || ',' ||
                      purchase_row.SP_FNAME || ',' ||
                      purchase_row.SP_LNAME || ',' ||
                      purchase_row.SP_SUP;
        DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT OFF;

     
-- 2.1
CREATE OR REPLACE PROCEDURE saleByMake(
    in_make IN vehicles.v_make%TYPE
)
IS
    CURSOR search_cursor IS
        SELECT v.v_regno, v.v_make, v.v_model, v.v_year, v.v_price
        FROM vehicles v LEFT JOIN sales_purchases sp ON sp.v_regno = v.v_regno
        WHERE v.v_make = in_make AND sp.v_regno IS NULL;

    search_row search_cursor%ROWTYPE;
    rec_output VARCHAR2(200);
BEGIN
        DBMS_OUTPUT.PUT_LINE('V_REGNO,'||'V_MAKE,' || 'V_MODEL');
        FOR search_row IN search_cursor LOOP
         rec_output := search_row.v_regno || ',' ||
                       search_row.v_make  || ',' ||
                       search_row.v_model  || ',' ||
                       search_row.v_year  || ',' ||
                       search_row.v_price;
        DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT ON;
EXEC saleByMake('Mazda');
SET SERVEROUTPUT OFF;

-- 2.1
CREATE OR REPLACE PROCEDURE saleByModel(
    in_model IN vehicles.v_model%TYPE
)
IS
    CURSOR search_cursor IS
        SELECT v.v_regno, v.v_make, v.v_model, v.v_year, v.v_price 
        FROM vehicles v LEFT JOIN sales_purchases sp ON sp.v_regno = v.v_regno
        WHERE v.v_model = in_model AND sp.v_regno IS NULL;

    search_row search_cursor%ROWTYPE;
    rec_output VARCHAR2(200);
BEGIN
        DBMS_OUTPUT.PUT_LINE('V_REGNO,'||'V_MAKE,' || 'V_MODEL');
        FOR search_row IN search_cursor LOOP
         rec_output := search_row.v_regno || ',' ||
                       search_row.v_make  || ',' ||
                       search_row.v_model  || ',' ||
                       search_row.v_year  || ',' ||
                       search_row.v_price;
        DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT ON;
EXEC saleByModel('Bluebird');
SET SERVEROUTPUT OFF;

-- 2.2
CREATE OR REPLACE PROCEDURE SalesReport(
    in_start_date IN sales_purchases.sp_datesold%TYPE,
    in_end_date IN sales_purchases.sp_datesold%TYPE
)
IS
    CURSOR search_cursor IS
        SELECT sp_invoice, sp_datesold, sp_saleprice, sp_addncost, sp_deposit, sp_total, sp_ID, c_ID, v_REGNO
        FROM sales_purchases
        WHERE sp_datesold BETWEEN in_start_date AND in_end_date;
    
    search_row search_cursor%ROWTYPE;
    rec_output VARCHAR2(200);
BEGIN 
    DBMS_OUTPUT.PUT_LINE('SP_INVOICE,'||'SP_DATESOLD,'||'SP_SALEPRICE,'||'SP_ADDNCOST,'||'SP_DEPOSIT,'||'SP_TOTAL,'||'SP_ID,'||'C_ID,'||'V_REGNO');
    FOR search_row IN search_cursor LOOP
        rec_output := search_row.sp_invoice || ',' ||
                      search_row.sp_datesold || ',' ||
                      search_row.sp_saleprice || ',' ||
                      search_row.sp_addncost || ',' ||
                      search_row.sp_deposit || ',' ||
                      search_row.sp_total || ',' ||
                      search_row.sp_ID || ',' ||
                      search_row.c_ID || ',' ||
                      search_row.v_REGNO;
         DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT ON;
EXEC SalesReport('01-01-2016', '31-05-2016');
SET SERVEROUTPUT OFF;

-- 2.3
CREATE OR REPLACE PROCEDURE SearchById(
    in_C_ID IN customers.c_id%TYPE
)
IS 
    CURSOR search_cursor IS
        SELECT c.C_ID, c.C_FNAME, c.C_LNAME, c.C_GENDER, c.C_ADDRESS1, c.C_ADDRESS2, c.C_ADDRESS3, c.C_PH, sp.SP_TOTAL, sp.V_REGNO, v.V_MAKE, v.V_MODEL, v.v_YEAR, sp.SP_ID
        FROM CUSTOMERS c, SALES_PURCHASES sp, VEHICLES v
        WHERE sp.C_ID = c.C_ID AND sp.V_REGNO = v.v_REGNO AND c.C_ID = in_C_ID;
    
    search_row search_cursor%ROWTYPE;
    rec_output VARCHAR2(200);
BEGIN
    DBMS_OUTPUT.PUT_LINE('C_ID,'||'C_FNAME,'||'C_LNAME,'||'C_GENDER,'||'C_ADDRESS1,'||'C_ADDRESS2,'||'C_ADDRESS3,'||'C_PH,'||'SP_TOTAL,'||'V_REGNO,'||'V_MAKE,'||'V_V_MODEL,'||'V_V_YEAR,'||'SP_ID');
    FOR search_row IN search_cursor LOOP
        rec_output := search_row.C_ID || ',' ||
                      search_row.C_FNAME || ',' ||
                      search_row.C_LNAME || ',' ||
                      search_row.C_GENDER || ',' ||
                      search_row.C_ADDRESS1 || ',' ||
                      search_row.C_ADDRESS2 || ',' ||
                      search_row.C_ADDRESS3 || ',' ||
                      search_row.C_PH || ',' ||
                      search_row.SP_TOTAL || ',' ||
                      search_row.V_REGNO || ',' ||
                      search_row.V_MAKE || ',' ||
                      search_row.V_MODEL || ',' ||
                      search_row.V_YEAR || ',' ||
                      search_row.SP_ID;
         DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT ON;
EXEC SearchById(3);
SET SERVEROUTPUT OFF;

-- 2.3
CREATE OR REPLACE PROCEDURE SearchByLname(
    in_LNAME IN customers.C_LNAME%TYPE
)
IS 
    CURSOR search_cursor IS
        SELECT c.C_ID, c.C_FNAME, c.C_LNAME, c.C_GENDER, c.C_ADDRESS1, c.C_ADDRESS2, c.C_ADDRESS3, c.C_PH, sp.SP_TOTAL, sp.V_REGNO, v.V_MAKE, v.V_MODEL, v.v_YEAR, sp.SP_ID
        FROM CUSTOMERS c, SALES_PURCHASES sp, VEHICLES v
        WHERE sp.C_ID = c.C_ID AND sp.V_REGNO = v.v_REGNO AND c.C_LNAME = in_LNAME;
    
    search_row search_cursor%ROWTYPE;
    rec_output VARCHAR2(200);
BEGIN
   DBMS_OUTPUT.PUT_LINE('C_ID,'||'C_FNAME,'||'C_LNAME,'||'C_GENDER,'||'C_ADDRESS1,'||'C_ADDRESS2,'||'C_ADDRESS3,'||'C_PH,'||'SP_TOTAL,'||'V_REGNO,'||'V_MAKE,'||'V_V_MODEL,'||'V_V_YEAR,'||'SP_ID');
    FOR search_row IN search_cursor LOOP
        rec_output := search_row.C_ID || ',' ||
                      search_row.C_FNAME || ',' ||
                      search_row.C_LNAME || ',' ||
                      search_row.C_GENDER || ',' ||
                      search_row.C_ADDRESS1 || ',' ||
                      search_row.C_ADDRESS2 || ',' ||
                      search_row.C_ADDRESS3 || ',' ||
                      search_row.C_PH || ',' ||
                      search_row.SP_TOTAL || ',' ||
                      search_row.V_REGNO || ',' ||
                      search_row.V_MAKE || ',' ||
                      search_row.V_MODEL || ',' ||
                      search_row.V_YEAR || ',' ||
                      search_row.SP_ID;
        DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT ON;
EXEC SearchByLname('Mallark');
SET SERVEROUTPUT OFF;

-- 2.4
CREATE OR REPLACE PROCEDURE PaymentsReport(
    in_start_date IN payments.p_date%TYPE,
    in_end_date IN payments.p_date%TYPE
)
IS
    CURSOR search_cursor IS
        SELECT p_invoice, p_date, p_amount, c_id, sp_invoice
        FROM payments
        WHERE p_date BETWEEN in_start_date AND in_end_date;
    
    search_row search_cursor%ROWTYPE;
    rec_output VARCHAR2(200);
BEGIN 
    DBMS_OUTPUT.PUT_LINE('P_INVOICE,'||'P_DATE,'||'P_AMOUNT,'||'C_ID,'||'SP_INVOICE');
    FOR search_row IN search_cursor LOOP
        rec_output := search_row.p_invoice || ',' ||
                      search_row.p_date || ',' ||
                      search_row.p_amount || ',' ||
                      search_row.c_id || ',' ||
                      search_row.sp_invoice;
         DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT ON;
EXEC PaymentsReport('01-01-2015', '31-12-2015');
SET SERVEROUTPUT OFF;

-- 3.1
CREATE OR REPLACE FUNCTION NumberOfDays(
    in_start_date IN DATE,
    in_end_date IN DATE
) RETURN NUMBER
IS
    NumDays NUMBER;
BEGIN
    NumDays := TRUNC (in_end_date - in_start_date);
    RETURN NumDays;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- 3.2
CREATE OR REPLACE PROCEDURE DaysSinceOrder
IS 
        CURSOR odr_cursor IS
        SELECT orders.o_id, orders.o_date, orders.o_totalqty, orders.o_total
        FROM orders;
    
    odr_row odr_cursor%ROWTYPE;
    rec_output VARCHAR2(200);
BEGIN
    DBMS_OUTPUT.PUT_LINE('O_ID,'||'O_DATE,'||'O_TOTALQTY,'||'O_TOTAL,'||'NUM_DAYS_SINCE_ORDER');
    FOR odr_row IN odr_cursor LOOP
        rec_output := odr_row.o_id || ',' ||
                      odr_row.o_date || ',' ||
                      odr_row.o_totalqty || ',' ||
                      odr_row.o_total || ',' ||
                      NumberOfDays(odr_row.o_date, CURRENT_DATE);
         DBMS_OUTPUT.PUT_LINE(rec_output);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

SET SERVEROUTPUT ON;
EXEC DaysSinceOrder;
SET SERVEROUTPUT OFF;

-- 4.1
CREATE OR REPLACE PROCEDURE AddPurchaseSale(
    in_sp_datesold IN sales_purchases.sp_datesold%TYPE,
    in_sp_deposit IN sales_purchases.sp_deposit%TYPE,
    in_sp_ID IN sales_purchases.sp_id%TYPE,
    in_c_id IN sales_purchases.c_id%TYPE,
    in_v_regno IN sales_purchases.v_regno%TYPE
)
IS
BEGIN
    INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT in_sp_datesold, vehicles.v_price, in_sp_deposit, in_sp_ID, in_c_id, in_v_regno FROM vehicles WHERE vehicles.v_regno = in_v_regno;
    COMMIT;

    UPDATE sales_purchases SET sp_addncost = sp_saleprice*0.2;
    UPDATE sales_purchases SET sp_total = (sp_saleprice + sp_addncost) - sp_deposit;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
END;
/

SELECT * FROM SALES_PURCHASES;
SET SERVEROUTPUT ON;
EXEC AddPurchaseSale('02-06-2017',2000,'MK201',1,'SHEEPS');
SET SERVEROUTPUT OFF;
SELECT * FROM SALES_PURCHASES;
ROLLBACK;

-- 4.2
CREATE OR REPLACE PROCEDURE AddPurchaseOrderItem(
    in_o_ID IN order_lines.o_ID%TYPE,
    in_i_no IN order_lines.i_NO%TYPE,
    in_ol_qty IN order_lines.ol_qty%TYPE
)
IS
BEGIN
    INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty)
    SELECT in_o_ID, in_i_no, items.i_make, items.i_model, items.i_price, items.i_year, in_ol_qty FROM items WHERE items.i_no = in_i_no;
    COMMIT;

    UPDATE order_lines SET ol_subtotal = ol_qty * i_price;
    
    UPDATE orders SET o_total = (
	SELECT SUM (ol_subtotal)
	FROM order_lines
	WHERE orders.o_id = order_lines.o_id );

    UPDATE orders SET o_totalqty = (
	SELECT SUM (ol_qty)
	FROM order_lines
	WHERE orders.o_id = order_lines.o_id );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
END;
/

INSERT INTO orders(o_date, s_code, sp_id) VALUES ('01-01-2016', 'XTRQC', 'MK201');
SELECT * FROM ORDERS;
SET SERVEROUTPUT ON;
EXEC AddPurchaseOrderItem(80000040,49,3);
SET SERVEROUTPUT OFF;   
ROLLBACK;

-- 5
CREATE OR REPLACE TRIGGER supervisor_trigger
BEFORE INSERT OR UPDATE ON sales_persons
    FOR EACH ROW
DECLARE
    num_sup NUMBER;
BEGIN
    SELECT COUNT(sp_sup) INTO num_sup
    FROM sales_persons
    WHERE sp_sup = :NEW.sp_sup;
    
    IF num_sup >= 2 THEN
        RAISE_APPLICATION_ERROR(-20000,'INSERT DENIED: Supervisor allocated too many sales persons');
    END IF;
END supervisor_trigger;

ALTER TRIGGER supervisor_trigger ENABLE;
INSERT INTO sales_persons (sp_id, sp_fname, sp_lname, sp_startdate, sp_cellph, sp_comrate, sp_sup) VALUES ('AP352', 'Andrew', 'Phillips', '21-Mar-16', '0210998213', 0.15, 'MK201');
SELECT sp_id, sp_fname, sp_lname, sp_cellph, sp_sup FROM sales_persons;
ALTER TRIGGER supervisor_trigger DISABLE;