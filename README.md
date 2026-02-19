Obs:
Agora o arquivo do banco está dentro da pasta DATABASE no projeto.

Na classe banco_connection tem a seguinte parte:
##_______________________________________________
Future<Database> _initDatabase() async {
    String path;

    if (Platform.isWindows) {
      path = r'C:\temp\CrudFlutter\crud_flutter\database\CrudFlutter.db';
    } else {
      path = join(await getDatabasesPath(), 'CrudFlutter.db');
    }
##_______________________________________________

É provável que seja necessário mudar o primiero caminho do path para conforme está salvo o projeto no computador até o arquivo do banco de dados
