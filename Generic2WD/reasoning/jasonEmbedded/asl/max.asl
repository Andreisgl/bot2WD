/* Initial beliefs and rules */
serialPort(ttyUSB0).
/* Initial goals */
!start.

/* Plans */
+!start: serialPort(SerialPort) <- 
    .print("I am Max the Road Warrior!"); 
    .argo.port(SerialPort);
	.argo.limit(1000);
    .argo.percepts(open).

+!rollOut <- .argo.act(buzzerOn); .wait(200);.argo.act(buzzerOff); .wait(200); .argo.act(lightOn); .wait(200); .argo.act(breakLOn); .wait(200); .argo.act(speedH); .wait(200); !!decide.

+!decide: luminosity(Lu) & Lu<900 & distance(D) & D > 30 <- !run; !!decide.
+!decide: luminosity(Lu) & Lu<900 & distance(D) & D <= 30 <- !buzzer; !stop; !!decide.
+!decide: luminosity(Lu) & Lu>900 <- !stop; !!decide.
-!decide <- .wait(1000); !!decide.

+!run: not motor(running) <- .argo.act(breakLOff); .wait(500); .argo.act(alertOn); .wait(500); .argo.act(goAhead); .wait(500).
+!run: motor(running).

+!buzzer <- .argo.act(buzzerOnH); .wait(1000);.argo.act(buzzerOff); .wait(500).

+!stop: not motor(stopped) <- .argo.act(stop); .wait(500); .argo.act(flashLightOff); .wait(500); .argo.act(breakLOn); .wait(500).
+!stop: motor(stopped).


+luminosity(Lu) <- .print("Luminosity Status -> ",Lu).
+flashLight(FL) <- .print("FlashLight Status -> ",FL).
+distance(D)    <- .print("Distance Status -> ",D).
+breakL(BL)     <- .print("Break Light Status -> ",BL).
+buzzer(B)      <- .print("Buzzer Status -> ",B).
+lineL(LL)      <- .print("Line-following Left Status -> ",LL). 
+lineR(LR)      <- .print("Line-following Right Status -> ",LR).
+motor(M)       <- .print("Motor Status -> ",M).
+light(L)       <- .print("Light Status -> ",L).
+speed(S)       <- .print("Speed Status -> ",S).  

+port(P,S): (S=off | S=timeout) & serialPort(SP) & P=SP <- 
    .print("Serial Port ",SP, " is ",S,"!");
    .stopMAS.                                         

+port(P,S): (S=on) <- 
    .print("Autobots Roll out!!!");
    !rollOut.