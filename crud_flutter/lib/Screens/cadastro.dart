import 'package:crud_flutter/Models/usuario.dart' hide Usuario;
import 'package:flutter/material.dart';
import '../Banco/banco_connection.dart';
import '../Models/usuario.dart';

class Cadastro extends StatefulWidget {
  final Usuario? usuario;
  Cadastro({this.usuario});

  //Cadastro.editar(this.usuario) : assert(usuario != null);

  @override
  State<Cadastro> createState() => _cadastroState();
}

class _cadastroState extends State<Cadastro> {

  final _formKey = GlobalKey<FormState>();
  final _txtNome = TextEditingController();
  final _txtCodigo = TextEditingController();
  final banco = BancoConnection();

  @override
  void initState(){
    super.initState();
    if (widget.usuario != null) {
      _txtNome.text = widget.usuario!.nome;
      _txtCodigo.text = widget.usuario!.codigo.toString();
    }
  }
  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      try {
        final usuario = {
          'id': widget.usuario?.id,
          'nome': _txtNome.text,
          'codigo': int.parse(_txtCodigo.text),
        };

        if (widget.usuario == null) {
          await banco.inserirUsuario(usuario);
          _mensagem('Usuário cadastrado com sucesso!');
        } else {
          await banco.atualizarUsuario(usuario);
          _mensagem('Usuário atualizado com sucesso!');
        }

        Navigator.pop(context, true);
      } catch (e) {
        String erro = e.toString();

        if (erro.contains('UNIQUE')) {
          _mensagem('Esse código já existe!', erro: true);
        }
        else if (erro.contains('CHECK')) {
          _mensagem('O código deve ser maior que zero!', erro: true);
        }
        else if (erro.contains('nome não pode')) {
          if (erro.contains('vazio')) {
            _mensagem('O nome não pode ser vazio!', erro: true);
          } else if (erro.contains('números')) {
            _mensagem('O nome não pode conter números no começo!', erro: true);
          } else {
            _mensagem('Nome inválido!', erro: true);
          }
        }
        else {
          _mensagem('Erro inesperado: $erro', erro: true);
        }
      }
    }
  }


  void _mensagem(String texto, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: erro ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario == null ? 'Novo Usuário' : 'Editar Usuário', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _txtNome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _txtCodigo,
                decoration: InputDecoration(
                  labelText: 'Código',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  final num = int.tryParse(value);
                  if (num == null) {
                    return 'Digite um número válido';
                  }
                  if (num <= 0) {
                    return 'O código deve ser maior que zero';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvar,
                      child: Text(
                        widget.usuario == null ? 'CADASTRAR' : 'ATUALIZAR',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('CANCELAR', style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _txtNome.dispose();
    _txtCodigo.dispose();
    super.dispose();
  }
}