# crud_flutter

Informações.

## Calsse banco_connection.dart

## No trecho:

##### Future<Database> _initDatabase() async {
    String path;

    if (Platform.isWindows) {
      path = r'C:\temp\CrudFlutter\banco\CrudFlutter.db';
    } else {
      path = join(await getDatabasesPath(), 'CrudFlutter.db');
    }

    return await openDatabase(
      path,
      version: 1,
    );
#### }
#

Vai ser preciso mudar o caminho para onde está salvo a pasta do projetoCaso ele não encontre de forma automática.

Como no exemplo:
### C:\temp\CrudFlutter\banco\CrudFlutter.db