# Signal Analysis

Project created by Maciej Matusiak. This application was designed and created as a part of academic programming classes in 2023. The application determines the distance from the obstacle using the received time that the signal needed to travel a given distance. The program also determines the SNR value and displays it along with the distance to the obstacle. In this implementation, they have been designed and presented with the possibility of modification:

- Time of delay in milliseconds,
- Type of function used to create the signal,
<br >

![MainWindow](https://user-images.githubusercontent.com/98715325/220991287-0b4788aa-e76c-430f-b320-75ddf4d9dfdf.png)

<br >

After selecting from the list, the type of function by which the signal will be created and declaring the delay time, three graphs are displayed for the user. The first graph shows the time characteristics of the signal that has been sent. The second shows the signal also received in the time characteristic. The signal distortion that can be seen in the graph of the received signal is caused by environmental interference that has affected the signal. In the presented algorithm, white noise with a variance of σ=0.01 has been added. The third graph shows the correlation of signals by means of which the distance to the obstacle is determined using the formula 
s = (v*t)/2 , where:
-	v -> wave speed,
-	t -> time between sending and receiving the signal,
-	s -> the distance we want to determine,
<br >

![SinWindow](https://user-images.githubusercontent.com/98715325/221000315-fab29e3a-4d01-41fd-82d9-7329f361a05f.png)

<br >

![ChirpWindow](https://user-images.githubusercontent.com/98715325/221000322-ed9b08e9-bbf9-424a-8ad1-78205c9ab4eb.png)

<br >

With this simple implementation, the user can compare signal characteristics and the effect of noise on distance measurement accuracy. Using the calculated SNR, the user can compare the ratio of ambient interference to the signal that has been transmitted and how the signal characteristics affect the SNR values.


### Sources:

- https://uk.mathworks.com/help/signal/ref/snr.html
- https://uk.mathworks.com/help/stats/corr.html?s_tid=doc_ta
