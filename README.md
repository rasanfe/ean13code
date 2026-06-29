# ean13code — Generar y leer códigos EAN-13 con PowerBuilder 🏷️

![PowerBuilder](https://img.shields.io/badge/PowerBuilder-2025-2D6CDF?style=flat-square)
![.NET](https://img.shields.io/badge/.NET-10-512BD4?style=flat-square&logo=dotnet&logoColor=white)
![ZXing](https://img.shields.io/badge/EAN--13-ZXing.Net-00A98F?style=flat-square)
![Blog](https://img.shields.io/badge/blog-rsrsystem-FF5722?style=flat-square&logo=blogger&logoColor=white)

## 📋 ¿Qué es esto?

Un ejemplo PowerBuilder para **generar y leer códigos de barras EAN-13**, el clásico de los
productos de supermercado (13 dígitos con su dígito de control). Le pasáis el número, os pinta el
código como imagen; y al revés, le dais una imagen y os devuelve los dígitos que lleva codificados.

La clave didáctica está en **cómo lo consigue PowerBuilder**: él solo no genera códigos de barras,
así que tira de .NET. Cargamos la librería .NET `ZxingBarcode` (que por debajo usa **ZXing.Net**)
como `dotnetobject` mediante el **.NET DLL Importer** de PB. Eso genera el objeto proxy
**`nvo_zxingnet`**, que desde PowerScript se usa como un objeto nativo más. Fijaos:

- **Generar** → `nvo_zxingnet.BarcodeGenerate(numero, fichero, 8, alto, ancho, false, margen)`.
  Ese `8` es el código del formato **EAN_13** dentro de la librería. Devuelve la ruta de la imagen.
- **Leer** → `nvo_zxingnet.ReadBarcode(fichero)` y os devuelve los dígitos del código (cadena
  vacía si no reconoce nada).

Todos los métodos devuelven `string` a propósito: si algo falla, PowerBuilder recibe el mensaje de
error como texto en vez de una excepción .NET que tendría que capturar.

## 🔗 Motor .NET

El trabajo de verdad lo hace la librería .NET **`ZxingBarcode`** (clase `ZxingNet`):

- Se **despliega** ya compilada en la carpeta `DotNet\ZxingBarcode\` de este propio ejemplo, para
  que clones, compiles y funcione sin tocar nada más.
- Se **consume** desde PowerBuilder como `dotnetobject` (el proxy `nvo_zxingnet`).
- El **código fuente** vive en `Blog\Net10\ZxingBarcode` (antes estaba en `Net8`) y se
  recompila/despliega con el script **`desplegar_dotnet.bat`** (hace `dotnet publish` y espeja las
  DLLs a la carpeta `DotNet` de cada ejemplo).
- Repo del proyecto .NET (Visual Studio 2022): <https://github.com/rasanfe/ZxingBarcode>

> 🔤 **Cambio de nombre (.NET 10):** la clase .NET pasó de `ZxingNet8` a `ZxingNet`, y el objeto
> PowerBuilder de `nvo_zxingnet8` a `nvo_zxingnet` (el "8" sugería .NET 8 y confundía). Recuerda
> **recompilar y volver a desplegar** la DLL de `ZxingBarcode`.

## 🛠️ Requisitos

- **PowerBuilder 2025** para abrir y compilar la solución.
- **.NET 10 Runtime** instalado en la máquina → <https://dotnet.microsoft.com/en-us/download/dotnet/10.0>
- La carpeta `DotNet\ZxingBarcode\` con las DLLs desplegadas (ya viene en el repo).

## ▶️ Cómo probarlo

1. Clona el repo y abre `app_ean13.pbsln` con PowerBuilder 2025.
2. Compila (Full Build) y ejecuta.
3. Introduce un número de 12-13 dígitos, genera el EAN-13 y míralo.
4. Usa la opción de lectura sobre la imagen y comprueba que recupera los dígitos.

## 🔗 Repo PowerBuilder

<https://github.com/rasanfe/ean13code>

---

> ¡Nos vemos en el próximo artículo! Y recuerda: en PowerBuilder, los límites solo están en nuestra imaginación. 🚀

📨 **Blog:** <https://rsrsystem.blogspot.com/>
