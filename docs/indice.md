---
layout: default
---

**Harbour para la web ya está aquí**. Nos ha llevado años **entender lo que realmente necesitamos** y **cómo implementarlo**. Pero el momento de Harbour para web, el **momento web para los desarrolladores xbase**, finalmente ha llegado**.

**mod Harbour** es un **módulo de extensión** para **Apache**, el cual provee soporte completo a **ejecutar ficheros PRG y HRB desde la web**.

Si sois **desarrolladores Windows**, podéis construir un servidor web **en vuestros Windows 10** y entonces de una manera muy simple **ejecutar vuestros PRGs en Edge o Chrome** potenciado por **Apache en Windows 10 bash** usando la **extensión mod_harbour**. Cuando todo esté preparado, simplemente llevad **vuestros PRGs** a vuestros **servidores web Linux/Windows dedicados** dónde podéis instalar la extensión **mod_harbour para Apache**. 

## Soporte para bash en Windows 10

**Windows 10 WSL** (Windows SubSystem para Linux) os permite usar Ubuntu 18.04 (alrededor de 200 mb) desde vuestros Windows 10 bash e instalar un servidor Apache/MySQL(MariaDB) en él. **Instrucciones detalladas** se proporcionan en el [wiki del repositorio de mod_harbour](https://github.com/FiveTechSoft/mod_harbour/wiki). Usad **Windows 10 para desarrollar** vuestras aplicaciones web Harbour.

## Soporte para OSX

La extensión mod_harbour está **ya disponible** en [Macs](https://github.com/FiveTechSoft/mod_harbour/tree/master/osx)
Con un **instalador muy fácil de usar** que configura todo por vosotros.

## Soporte para Linux

Existe versión del **mod_harbour** para los sabores de Linux **Ubuntu** y **CentOS 7**. Usad Ubuntu desde vuestros Windows 10 bash, codificad vuestros  PRGs desde
Windows 10 **usando vuestro editor de código fuente favorito** y ejecutad los PRGs desde **Edge o Chrome**. Los servidores Apache y MySQL(MariaDB) de Ubuntu/CentoOS os darán todo lo que neceitáis. El **entorno perfecto** para la creación de apliaciones Web usando Harbour en un **tiempo record**.

```c
// típico PRG Harbour ejecutándose en la web
#xcommand ? <cText> => AP_RPuts( <cText> )

function Main()

   ? "Hello world"
   
return nil   
```

### Soporte para DBFs

Tened vuestras **DBFs corriendo en la web** en **tiempo record**. Simplemente copiadlas a /var/www/test en el servidor Apache, poned los **permisos adecuados** a la carpeta test y ya está todo preparado para probarlo. Por favor, leed las **instrucciones detalladas** [aquí](https://github.com/FiveTechSoft/mod_harbour/wiki/Using-DBFs-from-the-server). Por favor revisad los ejemplos samples/dbedit.prg y dbrowse.prg y **usadlos como plantillas**.

### Soporte para MySQL/MariaDB

Si preferís usar **MySQL o MariaDB** entonces mod_harbour **tiene todo lo que necesitáis** para ello. Por favor revisad el ejemplo samples/mysql.prg para un **ejemplo completo** que podéis usar como plantilla.

### Soporte para funciones del API de Apache

mod_harbour os proporciona una forma fácil de usar funciones que entrega todo el **poder del API de Apache** a vuestras aplicaciones. Comprobad la **IP de usuario**, comprobad si el usuario está haciendo **GET o POST**. Recuperad los **parámetros proporcionados** desde el navegador, y mucho más... Revisad los ejemplos en [samples](https://github.com/FiveTechSoft/mod_harbour/tree/master/samples) y comenzad a desarrollad vuestras aplicaciones web **usando Harbour**!

**Estáis preparados** para esta tan esperada **revolución** ? **Uníos y ayudad** a hacer este **sueño realidad** !!!

