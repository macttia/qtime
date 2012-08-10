	#!/bin/bash
	#
	#
	###########################################
	###########################################
	# Qtime					 ##
	#					 ##
	# Desarrollado para registrar 		 ##
	# actividades diarias.			 ##
	#					 ##
	# Autor: Matias Monteverde Giannini	 ##
	#	 Next2Code - N2C		 ##
	#					 ##
	###########################################
	#
	#Variables
	YY=`date +"%Y"`
	hoy=`date +"%Y-%m-%d"`
	. /home/users/mat/qtime/include/auth
	
	search(){
	clear
	echo " ================"
	echo "| Search Custom  |"
	echo " ================"
	echo
	echo -n "Patron de busqueda: "
	read patt
	#	if [ -z $patt  ]; then
	 
	echo
	mysql -u$userdb -p$passdb qtime -e  "SELECT id, fecha,tag,concepto,tiempo FROM registros WHERE fecha LIKE '%$patt%' OR concepto LIKE '%$patt%' OR tag LIKE '%$patt%' ORDER by fecha,tag" 
	echo
	echo
	mysql -u$userdb -p$passdb qtime -e "select sum(tiempo) as 'Tiempo TOTAL (hrs.)' from registros WHERE fecha LIKE '%$patt%' OR concepto LIKE '%$patt%' OR tag LIKE '%$patt%' ORDER by fecha"

	read any
	}

	################
	### Informes ###
	################

	reporte_menu()
	{
	while :
	do
	clear
	echo " ----------------------"
	echo "|      Qtime v1.1      |"
	echo "|----------------------|"
	echo "|   Tipos de Reporte   |"
	echo " ----------------------"
	echo "[d]   Diario           |"
	echo "[s]   Semanal          |"
	echo "[m]   Mensual          |"
	echo "[p]   Proyectos        |"
	echo "[q]   Salir            |"
	echo "======================="
	echo
	echo -n  "Seleccione una opcion [d,s,m,q]:  "
	read TR
	case $TR in
	d) reporte_d ;;
	s) reporte_s ;;
	m) reporte_m ;;
	p) reporte_p ;;
	q) menu ;;
	*) dialog --title "Warning !!" --backtitle "Qtime" --msgbox "Lo sentimos!!! Debe elegir algunas de las alternativas enunciadas.  Presione cualquier tecla...
	para salir del aviso" 9 50 ;;

	esac
	done
	}

	########################
	### reporte del dia  ###
	########################
	reporte_d(){
	clear
	echo " ================="
	echo "| Reporte Diario  |"
	echo " ================="
	echo
	echo -n "Patron de busqueda: "
	dia=`mysql -s -u$userdb -p$passdb qtime -e "select curdate()"|grep $YY`
	echo "Fecha : "$dia
	echo
	mysql -u$userdb -p$passdb qtime -e  "SELECT fecha, tag, concepto, tiempo FROM registros WHERE fecha='$dia'"
	echo
	echo
	mysql -u$userdb -p$passdb qtime -e  "SELECT tag,sum(tiempo) as 'Tiempo (hrs.)' FROM registros WHERE fecha='$dia' group by tag"
	echo
	mysql -u$userdb -p$passdb qtime -e "select sum(tiempo) as 'Tiempo TOTAL (hrs.)' from registros where fecha='$dia'"
	echo
	echo
	read any
	}

	########################
	### reporte semanal  ###
	########################
	reporte_s(){
	clear
	echo " ================="
	echo "| Reporte Semanal |"
	echo " ================="
	echo
	echo -n "Mes (01-12): "
	read mes

	cal -m $mes `date +"%Y"`
	#cal -m$mes 
	echo
	echo -n "Dia Inicio (01-31): "
	read dia_i
	echo
	echo -n "Dia Termino (01-31): "
	read dia_t
	echo
	echo "Periodo: "$YY-$mes-$dia_i" - "$YY-$mes-$dia_t
	echo
	mysql -u$userdb -p$passdb qtime -e  "SELECT id, fecha,tag,concepto,tiempo FROM registros WHERE fecha between '$YY-$mes-$dia_i' and '$YY-$mes-$dia_t' ORDER by fecha,tag" 
	echo
	mysql -u$userdb -p$passdb qtime -e  "SELECT fecha, sum(tiempo) as 'Tiempo (hrs.)', tag FROM registros WHERE fecha between '$YY-$mes-$dia_i' and '$YY-$mes-$dia_t' group by tag order by fecha" 
	echo
	mysql -u$userdb -p$passdb qtime -e "SELECT sum(tiempo) as 'Tiempo TOTAL (hrs.)' from registros where fecha between '$YY-$mes-$dia_i' and '$YY-$mes-$dia_t'"
	echo
	echo
	read any
	}

	########################
	### reporte del mes  ###
	########################
	reporte_m(){
	clear
	echo " ================="
	echo "| Reporte Mensual |"
	echo " ================="
	echo
	echo -n "Patron de busqueda: "
	YY="2012"
	echo -n "Mes (01-12): "
	read mes
	echo "Fecha : "$YY-$mes
	echo
	mysql -u$userdb -p$passdb qtime -e  "SELECT tag,sum(tiempo) as 'Tiempo (hrs.)' FROM registros WHERE fecha like '%$YY-$mes%' group by tag" 
	echo
	mysql -u$userdb -p$passdb qtime -e "select sum(tiempo) as 'Tiempo TOTAL (hrs.)' from registros where fecha like '%$YY-$mes%'"
	echo
	echo
	read any
	}

	#######################################
	### reporte actividad del proyecto  ###
	#######################################
	reporte_p(){
	clear
	echo " ============================"
	echo "| Reporte Total del Proyecto |"
	echo " ============================"
	echo
	echo -n "Patron de busqueda: "
	YY="2012"
	echo -n "Codigo: "
	read proj
	echo
	mysql -u$userdb -p$passdb qtime -e  "SELECT id, fecha,tag,concepto,tiempo FROM registros WHERE fecha LIKE '%$proj%' OR concepto LIKE '%$proj%' OR tag LIKE '%$proj%' ORDER by fecha,tag" 
	echo
	echo
	mysql -u$userdb -p$passdb qtime -e "select sum(tiempo) as 'Tiempo TOTAL (hrs.)' from registros WHERE fecha LIKE '%$proj%' OR concepto LIKE '%$proj%' OR tag LIKE '%$proj%' ORDER by fecha"
	echo
	read any
	}

	#############################
	## nuevo registro custom ####
	#############################
	new_custom(){
	clear
	echo " ==========================="
	echo "|   Nuevo Registro Especial |"
	echo " ============================"
	echo
	echo
	echo -n "Fecha (yyyy-mm-dd): "
	read fecha_tmp
	fecha="'$fecha_tmp'"
	echo
	echo -n "Concepto: "
	read concepto
	echo
	echo -n "Tiempo: "
	read tiempo
	echo
	tg1
	}


	###########################
	## nuevo registro  OTRO ###
	###########################
	otro(){
	fecha=`date +"%Y-%m-%d"`
	clear
	echo " ======================="
	echo "| Nuevo Registro Otros  |"
	echo " ======================="
	echo 
	echo "[1]  Vacaciones"
	echo "[2]  Bajas"
	echo "[3]  Cursos"
	echo "[4]  Otros"
	read otroV
		if [ $[otroV] -eq 1 ]; then
			concepto='Vacaciones'
		elif [ $[otroV] -eq 2 ]; then
			concepto='Bajas'
		elif [ $[otroV] -eq 3 ]; then
			concepto='Cursos'
		elif [ $[otroV] -eq 1 ]; then
			echo 'Concepto: Otro ...:'
			read concepto
	
		else
		otro
	fi

	echo
	echo -n "Tiempo: "
	read tiempo
	echo
	mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,$concepto,$tiempo,'Otros')"
	}
	

	#################################
	###  Nuevo Registro Proyecto  ###
        #################################
	
	prj(){
	fecha=`date +"%Y-%m-%d"`
	echo " --------------------------------------------"
	echo "|               Qtime v1.1                   |"
	echo "|--------------------------------------------|"
	echo "|         Nuevo Registro Prooyecto           |"
	echo " --------------------------------------------"
	echo "[1]  7980: Estudio                           |"
	echo "[2]  7982: Gestion del proyecto              |"
	echo "[3]  7983: Peticion Ultimus                  |"
	echo "[4]  7984: Instalacion Oracle                |"
	echo "[5]  7985: Instalacion WAS                   |"
	echo "[6]  7986: Instalacion SAS                   |"
	echo "[7]  7987: Puesta en produccion              |"
	echo "[8]  7988: Documentacion CPLAN - Pruebas     |"
	echo "============================================="
	echo -n "Seleccione una Fase: [1-8]  "
	read proj
		if [ $proj -eq 1 ]; then
			concepto="7980: Estudio"
		elif [ $proj -eq 2 ]; then
			concepto="7982: Gestion del proyecto"
		elif [ $proj -eq 3 ]; then
			concepto="7983: Peticion Ultimus"
		elif [ $proj -eq 4 ]; then
			concepto="7984: Instalacion Oracle"
		elif [ $proj -eq 5 ]; then
			concepto="7985: Instalacion WAS"
		elif [ $proj -eq 6 ]; then
			concepto="7986: Instalacion SAS"
		elif [ $proj -eq 7 ]; then
			concepto="7987: Puesta en produccion"
		elif [ $proj -eq 8 ]; then
			concepto="7988: Documentacion CPLAN - Pruebas"
		else

	echo "Opcion inexsistente, debe elegir entre 1 - 8"
	prj

		fi

	echo
	echo -n "Tiempo: "
	read tiempo
	echo
	mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Proyecto-7978')"
	}

	cdia(){
	unset fecha
	clear
	echo " =============================="
	echo "| Nuevo Registro Custom diario |"
	echo " =============================="
	echo
	echo -n "Fecha de hoy? (S/n) "
	read Cfecha
		if [ $Cfecha == "n" ] ; then
			echo -n "Fecha (yyyy-mm-dd): "
			read fecha_tmp
			fecha=`echo $fecha_tmp`
		elif [ $Cfecha == "N" ]; then
			echo -n "Fecha (yyyy-mm-dd): "
			read fecha_tmp
			fecha=`echo $fecha_tmp`
	
	fi
	fecha="now()"
	echo -n "Concepto: " 
	read concepto
	echo
	echo -n "Tiempo: "
	read tiempo
	echo
	echo -n "Tag :"
	read tag2
	echo
        mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('','$fecha','$concepto','$tiempo','$tag2')"
	}
	

	rtball(){
	fecha="now()"
	clear
	echo " ====================="
	echo "| Nuevo Registro RTB  |"
	echo " ====================="
	echo
	echo -n "Concepto: "
	read concepto
	echo
	echo -n "Tiempo: "
	read tiempo
	echo
	tg1
	}

	tg1()
	{
	echo "[1]  GIC"
	echo "[2]  PAI"
	echo "[3]  RTB"
	echo
	echo -n "Seleccione TAG de las opciones [1-3]: "
	read tag1

		if [ $[tag1] -eq 1 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','GIC')"
		elif [ $[tag1] -eq 2 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','PAI')"
		elif [ $[tag1] -eq 3 ]; then
			rtb
		else
	 
	 dialog --title "Warning !!" --backtitle "Qtime" --msgbox "Lo sentimos!!! Por favor, elija una de las siguientes alternativas: 1-3.  Presione cualquier tecla
	 para salir del aviso" 9 50
	 
	 fi
	 menu
	 }
	 

	rtb()
	{
	echo " --------------------------------------------------------------------------------------------"
	echo "|                                           TAG                                              |"
	echo "|--------------------------------------------------------------------------------------------|"
	echo "[1]  Revision y correcion de alarmas                                                         |"
	echo "[2]  Reuniones Interna                                                                       |"
	echo "[3]  Gestion del buzon de servicio                                                           |"
	echo "[4]  Reuniones con Cliente                                                                   |"
	echo "[5]  Revision recusos / estado de Sistema (logs, tablespace, CPU, disco, procesos, usuarios) |"
	echo "[6]  Actualizacion documentacion interna                                                     |"
	echo "[7]  Actualizacion documentacion servicio                                                    |"
	echo "[8]  Gestion de cadenas (Revision, creacion, modificacion y eliminacion)                     |"
	echo "[9]  Revision estado backups (Sistemas y BBDD)                                               |"
	echo "[10] CPLAN (Revision Plan contingencia, mantencion documentacion CPLAN, soporte CPLAN)       |"
	echo "[11] Soporte desarrollo aplicaciones                                                         |"
	echo "[12] Definicion / modificacion nuevas alertas                                                |"
	echo "[13] Elaboracion Plan de capacidad / RSI                                                     |"
	echo "[14] Elaboracion de Quadres Comanament                                                       |"
	echo "[15] Gestion de la planificacion                                                             |"
	echo "[16] Planes de recuperacion de servidores                                                    |"
	echo "[17] Revision / Actualizacion Sistema                                                        |"
	echo "     (Update OS,Licencias Productos,update productos,vulnerabilidades,menu oper)             |"
	echo "[18] Revision certificados                                                                   |"
	echo "[19] Checklist matinal                                                                       |"
	echo "[20] Tunning de aplicaciones                                                                 |"
	echo "[21] Validacion informacion replica de discos                                                |"
	echo "============================================================================================="
	echo -n "Seleccione TAG de las opciones [1-21]: "
	read tag

		if [ $[tag] -eq 1 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Revision y correcion de alarmas')"
		elif [ $[tag] -eq 2 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Reuniones Interna')"
		elif [ $[tag] -eq 3 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Gestion del buzon de servicio')"
		elif [ $[tag] -eq 4 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Reuniones con Cliente')"
		elif [ $[tag] -eq 5 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Revision recusos / estado de Sistema (logs, tablespace, CPU, disco, procesos, usuarios)')"
		elif [ $[tag] -eq 6 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Actualizacion documentacion interna')"
		elif [ $[tag] -eq 7 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Actualizacion documentacion servicio')"
		elif [ $[tag] -eq 8 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Gestion de cadenas (Revision, creacion, modificacion y eliminacion)')"
		elif [ $[tag] -eq 9 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Revision estado backups (Sistemas y BBDD)')"
		elif [ $[tag] -eq 10 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','CPLAN')"
		elif [ $[tag] -eq 11 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Soporte desarrollo aplicaciones')"
		elif [ $[tag] -eq 12 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Definicion / modificacion nuevas alertas')"
		elif [ $[tag] -eq 13 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Elaboracion Plan de capacidad / RSI')"
		elif [ $[tag] -eq 14 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Elaboracion de Quadres Comanament')"
		elif [ $[tag] -eq 15 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Gestion de la planificacion')"
		elif [ $[tag] -eq 16 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Planes de recuperacion de servidores')"
		elif [ $[tag] -eq 17 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Revision / Actualizacion Sistema')"
		elif [ $[tag] -eq 18 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Revision certificados')"
		elif [ $[tag] -eq 19 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Checklist matinal')"
		elif [ $[tag] -eq 20 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Tunning de aplicaciones')"
		elif [ $[tag] -eq 21 ]; then
			mysql -u$userdb -p$passdb qtime -e "INSERT INTO registros Values ('',$fecha,'$concepto','$tiempo','Validacion información replica de discos')"
		else

	dialog --title "Warning !!" --backtitle "Qtime" --msgbox "Lo sentimos!!! Por favor, elija una de las siguientes alternativas: 1-21.  Presione cualquier tecla...
	para salir del aviso" 9 50 
	new
	fi
	menu
	}


	##############
	### Delete ###
	##############
	del(){
	clear
	echo " =========="
	echo "|  Delete  |"
	echo " =========="
	echo
	echo -n "Busqueda de registro a eliminar: "
	read sdel
	clear
	echo -n "Cual deseas borrar ?"
	echo
	mysql -u$userdb -p$passdb qtime -e "SELECT id,fecha,concepto,tag from registros  WHERE fecha LIKE '%$sdel%' OR concepto LIKE '%$sdel%' OR tag LIKE '%$sdel%' order by fecha asc"
	echo
	echo -n "Id No.: "
	read ID
	DELid=`mysql -u$userdb -p$passdb qtime -e "SELECT fecha, concepto from registros  WHERE id='$ID'"`

		if [ -z "${DELid}" ]; then
	echo
	echo "ID = $ID no existe en la BBDD, no puede ser borrada."
	echo
	read aa
	del
		fi
	mysql -u$userdb -p$passdb qtime -e "DELETE from registros WHERE id='$ID'" 

	}

	backup(){
	echo -n "Making backup ..."
	sleep 2
	echo
mysqldump -v --add-drop-table -C -u$userdb -p$passdb qtime > $HOME/qtime/backup/mac_`date +"%Y-%m-%d"`_qtime_bkp.sql
}
#################
### Main menu ###
#################
menu(){
unset fecha
while :
do
clear
echo " -------------------------------"
echo "|          Qtime v1.1           |"
echo "|-------------------------------|"
echo "|          Main Menu            |"
echo " -------------------------------"
echo "[r]   RTB                       |"
echo "[p]   Proyectos                 |"
echo "[o]   Otro                      |"
echo "[c]   Custom Dia                |"
echo "[i]   Informes                  |"
echo "[b]   Busqueda                  |"
echo "[e]   Eliminar registro         |"
echo "[q]   Salir                     |"
echo "[C]   Agregar registro especial |"
echo "--------------------------------|"
echo "[99]  BACKUP BBDD               |"
echo "================================"
echo -n "Seleccione una opcion: "
read men
echo
echo
case $men in
r) rtball ;;
p) prj ;;
o) otro ;;
c) cdia ;;
i) reporte_menu ;;
b) search ;;
e) del ;;
q) exit 0 ;;
C) new_custom ;;
99) backup ;;
#*) echo "Lo sentimos!!! Debe elegir algunas de las alternativas enunciadas.  Presione INTRO" 9 50 ;;

esac
done
}
#################################################

menu
