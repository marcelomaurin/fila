SITE: http://maurinsoft.com.br/index.php/projeto-fila/

<h1>Portuguese:</h1>

<h2>Projeto Fila</h2>

Projeto simples para controle de fila.


Permite o controle de filas através de sistema simples de emissão de ticket.


Onde, é possível através de um terminal, pegar o próximo numero da fila.

Também existe um software, destinado a servir como painel de visualização dos tickets chamados.

<p>Assista o vídeo de como instalar e como funciona</p>


[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/wPoVD_J6qp4/0.jpg)](https://www.youtube.com/watch?v=wPoVD_J6qp4)




O Projeto Fila possui 3 software básicos:

<h3>São os softwares:</h3>

<ul>
<li>FILA – Emite o ticket de senha, além de possuir uma impressora térmica, tambem pode ser acoplado a um monitor touch screen.</li>
<li>Guiche – Instalado no terminal da pessoa que irá realizar o atendimento, pega o próximo número baseado na listagem armazenada no FILA.</li>
<li>Painel – Instalado em um tablet ou tv android, permite ler as informações do FILA.</li>
</ul>

<h1>English:</h1>
<h2>Fila Project</h2>
------------
Simple design for queue control.


It allows the control of queues through a simple ticketing system.


Where, it is possible through a terminal, to take the next number in the queue.

There is also a software, intended to serve as a display panel for tickets called.

The Fila Project has 3 basic software:

<h3>The softwares are:</h3>

<ul>
FILA - Issue the password ticket, in addition to having a thermal printer, it can also be coupled to a touch screen monitor.
Guiche - Installed in the terminal of the person who will perform the service, pick up the next number based on the list stored in FILA.
Panel - Installed on an android tablet or tv, it allows you to read the FILA information.
</ul>

<h1>Spanish:</h1>
<h2>Proyecto Fila</h2>
------------
Diseño simple para control de colas.


Permite el control de colas a través de un sencillo sistema de ticketing.


Donde, es posible a través de una terminal, tomar el siguiente número en la cola.

También hay un software, diseñado para servir como panel de visualización de los tickets llamados.

El Proyecto Fila tiene 3 software básico:

<h3>Los softwares son:</h3>

<ul>
FILA - Emite el ticket de contraseña, además de tener una impresora térmica, también se puede acoplar a un monitor de pantalla táctil.
Guiche - Instalado en el terminal de la persona que realizará el servicio, recoja el siguiente número en base a la lista almacenada en FILA.
Panel: instalado en una tableta o televisor Android, le permite leer la información de la FILA.
</ul>

## Building the Projects

### Lazarus Projects
The directories `Fila`, `Guiche` and `PainelDesk` each contain a Lazarus project
file (`*.lpi`). To build a project:

1. Open the `.lpi` file in the Lazarus IDE.
2. Ensure the required packages are installed.
3. Use **Run → Build** to compile the executable for your platform.

### Android Module
The Android client lives in `Painel/Painel_Laz`. Open this project with
[LAMW](https://github.com/jmpessoa/lazandroidmodulewizard) and use
**[LAMW] Build Android Apk and Run** (or the provided `gradlew`/`ant` scripts)
to create the APK.

### Pre‑built Binaries
Pre‑compiled releases are kept in the `bin` directory or may be distributed on
the project website.

## Text‑to‑Speech Server
The script `PainelDesk/srvfalar.py` provides optional text‑to‑speech support.
Install the Python requirements and run the server:

```bash
pip install -r requirements.txt
python PainelDesk/srvfalar.py
```

