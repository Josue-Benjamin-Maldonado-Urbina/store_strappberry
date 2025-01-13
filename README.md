Flutter Shopping App
Este es un proyecto de una aplicación de compras hecha en Flutter. Permite a los usuarios explorar productos, agregarlos al carrito, marcarlos como favoritos, y gestionar productos desde un panel de administrador.

🚀 Características
🎨 Interfaz de usuario intuitiva y moderna.
🛍️ Gestión de carrito de compras con animaciones de compra.
❤️ Posibilidad de marcar productos como favoritos.
🔑 Sistema de inicio de sesión y cierre de sesión.
📋 Panel de administrador para agregar, editar y eliminar productos.
🌐 Filtros de productos por categorías.


📋 Requisitos previos
Antes de comenzar, asegúrate de tener instalado lo siguiente:

Flutter SDK (versión estable recomendada).
Dart SDK (generalmente incluido con Flutter).
Un editor de texto o IDE como Visual Studio Code o Android Studio.
Un dispositivo físico o emulador configurado para pruebas.

🛠️ Instalación
Clonar el repositorio
- git clone https://github.com/Josue-Benjamin-Maldonado-Urbina/store_strappberry.git 
- cd store_strappberry

Instala las dependencias de Flutter:
flutter pub get

Conecta un dispositivo o inicia un emulador:
- Para dispositivos físicos, habilita la depuración USB.
- Para un emulador, inicia uno desde Android Studio o usa el comando:
  - flutter emulators --launch <NOMBRE-DEL-EMULADOR>

Ejecuta la aplicación:
- flutter run

🧰 Dependencias principales
Estas son las principales dependencias utilizadas en el proyecto:

flutter/material.dart: Paquete principal para el diseño de Material.
image_picker: Para cargar imágenes desde la galería del dispositivo.
path_provider: Manejo de rutas para almacenamiento de datos.
Consulta el archivo pubspec.yaml para ver la lista completa de dependencias.

📂 Estructura del proyecto
lib/
├── data/                    # Gestión de datos y repositorios
├── presentation/            # Interfaces de usuario y widgets
│   ├── pages/               # Páginas principales (CustomerPage, AdminPage, etc.)
├── main.dart                # Punto de entrada principal de la aplicación

