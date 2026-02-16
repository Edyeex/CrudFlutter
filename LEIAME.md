# crud_flutter

Informações.

## Calsse banco_connection.dart

## No trecho:

##### Future<String> _getDatabasePath() async {
     if (Platform.isWindows) {
         return r'C:\temp\CrudFlutter\banco\CrudFlutter.db';
     } else {
         throw Exception('Caminho do banco não configurado.');
     }
#### }
#

Vai ser preciso mudar o caminho para onde está salvo a pasta do projeto.

Como no exemplo:
### C:\temp\CrudFlutter\banco\CrudFlutter.db