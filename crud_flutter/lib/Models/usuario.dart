class Usuario {
  int? id;
  String nome;
  int codigo;
  String? dataCadastro;
  String? dataAtualizacao;

  Usuario({this.id, required this.nome, required this.codigo, this.dataCadastro, this.dataAtualizacao});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'nome': nome,
      'codigo': codigo,
      'data_cadastro': dataCadastro,
      'data_atualizacao': dataAtualizacao,
    };
  }
  factory Usuario.fromMap(Map<String, dynamic> map){
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      codigo: map['codigo'],
      dataCadastro: map['data_cadastro'],
      dataAtualizacao: map['data_atualizacao'],
    );
  }
}
