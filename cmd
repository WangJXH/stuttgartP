#--- Bildschirmeldungen aus
scrmsg     on

#==============================================================================
#--- Problem einlesen & Netz erzeugen (Reihenfolge beachten!)
#==============================================================================

#--- Dreiecksnetz erzeugen in 3-d nicht moeglich
read 	2d_Symes.shape
read 	mesh/files/mesh_2dhole.nodes
read 	mesh/files/mesh_2dhole.elems
read 	mesh/files/mesh_2dhole.edges
read 	2d_Symes.ivars
read 	2d_Symes.param
read 	mesh/files/mesh_2dhole.elmat

#==============================================================================
#--- Matrixtyp, Vorkond. etc.
#==============================================================================

linear         set     matrix     CSR
linear         set     solver     GMRES


#==============================================================================
#--- allg. Parameter einstellen
#==============================================================================

#--- Flags setzen
set     bc     boundary

#--- Zeitintegration
dae     set     method     Euler

#--- DAE-Parameter
dae 	set hmin 		 1e-8
dae     set ncontrol     true  	  	# "Schrittweitensteuerung" Newton (ohne Fehlerschaetzung) [FALSE]
dae     set nstepmin     3        	# Minimalzahl Newtonschritte ->ncontrol [5]
dae     set nstepmax     25      	# Maximalzahl Newtonschritte ->ncontrol [10]
dae     set rtol         1e-4     	# Relative Toleranz fuer DAE-Loeser (fuer control=TRUE) [0.0001]
dae     set atol         1e6     	# Absolute Toleranz fuer DAE-Loeser (fuer control=TRUE) [0.0001]
                                               
#--- NEWTON-Parameter                          
newton  set numtan  false   # Tangente (Jacobi-Matrix) numerisch berechnen? (Nur im Notfall, da sehr langsam) [FALSE]
newton  set iter    100     # Max. Iterationszahl im Newton-Verfahren [10]
newton  set rtol    1e-3   	# Relative Toleranz fuer Newtonloeser (Residuum) [0.01]
newton  set atol    1e6     # Absolute Toleranz fuer Newtonloeser (Residuum) [0.0001]
newton 	set lkappa 	0.1	    # newton.atol * newton.lkappa <= dae.atol !


#--- NEWTON-Parameter: Vereinfachtes Newton
newton     set     simp     FALSE


#==============================================================================
#--- Datenausgabe
#==============================================================================

#--- Ausgabe-Kante (Randintegral)
set     outedge 1
set     outeneg false
set     outevar TSE22


#--- Ausgabe im Tecplot-Format (./tec/*.dat)
set     quadtec FALSE
set     gziptec FALSE 
set     tecout  TRUE
set     tecsave 0.0e+0       	    		 # = 0.0 -> jeden Zeitschritt speichern

#--- Ausgabe des Residuums und der Jacobimatrix nach jedem Zeitschritt
set     outres     FALSE
set     outjac     FALSE


#==============================================================================
#--- Berechnungen
#==============================================================================


dae     set h0           0.1     # Anfangsschrittweite
dae     set hmax         1

#==============================================================================
#--- Berechnung 1 Initiierung
#==============================================================================

#==============================================================================
#--- Berechnung 1 Initiierung
#==============================================================================

init    10
go

#==============================================================================
#--- Berechnung 2 Verschiebung
#==============================================================================

init    100
go

#==============================================================================
#--- Berechnung 3 Fluss
#==============================================================================

init    150
go

#--- Status speichern
save     final
writetec     tec/tecplot_final.dat

#--- PANDAS-Ende
quit
