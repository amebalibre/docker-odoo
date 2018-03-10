

### Entrar a un contenedor

docker exec -it odoo /bin/bash

> Añade el parámetro `-u 0`, o `-u root`, si deseas entrar como superusuario


# docker-compose.yml

### Añadir nuevos directorios de addons propios

Es posible añadir múltiples directorios de addons dentro de nuestro contenedor,
para ello sólo deberemos añadir en la sección de `volumes` una entrada con el
formato *nombre_directorio_en_mi_anfitrion:nombre_directorio_en_mi_contenedor*

*Ejemplo*:

```Makefile
volumes:
  - ./oca-addons:/mnt/oca-addons
```

> Esta instrucción generará dentro de nuestro contenedor la carpeta 
> `/mnt/oca-addons`, la cual contendrá todos los addons que insertemos en el
> directorio `./oca-addons` de nuestra máquina anfitriona.


### Logs

Los logs son arrojados sobre el fichero `/var/log/odoo/odoo-server.log` de
nuestro contenedor, esta ruta puede ser modificada gracias a la variable de 
entorno `ODOO_LOGFILE`.

*Ejemplo*:

```Makefile
environment:
  - ODOO_LOGFILE=/var/log/odoo/odoo-server.log
```

* Atención: Dicha ruta está hardcodeada dentro del fichero **odoo.conf**, será
necesario realizar la modificación dentro de nuestro fichero de configuración.

Si se desea mostrar los logs, se deberá ejecutar el siguiente comando

```sh
docker exec odoo tail -f /var/log/odoo/odoo-server.log
```



### Entrando por primera vez a Odoo

Los datos para la cuenta de administrador por defecto de una base de datos
autogenerada son:

* **Email**: admin
* **Password**: admin


