# HackerBooks Questions 

- isKindOfClass: ¿En qué otros modos podemos trabajar?¿is, as?

Según he entendido, *is* sería un tipo de checkeo como *isKindOfClass*, mientras que *as* se usa más para realizar casting

- ¿Donde guardarías las imágenes de portada y los pdfs?

Lo correcto es en la sandbox, y ya dependería de la persistencia a desear, ya que la carpeta temp o en la cache, estos archivos podrían ser borrados sin previo aviso por el sistema.  

Yo he usado la carpeta de Documentos, cuya persistencia es controlada.

- ¿Como harías que persistiera la información de isFavorite?¿Se te ocurre más de una forma de hacerlo?. Explica la decisión de diseño que hayas tomado

Yo he optado por añadir un Tag con esta información en el libro, y, por tanto, pasa a formar parte del array de Tags, guardándose en el mismo sitio que el JSON, en el NSUsersDefaults.

- ¿Como enviarías la imagen de un AGTBook a un AGTLibraryTableViewController? ¿Se te ocurre más de una forma de hacerlo?¿Cual te parece mejor?

Con el protocolo del delegado o con una notificación. La opción del delegado es más específica.

- Usar el método reloadData de UITableView ¿Es una aberración desde el punto de rendimiento?¿Hay una forma alternativa?¿Cuando crees que vale la pena usarlo?

El reloadData no carga toda la información, sino solamente la que se encuentra en pantalla. Yo lo veo muy apropiado cuando tienes que actualizar un gran número de datos. 

Opción alternativa ... pues ... he visto que existen reloadSections y reloadItemsAtIndexPaths, que parece una actualización mas detallada de ciertos datos

- ¿Como actualizarías el PDFViewController al cambiar en la tabla el libro seleccionado?

Pues aquí lo hemos hecho con una notificación, porque creo que los controladores de la librería y del libro no son accesibles.

