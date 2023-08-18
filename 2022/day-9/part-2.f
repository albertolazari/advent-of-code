      MODULE M KNOT
        TYPE KNOT
          INTEGER ROW, COL
        END TYPE
      END MODULE

      SUBROUTINE MOVE HEAD (HEAD, DIRECTION)
        USE M KNOT

        TYPE (KNOT) HEAD
        CHARACTER DIRECTION

        IF (DIRECTION .EQ. 'U') THEN
          HEAD%ROW = HEAD%ROW - 1
        ELSE IF (DIRECTION .EQ. 'D') THEN
          HEAD%ROW = HEAD%ROW + 1
        ELSE IF (DIRECTION .EQ. 'R') THEN
          HEAD%COL = HEAD%COL + 1
        ELSE IF (DIRECTION .EQ. 'L') THEN
          HEAD%COL = HEAD%COL - 1
        END IF
      END

      SUBROUTINE FOLLOW (SELF, OTHER)
        USE M KNOT

        TYPE (KNOT) SELF, OTHER

C IF TOUCHING DO NOTHING
        IF ((ABS (OTHER%COL - SELF%COL) .LE. 1) .AND.
     +      (ABS (OTHER%ROW - SELF%ROW) .LE. 1)) RETURN

C IF THEY ARE ON SAME ROW/COL THE OTHER IS TOO FAR
        IF (.NOT. (SELF%COL .EQ. OTHER%COL))
     +    SELF%COL = SELF%COL + SIGN (1, OTHER%COL - SELF%COL)
        IF (.NOT. (SELF%ROW .EQ. OTHER%ROW))
     +    SELF%ROW = SELF%ROW + SIGN (1, OTHER%ROW - SELF%ROW)
      END

      PROGRAM DAY9 PART1
        USE MKNOT
C VARIABLES DECLARATION
***********************
C "512 OUGHT TO BE ENOUGH"
        PARAMETER (MAP SIZE = 512)
        INTEGER MAP(MAP SIZE, MAP SIZE), I, J, K

        TYPE (KNOT) KNOTS(10)

C INPUT VARIABLES
        CHARACTER DIRECTION
        INTEGER STEPS

        INTEGER POSITIONS

C VARIABLES INITIALIZATION
**************************
C INITIALIZE MAP
        DO 20 I = 1, MAP SIZE
          DO 10 J = 1, MAP SIZE
            MAP(I, J) = 0
   10     CONTINUE
   20   CONTINUE
C INITIALIZE HEAD IN THE CENTER OF THE MAP
        KNOTS(1)%COL = MAP SIZE / 2
        KNOTS(1)%ROW = KNOTS(1)%COL
C HEAD AND OTHER KNOTS START FROM THE SAME POSITION
        DO 21 K = 2, 10
          KNOTS(K) = KNOTS(K - 1)
   21   CONTINUE

C MAIN READ LOOP
        DO
          READ (*, *, END = 30) DIRECTION, STEPS
          DO 25 I = 1, STEPS
            CALL MOVE HEAD (KNOTS(1), DIRECTION)
            IF ((KNOTS(1)%COL .LE. 0) .OR.
     +          (KNOTS(1)%COL .GT. MAP SIZE) .OR.
     +          (KNOTS(1)%ROW .LE. 0) .OR.
     +          (KNOTS(1)%ROW .GT. MAP SIZE))
     +        PRINT *, 'ERROR: HEAD OUT OF BOUNDS'
            DO 23 K = 2, 10
              CALL FOLLOW (KNOTS(K), KNOTS(K - 1))
   23       CONTINUE

            MAP(KNOTS(10)%ROW, KNOTS(10)%COL) = 1
   25     CONTINUE
        END DO

C COMPUTE RESULT
   30   POSITIONS = 0

        DO 50 I = 1, MAP SIZE
          DO 40 J = 1, MAP SIZE
            POSITIONS = POSITIONS + MAP(I, J)
   40     CONTINUE
   50   CONTINUE

        WRITE (*, '(I0)') POSITIONS

        STOP
      END
