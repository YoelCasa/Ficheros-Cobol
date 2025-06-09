       PROGRAM-ID. Ficheros.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMPLEADOS-ARCHIVO
           ASSIGN TO
           "g:\Usuarios\empleados.csv"
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS FS-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  EMPLEADOS-ARCHIVO.
       01  EMPLEADOS-REGISTRO.
           05 EMPLEADOS-ID       PIC 9(5).
           05 EMPLEADOS-NOMBRE     PIC X(20).
           05 EMPLEADOS-APELLIDO1  PIC X(20).
           05 EMPLEADOS-APELLIDO2  PIC X(20).

       WORKING-STORAGE SECTION.
      *== Variables para los mensajes en pantalla ==
       01  identificador pic X(50) VALUE
           "Introduzca el identificador: ".
       01  nombre pic X(40) VALUE
           "Introduzca el nombre del empleado: ".
       01  apellido1 pic X(40) VALUE
           "Introduzca el primer apellido: ".
       01  apellido2 pic X(40) VALUE
           "Introduzca el segundo apellido: ".

      *== Variables de control del programa ==
       01  SI-NO                 PIC X VALUE SPACE.
       01  FS-STATUS             PIC X(2).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.

      * 1. Abrimos el fichero con la lógica correcta.
           PERFORM GESTIONAR-APERTURA.

      * 2. Preguntamos al usuario si quiere añadir registros en un bucle.
           DISPLAY "Desea insertar registros (S/N)?"
           ACCEPT SI-NO.

           PERFORM UNTIL SI-NO = "N" OR SI-NO = "n"
               PERFORM INSERTAR-REGISTROS
               DISPLAY "Desea insertar OTRO registro (S/N)?"
               ACCEPT SI-NO
           END-PERFORM.

      * 3. Cerramos el fichero y terminamos.
           PERFORM CERRAR-ARCHIVO.
           PERFORM FIN-PROGRAMA.


       GESTIONAR-APERTURA.
      * Intenta abrir para añadir al final (modo EXTEND).
           OPEN EXTEND EMPLEADOS-ARCHIVO.
      * Si falla porque el fichero no existe (STATUS 35)...
           IF FS-STATUS = "35"
      * ...entonces lo crea abriéndolo en modo OUTPUT.
               OPEN OUTPUT EMPLEADOS-ARCHIVO
           END-IF.
      * Si después de todo, el STATUS no es "00", hay un error grave.
           IF FS-STATUS NOT = "00"
               DISPLAY "Error fatal de fichero. STATUS: " FS-STATUS
               PERFORM FIN-PROGRAMA
           END-IF.


       INSERTAR-REGISTROS.
           DISPLAY identificador.
           ACCEPT EMPLEADOS-ID.
           DISPLAY nombre.
           ACCEPT EMPLEADOS-NOMBRE.
           DISPLAY apellido1.
           ACCEPT EMPLEADOS-APELLIDO1.
           DISPLAY apellido2.
           ACCEPT EMPLEADOS-APELLIDO2.


           WRITE EMPLEADOS-REGISTRO.


      * Comprobamos si la escritura ha sido correcta.
           IF FS-STATUS NOT = "00"
               DISPLAY "Error al escribir en el fichero. STATUS: "
               FS-STATUS
               PERFORM CERRAR-ARCHIVO
               PERFORM FIN-PROGRAMA
           ELSE
               DISPLAY "Registro guardado con exito."
           END-IF.


       CERRAR-ARCHIVO.
           CLOSE EMPLEADOS-ARCHIVO.

       FIN-PROGRAMA.
            STOP RUN.
       END PROGRAM Ficheros.
       
