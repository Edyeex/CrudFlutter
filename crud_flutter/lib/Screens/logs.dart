import 'package:flutter/material.dart';
import '../Banco/banco_connection.dart';

class Logs extends StatefulWidget {
  const Logs({super.key});

  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {

  final banco = BancoConnection();
  List<Map<String, dynamic>> logs = [];

  @override
  void initState(){
    super.initState();
    _carregaLogs();
  }

  Future<void> _carregaLogs() async{
    final data = await banco.listarLogs();
    setState(() {
      logs = data;
    });
  }

  Color _corDaAcao(String acao) {
    switch (acao) {
      case 'CADASTROU': return Colors.green;
      case 'ATUALIZOU': return Colors.blue;
      case 'EXCLUIU': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Operações', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.orange,
      ),
      body: logs.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Nenhuma operação registrada',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _corDaAcao(log['acao']).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        log['acao'][0],
                        style: TextStyle(
                          color: _corDaAcao(log['acao']),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log['detalhes'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          log['data_hora'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _corDaAcao(log['acao']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      log['acao'],
                      style: TextStyle(
                        color: _corDaAcao(log['acao']),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
