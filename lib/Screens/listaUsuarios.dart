import 'dart:math';
import 'package:crud_flutter/Banco/banco_connection.dart';
import 'package:crud_flutter/Models/usuario.dart';
import 'package:flutter/material.dart';
import '../Banco/banco_connection.dart';
import '../models/usuario.dart' hide Usuario;
import 'cadastro.dart';
import 'logs.dart';

class Listausuarios extends StatefulWidget {
  @override
  State<Listausuarios> createState() => _listausuariosState();
}

class _listausuariosState extends State<Listausuarios> {

  final db = BancoConnection();
  List<Usuario> usuarios =[];
  String? erroBanco;

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async{
    try {
      setState(() => erroBanco = null);
      final data = await  db.listarUsuarios();
      setState(() {
        usuarios = data.map((e) => Usuario.fromMap(e)).toList();
      });
    } catch (e) {
      setState(() {
        erroBanco = e.toString();
      });
    }
  }

  Future<void> _excluirUsuario(int id) async{
    final confirma = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar exclusão"),
        content: Text("Deseja excluir esse usuário?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Não"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Sim"),
          ),
        ],
      ),
    );
    if(confirma == true){
      await db.excluirUsuario(id);
      _carregarUsuarios();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: Text('CrudFlutter',style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.orange,
            actions: [
              Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.history, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Logs()),
                        );
                      }
                  ),
                ],
              )
            ]
        ),
        body: erroBanco != null
            ? _buildErroBanco()
            : _buildConteudo()
    );
  }

  Widget _buildErroBanco() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            const Text(
              'ERRO DE CONEXÃO COM O BANCO',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                erroBanco!,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _carregarUsuarios,
              icon: Icon(Icons.refresh),
              label: Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConteudo() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cadastro()),
              );
              _carregarUsuarios();
            },
            icon: Icon(Icons.add, color: Colors.white,),
            label: Text('Novo Usuário', style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
        Expanded(
          child: usuarios.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhum usuário cadastrado',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
              : ListView.builder(
            itemCount: usuarios.length,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(usuario.nome),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Código: ${usuario.codigo}'),
                      if (usuario.dataCadastro != null)
                        Text(
                          'Cadastro: ${usuario.dataCadastro!.substring(0, 16)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Cadastro(usuario: usuario),
                                ),
                              );
                              _carregarUsuarios();
                            },
                          ),
                          Text('Editar', style: TextStyle(color: Colors.blue, fontSize: 12)),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _excluirUsuario(usuario.id!),
                          ),
                          Text('Excluir', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}