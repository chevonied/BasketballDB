-- CHEVONIE DANIEL

BEGIN
  EXECUTE IMMEDIATE 'drop table "BASKETBALLDB"."P_ROLE" cascade constraints PURGE';
  EXECUTE IMMEDIATE 'drop table "BASKETBALLDB"."REFEREE" cascade constraints PURGE';
  EXECUTE IMMEDIATE 'drop table "BASKETBALLDB"."TEAM" cascade constraints PURGE';
  EXECUTE IMMEDIATE 'drop table "BASKETBALLDB"."PLAYER" cascade constraints PURGE';
  EXECUTE IMMEDIATE 'drop table "BASKETBALLDB"."PLAYERROLE" cascade constraints PURGE';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(NULL);
END;
/


CREATE TABLE Referee (
  REF_ID VARCHAR2(7) PRIMARY KEY NOT NULL,
  REF_FNAME VARCHAR2(30) DEFAULT 'X',
  REF_LNAME VARCHAR2(30) DEFAULT 'MAF'
);

CREATE TABLE P_ROLE (
  P_ROLE_ID VARCHAR2(7) PRIMARY KEY NOT NULL,
  P_ROLE_DESCRIPTION VARCHAR2(1000) DEFAULT 'ASSISTS SCOREER' UNIQUE,
  P_ROLE_RISKLEVEL NUMBER(2,1)
);

CREATE TABLE TEAM (
  TEAM_ID VARCHAR2(7) PRIMARY KEY NOT NULL,
  TEAM_NAME VARCHAR2(30),
  TEAM_SLOGAN VARCHAR2(1000) DEFAULT 'THAT IS HOW IT IS DONE' UNIQUE,
  REF_ID VARCHAR2(7) NOT NULL,
  CONSTRAINT TEAM_FK_REF FOREIGN KEY (REF_ID) REFERENCES Referee (REF_ID)
);

CREATE TABLE PLAYER (
  PLAYER_ID VARCHAR2(7) PRIMARY KEY NOT NULL,
  PLAYER_FNAME VARCHAR2(30) DEFAULT 'JOHN',
  PLAYER_LNAME VARCHAR2(30) DEFAULT 'SMITH',
  PLAYER_STARTDATE DATE,
  TEAM_ID VARCHAR2(7) NOT NULL,
  CONSTRAINT PLAYER_FK_TEAM FOREIGN KEY (TEAM_ID) REFERENCES TEAM (TEAM_ID)
);

CREATE TABLE PLAYERROLE (
  PLAYER_ID VARCHAR2(7) NOT NULL,
  P_ROLE_ID VARCHAR2(7) NOT NULL,
  PROLE_STARTDATE DATE,
  PROLE_ENDDATE DATE,
  PROLE_SEASON VARCHAR2(7) DEFAULT 'SPRING',
  CONSTRAINT PLAYERROLE_FK_PLAYER FOREIGN KEY (PLAYER_ID) REFERENCES PLAYER (PLAYER_ID),
  CONSTRAINT PLAYERROLE_FK_P_ROLE FOREIGN KEY (P_ROLE_ID) REFERENCES P_ROLE (P_ROLE_ID)
);

INSERT INTO P_ROLE (P_ROLE_ID, P_ROLE_DESCRIPTION, P_ROLE_RISKLEVEL) VALUES (1, 'DEFEND POWER FORWARD', 7.5);
INSERT INTO P_ROLE (P_ROLE_ID, P_ROLE_DESCRIPTION, P_ROLE_RISKLEVEL) VALUES (2, 'SCORING', 6);
INSERT INTO P_ROLE (P_ROLE_ID, P_ROLE_DESCRIPTION, P_ROLE_RISKLEVEL) VALUES (3, 'GET REBOUNDS', 5.5);

INSERT INTO Referee (REF_ID, REF_FNAME, REF_LNAME) VALUES (1, 'XU', 'BROCKER');
INSERT INTO Referee (REF_ID, REF_FNAME, REF_LNAME) VALUES (2, 'TOM', 'JONES');
INSERT INTO Referee (REF_ID, REF_FNAME, REF_LNAME) VALUES (3, 'TIM', 'WAYLAND');

INSERT INTO TEAM (TEAM_ID, TEAM_NAME, TEAM_SLOGAN, REF_ID) VALUES (1, 'OWLZ', 'CRUSH EM', 1);
INSERT INTO TEAM (TEAM_ID, TEAM_NAME, TEAM_SLOGAN, REF_ID) VALUES (2, 'OG RILLERS', 'KEEP GOING', 2);
INSERT INTO TEAM (TEAM_ID, TEAM_NAME, TEAM_SLOGAN, REF_ID) VALUES (3, 'BRIGHT BATS', 'GO BAD BATS', 3);

INSERT INTO PLAYER (PLAYER_ID, PLAYER_FNAME, PLAYER_LNAME, PLAYER_STARTDATE, TEAM_ID) VALUES (1, 'KURT', 'LOWE', TO_DATE('2/21/2010','MM/DD/YYYY'), 2);
INSERT INTO PLAYER (PLAYER_ID, PLAYER_FNAME, PLAYER_LNAME, PLAYER_STARTDATE, TEAM_ID) VALUES (2, 'ASA', 'BANTON', TO_DATE('7/14/2012','MM/DD/YYYY'), 3);
INSERT INTO PLAYER (PLAYER_ID, PLAYER_FNAME, PLAYER_LNAME, PLAYER_STARTDATE, TEAM_ID) VALUES (3, 'BO', 'INUM', TO_DATE('11/10/2002','MM/DD/YYYY'), 1);

INSERT INTO PLAYERROLE (PLAYER_ID, P_ROLE_ID, PROLE_STARTDATE, PROLE_ENDDATE, PROLE_SEASON) VALUES (1, 2, TO_DATE('1/7/2016','MM/DD/YYYY'), TO_DATE('4/9/2016','MM/DD/YYYY'), 'SPRING');
INSERT INTO PLAYERROLE (PLAYER_ID, P_ROLE_ID, PROLE_STARTDATE, PROLE_ENDDATE, PROLE_SEASON) VALUES (2, 3, TO_DATE('2/12/2016','MM/DD/YYYY'), TO_DATE('4/9/2016','MM/DD/YYYY'), 'SPRING');
INSERT INTO PLAYERROLE (PLAYER_ID, P_ROLE_ID, PROLE_STARTDATE, PROLE_ENDDATE, PROLE_SEASON) VALUES (3, 1, TO_DATE('6/3/2015','MM/DD/YYYY'), TO_DATE('8/2/2015','MM/DD/YYYY'), 'SUMMER');
INSERT INTO PLAYERROLE (PLAYER_ID, P_ROLE_ID, PROLE_STARTDATE, PROLE_ENDDATE, PROLE_SEASON) VALUES (2, 2, TO_DATE('6/3/2015','MM/DD/YYYY'), TO_DATE('9/28/2015','MM/DD/YYYY'), 'SUMMER');
INSERT INTO PLAYERROLE (PLAYER_ID, P_ROLE_ID, PROLE_STARTDATE, PROLE_ENDDATE, PROLE_SEASON) VALUES (1, 1, TO_DATE('6/3/2015','MM/DD/YYYY'), TO_DATE('7/14/2015','MM/DD/YYYY'), 'SUMMER');


SET SERVEROUTPUT ON;

BEGIN
DBMS_OUTPUT.PUT_LINE(RPAD('TABLE_NAME', 20));
DBMS_OUTPUT.PUT_LINE(RPAD('-----------', 20));
FOR I IN ( SELECT TABLE_NAME FROM USER_TABLES )
LOOP
DBMS_OUTPUT.PUT_LINE(RPAD(I.TABLE_NAME, 20));
END LOOP;
END;
/

SET SERVEROUTPUT ON;

BEGIN
DBMS_OUTPUT.PUT_LINE(RPAD('TABLE NAME', 20) || ' ' || RPAD('NUM ROWS', 10));
DBMS_OUTPUT.PUT_LINE(RPAD('-----------', 20) || ' ' || RPAD('----------', 10));
FOR I IN (
SELECT TABLE_NAME, NUM_ROWS
FROM USER_TABLES )
LOOP
DBMS_OUTPUT.PUT_LINE(RPAD(I.TABLE_NAME, 20) || ' ' || RPAD(I.NUM_ROWS, 10));
END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE SP_ROLE_INSERT (R_ID IN VARCHAR2, R_DESC IN VARCHAR2, R_LEVEL IN NUMBER)
IS
BEGIN
  INSERT INTO P_ROLE (P_ROLE_ID, P_ROLE_DESCRIPTION, P_ROLE_RISKLEVEL) VALUES (R_ID, R_DESC, R_LEVEL);
EXCEPTION
WHEN NO_DATA_FOUND THEN
NULL;
END;
/

DROP PROCEDURE SP_ROLE_INSERT;

CREATE OR REPLACE PROCEDURE SP_REFEREE_INSERT (REFR_ID IN VARCHAR2, REFR_FNAME IN VARCHAR2, REFR_LNAME IN NUMBER)
IS
BEGIN
  INSERT INTO REFEREE (REF_ID, REF_FNAME, REF_LNAME) VALUES (REFR_ID, REFR_FNAME, REFR_LNAME);
EXCEPTION
WHEN NO_DATA_FOUND THEN
NULL;
END;
/

DROP PROCEDURE SP_REFEREE_INSERT;
