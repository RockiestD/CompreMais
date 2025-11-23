use master
go

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'Compramais')
	DROP DATABASE Compramais

CREATE DATABASE Compramais
go

use Compramais
go
set dateformat dmy
go

create table Funcionario(
	idFuncionarios int identity not null,
	usuario varchar(20) unique,
	senha varchar(20),
	primary key(idFuncionarios)
)

create table Clientes(
	idCliente int identity not null,
	nome varchar(45),
	cpf varchar(11),
	endereco varchar(50),
	cidade varchar(50),
	cep varchar(10),
	bairro varchar(40),
	complemento varchar(255),
	telefone varchar(24),
	usuario varchar(20) unique,
	senha varchar(20),
	primary key(idCliente)
)

create table Fornecedor(
	idFornecedor int identity not null,
	empresa varchar(40),
	endereco varchar(50),
	cidade varchar(50),
	cep varchar(10),
	pais varchar(15),
	telefone varchar(24),
	primary key(idFornecedor)
)

create table Categorias(
	idCategoria int identity not null,
	descr varchar(20),
	primary key(idCategoria)
)

create table Pedidos(
	idPedido int identity not null,
	idCliente int,
	dataPed date,
	dataEntrega date,
	frete decimal(5,2),
	primary key(idPedido),
	foreign key(idCliente) references Clientes(idCliente) on delete cascade 
)

create table Produto(
	idProduto int identity not null,
	idFornecedor int,
	idCategoria int,
	nome varchar(60),
	descr varchar(255),
	preco decimal(7,2),
	imagem varbinary(max),
	unidades int,
	primary key(idProduto),
	foreign key(idFornecedor) references Fornecedor(idFornecedor) on delete cascade,
	foreign key(idCategoria) references Categorias(idCategoria) on delete cascade
)

create table DetalhesPedido(
	idPedido int,
	idProduto int,
	preco decimal(7,2),
	qtde int,
	desconto float,
	foreign key(idPedido) references Pedidos(idPedido) on delete cascade,
	foreign key(idProduto) references Produto(idProduto) on delete cascade
)

------ indices ------

create index XFuncionario on Funcionario(idFuncionarios)
create index XClientes on Clientes(idCliente)
create index XFornecedor on Fornecedor(idFornecedor)
create index XCategoria on Categorias(idCategoria)
create index XPedidos on Pedidos(idPedido, idCliente)
create index XProduto on Produto(idProduto, idFornecedor, idCategoria)
create index XDetalhesPedido on DetalhesPedido(idPedido, idProduto)

------ inserts ------

insert into Funcionario (usuario, senha) values ('adm1', '2814162')

insert into categorias (descr) values ('Alimentos');
insert into categorias (descr) values ('Bebidas');
insert into categorias (descr) values ('Limpeza e higiene');

------ procedures ------

-- crud clientes
go

create procedure criacliente
	@nome varchar(45),
	@cpf varchar(11),
	@endereco varchar(50),
	@cidade varchar(50),
	@cep varchar(10),
	@bairro varchar(40),
	@complemento varchar(255),
	@telefone varchar(24),
	@usuario varchar(20),
	@senha varchar(20)
as
begin
	insert into clientes (nome, cpf, endereco, cidade, cep, bairro, complemento, telefone, usuario, senha)
	values (@nome, @cpf, @endereco, @cidade, @cep, @bairro, @complemento, @telefone, @usuario, @senha)
end
go

create procedure buscaclientes
as
begin
	select * from clientes
end
go

create procedure buscaclienteporid
	@id int
as
begin
	select * from clientes
	where idcliente = @id
end
go

create procedure atualizacliente
	@usuario varchar(20),
	@nome varchar(45),
	@endereco varchar(50),
	@cidade varchar(50),
	@cep varchar(10),
	@bairro varchar(40),
	@complemento varchar(255),
	@telefone varchar(24),
	@senha varchar(20)
as
begin
	update clientes
	set nome = @nome,
		endereco = @endereco,
		cidade = @cidade,
		cep = @cep,
		bairro = @bairro,
		complemento = @complemento,
		telefone = @telefone,
		senha = @senha
	where usuario = @usuario
end
go

create procedure deletacliente
	@id int
as
begin
	delete from clientes
	where idcliente = @id
end
go

-- crud produtos

create procedure criaproduto
	@idfornecedor int,
	@idcategoria int,
	@nome varchar(60),
	@descr varchar(255),
	@preco decimal(7,2),
	@imagem varbinary(max),
	@unidades int
as
begin
	insert into produto (idfornecedor, idcategoria, nome, descr, preco, imagem, unidades)
	values (@idfornecedor, @idcategoria, @nome, @descr, @preco, @imagem, @unidades)
end
go

create procedure buscaproduto
as
begin
	select * from produto
end
go

create procedure buscaprodutoporid
	@id int
as
begin
	select * from produto
	where idproduto = @id
end
go

create procedure atualizaproduto
	@id int,
	@idfornecedor int,
	@idcategoria int,
	@nome varchar(60),
	@descr varchar(255),
	@preco decimal(7,2),
	@imagem varbinary(max),
	@unidades int
as
begin
	update produto
	set idfornecedor = @idfornecedor,
		idcategoria = @idcategoria,
		nome = @nome,
		descr = @descr,
		preco = @preco,
		imagem = @imagem,
		unidades = @unidades
	where idproduto = @id
end
go

create procedure deletaproduto
	@id int
as
begin
	delete from produto
	where idproduto = @id
end
go

-- crud categorias

create procedure criacategoria
	@descr varchar(20)
as
begin
	insert into categorias (descr)
	values (@descr)
end
go

create procedure buscacategorias
as
begin
	select * from categorias
end
go

create procedure buscacategoriaporid
	@id int
as
begin
	select * from categorias
	where idcategoria = @id
end
go

create procedure atualizacategoria
	@id int,
	@descr varchar(20)
as
begin
	update categorias
	set descr = @descr
	where idcategoria = @id
end
go

create procedure deletacategoria
	@id int
as
begin
	delete from categorias
	where idcategoria = @id
end
go

-- crud fornecedores

create procedure criafornecedor
	@empresa varchar(40),
	@endereco varchar(50),
	@cidade varchar(50),
	@cep varchar(10),
	@pais varchar(15),
	@telefone varchar(24)
as
begin
	insert into fornecedor (empresa, endereco, cidade, cep, pais, telefone)
	values (@empresa, @endereco, @cidade, @cep, @pais, @telefone)
end
go

create procedure buscafornecedores
as
begin
	select * from fornecedor
end
go

create procedure buscafornecedorporid
	@id int
as
begin
	select * from fornecedor
	where idfornecedor = @id
end
go

create procedure atualizafornecedor
	@id int,
	@empresa varchar(40),
	@endereco varchar(50),
	@cidade varchar(50),
	@cep varchar(10),
	@pais varchar(15),
	@telefone varchar(24)
as
begin
	update fornecedor
	set empresa = @empresa,
		endereco = @endereco,
		cidade = @cidade,
		cep = @cep,
		pais = @pais,
		telefone = @telefone
	where idfornecedor = @id
end
go

create procedure deletafornecedor
	@id int
as
begin
	delete from fornecedor
	where idfornecedor = @id
end
go

-- crud pedidos

create procedure criapedido
	@idcliente int,
	@dataped date,
	@dataentrega date,
	@frete decimal(5,2)
as
begin
	insert into pedidos (idcliente, dataped, dataentrega, frete)
	values (@idcliente, @dataped, @dataentrega, @frete)
end
go

create procedure buscapedidos
as
begin
	select * from pedidos
end
go

create procedure buscapedidoporid
	@id int
as
begin
	select * from pedidos
	where idpedido = @id
end
go

create procedure atualizapedido
	@id int,
	@idcliente int,
	@dataped date,
	@dataentrega date,
	@frete decimal(5,2)
as
begin
	update pedidos
	set idcliente = @idcliente,
		dataped = @dataped,
		dataentrega = @dataentrega,
		frete = @frete
	where idpedido = @id
end
go

create procedure deletapedido
	@id int
as
begin
	delete from pedidos
	where idpedido = @id
end
go

-- crud detalhespedido

create procedure criadetalhespedido
	@idpedido int,
	@idproduto int,
	@preco decimal(7,2),
	@qtde int,
	@desconto float
as
begin
	insert into detalhespedido (idpedido, idproduto, preco, qtde, desconto)
	values (@idpedido, @idproduto, @preco, @qtde, @desconto)
end
go

create procedure buscardetalhes
as
begin
	select * from detalhespedido
end
go

create procedure buscardetalhesporpedido
	@idpedido int
as
begin
	select * from detalhespedido
	where idpedido = @idpedido
end
go

create procedure atualizadetalhespedido
	@idpedido int,
	@idproduto int,
	@preco decimal(7,2),
	@qtde int,
	@desconto float
as
begin
	update detalhespedido
	set preco = @preco,
		qtde = @qtde,
		desconto = @desconto
	where idpedido = @idpedido
		and idproduto = @idproduto
end
go

create procedure deletadetalhespedido
	@idpedido int,
	@idproduto int
as
begin
	delete from detalhespedido
	where idpedido = @idpedido
		and idproduto = @idproduto
end
