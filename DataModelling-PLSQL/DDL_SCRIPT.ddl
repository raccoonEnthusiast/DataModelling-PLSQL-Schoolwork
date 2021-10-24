-- Administration Code
DROP TABLE COLOUR CASCADE CONSTRAINTS;
DROP TABLE CUSTOMER CASCADE CONSTRAINTS;
DROP TABLE ITEM CASCADE CONSTRAINTS;
DROP TABLE LINE_ITEM CASCADE CONSTRAINTS;
DROP TABLE SUPPLIER CASCADE CONSTRAINTS;
DROP TABLE PAYMENT CASCADE CONSTRAINTS;
DROP TABLE PURCHASEORDER CASCADE CONSTRAINTS;
DROP TABLE SALESPERSON CASCADE CONSTRAINTS;
DROP TABLE SALESPURCHASE CASCADE CONSTRAINTS;
DROP TABLE VEHICLE CASCADE CONSTRAINTS;

DROP SEQUENCE PURCHASEORDER_SEQ;
DROP SEQUENCE SALESPURCHASE_SEQ;

-- Create Tables
CREATE TABLE colour (
    colour_id   VARCHAR2(2) NOT NULL,
    clr_desc  VARCHAR2(10) NOT NULL
);

ALTER TABLE colour ADD CONSTRAINT colour_pk PRIMARY KEY ( colour_id );

CREATE TABLE customer (
    customer_id  NUMBER(8) NOT NULL,
    cus_fname    VARCHAR2(30) NOT NULL,
    cus_lname    VARCHAR2(30) NOT NULL,
    cus_address  VARCHAR2(40) NOT NULL,
    cus_suburb   VARCHAR2(30) NOT NULL,
    cus_city     VARCHAR2(30) NOT NULL,
    cus_phone    NUMBER(10) NOT NULL
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( customer_id );

CREATE TABLE item (
    item_id    NUMBER(2) NOT NULL,
    item_make   VARCHAR2(20) NOT NULL,
    item_model  VARCHAR2(20) NOT NULL,
    item_year   NUMBER(4) NOT NULL,
    item_price  NUMBER(8, 2) NOT NULL
);

ALTER TABLE item ADD CONSTRAINT item_pk PRIMARY KEY ( item_id );

CREATE TABLE line_item (
    purchaseorder_id  NUMBER(8) NOT NULL,
    item_id    NUMBER(2) NOT NULL,
    line_price  NUMBER(8, 2) NOT NULL,
    line_qty    NUMBER(2) DEFAULT 1 NOT NULL,
    line_total  NUMBER(8, 2) NOT NULL
);

ALTER TABLE line_item ADD CONSTRAINT line_item_pk PRIMARY KEY ( purchaseorder_id,
                                                                item_id );

CREATE TABLE payment (
    payment_id        NUMBER(9) NOT NULL,
    pay_salesPurchase_id  NUMBER(8) NOT NULL,
    pay_date          DATE NOT NULL,
    pay_amount        NUMBER(8, 2) NOT NULL,
    pay_customer_id  NUMBER(8) NOT NULL,
    pay_salesperson_id       CHAR(5) NOT NULL
);

ALTER TABLE payment ADD CONSTRAINT payment_pk PRIMARY KEY ( payment_id );


CREATE TABLE purchaseorder (
    purchaseorder_id  NUMBER(8) NOT NULL,
    order_supplier_id       CHAR(5) NOT NULL,
    order_date           DATE NOT NULL,
    order_subtotal       NUMBER(9, 2) NOT NULL,
    order_salesperson_id    CHAR(5) NOT NULL
);

ALTER TABLE purchaseorder ADD CONSTRAINT purchaseorder_pk PRIMARY KEY ( purchaseorder_id );


CREATE TABLE salesperson (
    salesperson_id    CHAR(5) NOT NULL,
    spn_fname          VARCHAR2(30) NOT NULL,
    spn_lname          VARCHAR2(30) NOT NULL,
    spn_startdate      DATE NOT NULL,
    spn_phone          NUMBER(10) NOT NULL,
    spn_supervisor_id  CHAR(5)
);

ALTER TABLE salesperson ADD CONSTRAINT salesperson_pk PRIMARY KEY ( salesperson_id );


CREATE TABLE salespurchase (
    salespurchase_id     NUMBER(8) NOT NULL,
    sale_date             DATE NOT NULL,
    sale_addcost   NUMBER(7, 2) NOT NULL,
    sale_subtotal         NUMBER(8, 2) NOT NULL,
    sale_deposit          NUMBER(7, 2),
    sale_vehicle_id   CHAR(6) NOT NULL,
    sale_customer_id     NUMBER(8) NOT NULL,
    sale_salesperson_id  CHAR(5) NOT NULL
);

CREATE UNIQUE INDEX salespurchase_vehicle_idx ON
    salespurchase (
        sale_vehicle_id
    ASC );

ALTER TABLE salespurchase ADD CONSTRAINT salespurchase_pk PRIMARY KEY ( salespurchase_id );

ALTER TABLE salespurchase ADD CONSTRAINT salespurchase_vehicle_id_un UNIQUE ( sale_vehicle_id );

CREATE TABLE supplier (
    supplier_id     CHAR(5) NOT NULL,
    sup_address      VARCHAR2(50) NOT NULL,
    sup_suburb       VARCHAR2(30) NOT NULL,
    sup_city         VARCHAR2(30) NOT NULL,
    sup_contactname  VARCHAR2(60) NOT NULL,
    sup_phone        NUMBER(10) NOT NULL
);

ALTER TABLE supplier ADD CONSTRAINT supplier_pk PRIMARY KEY ( supplier_id );

CREATE TABLE vehicle (
    vehicle_id         CHAR(6) NOT NULL,
    veh_make            VARCHAR2(20) NOT NULL,
    veh_model           VARCHAR2(20) NOT NULL,
    veh_year            NUMBER(4) NOT NULL,
    veh_odometer        NUMBER(7) NOT NULL,
    veh_numowners       NUMBER(2) NOT NULL,
    veh_saleprice       NUMBER(8, 2) NOT NULL,
    veh_colour_id   VARCHAR2(2) NOT NULL,
    veh_salespurchase_id  NUMBER(8) NOT NULL
);

CREATE UNIQUE INDEX vehicle_salespurchase_idx ON
    vehicle (
        veh_salespurchase_id
    ASC );

ALTER TABLE vehicle ADD CONSTRAINT vehicle_pk PRIMARY KEY ( vehicle_id );

-- Foreign Keys
ALTER TABLE line_item
    ADD CONSTRAINT line_item_item_fk FOREIGN KEY ( item_id )
        REFERENCES item ( item_id );

ALTER TABLE line_item
    ADD CONSTRAINT line_item_purchaseorder_fk FOREIGN KEY ( purchaseorder_id )
        REFERENCES purchaseorder ( purchaseorder_id );

ALTER TABLE payment
    ADD CONSTRAINT payment_customer_fk FOREIGN KEY ( pay_customer_id )
        REFERENCES customer ( customer_id );

ALTER TABLE payment
    ADD CONSTRAINT payment_salesperson_fk FOREIGN KEY ( pay_salesperson_id )
        REFERENCES salesperson ( salesperson_id );

ALTER TABLE payment
    ADD CONSTRAINT payment_salespurchase_fk FOREIGN KEY ( pay_salesPurchase_id )
        REFERENCES salespurchase ( salespurchase_id );

ALTER TABLE purchaseorder
    ADD CONSTRAINT purchaseorder_salesperson_fk FOREIGN KEY ( order_salesperson_id )
        REFERENCES salesperson ( salesperson_id );

ALTER TABLE purchaseorder
    ADD CONSTRAINT purchaseorder_supplier_fk FOREIGN KEY ( order_supplier_id )
        REFERENCES supplier ( supplier_id );

ALTER TABLE salesperson
    ADD CONSTRAINT salesperson_salesperson_fk FOREIGN KEY ( spn_supervisor_id )
        REFERENCES salesperson ( salesperson_id );

ALTER TABLE salespurchase
    ADD CONSTRAINT salespurchase_customer_fk FOREIGN KEY ( sale_customer_id )
        REFERENCES customer ( customer_id );

ALTER TABLE salespurchase
    ADD CONSTRAINT salespurchase_salesperson_fk FOREIGN KEY ( sale_salesperson_id )
        REFERENCES salesperson ( salesperson_id );

ALTER TABLE salespurchase
    ADD CONSTRAINT salespurchase_vehicle_fk FOREIGN KEY ( sale_vehicle_id )
        REFERENCES vehicle ( vehicle_id );

ALTER TABLE vehicle
    ADD CONSTRAINT vehicle_colour_fk FOREIGN KEY ( veh_colour_id )
        REFERENCES colour ( colour_id );

ALTER TABLE vehicle
    ADD CONSTRAINT vehicle_salespurchase_fk FOREIGN KEY ( veh_salespurchase_id )
        REFERENCES salespurchase ( salespurchase_id );

-- Order ID Surrogate Keys
CREATE SEQUENCE purchaseorder_seq 
    START WITH 80000000 
    INCREMENT BY 1;

CREATE OR REPLACE TRIGGER purchaseorder_seq_trg 
    BEFORE INSERT ON purchaseorder
    REFERENCING NEW AS NEW
    FOR EACH ROW
    BEGIN
        SELECT purchaseorder_seq.NEXTVAL INTO :NEW.purchaseorder_id FROM DUAL;
    END;
/

-- Sales Purchases Surrogate Keys
CREATE SEQUENCE salespurchase_seq 
    START WITH 10000000 
    INCREMENT BY 1;

CREATE OR REPLACE TRIGGER salespurchase_seq_trg 
    BEFORE INSERT ON salespurchase
    REFERENCING NEW AS NEW  
    FOR EACH ROW
    BEGIN
        SELECT salespurchase_seq.NEXTVAL INTO :NEW.salespurchase_id FROM DUAL;
    END;
/