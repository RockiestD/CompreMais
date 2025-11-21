use master
go

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'Compramais')
	DROP DATABASE Compramais

CREATE DATABASE Compramais
go

use Compramais
go
Set dateformat DMY
go

create table Funcionarios(
idFuncionarios int identity not null,
nome varchar(45),
usuario varchar(20) unique,
senha varchar(20),
dataNasc date,
primary key(idFuncionarios)
)

create table Clientes(
idCliente int identity not null,
nome varchar(45),
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

create index XFuncionarios on Funcionarios(idFuncionarios)
create index XClientes on Clientes(idCliente)
create index XFornecedor on Fornecedor(idFornecedor)
create index XCategoria on Categorias(idCategoria)
create index XPedidos on Pedidos(idPedido, idCliente)
create index XProduto on Produto(idProduto, idFornecedor, idCategoria)
create index XDetalhesPedido on DetalhesPedido(idPedido, idProduto)

go
------ Procedures -------

-- CRUD Clientes

create procedure CriaCliente
@nome varchar(45),
@usuario varchar(20),
@senha varchar(20)
as
begin
insert into Clientes(nome, usuario, senha)
values (@nome, @usuario, @senha);
end

go

create procedure BuscaCliente
as
begin
select * from Clientes;
end

go

create procedure BuscaClientePorID
@id int
as
begin
select * from Clientes where idCliente = @id
end

go 

create procedure AtualizaCliente
    @usuario varchar(20),
    @nome varchar(45),
    @senha varchar(20)
as
begin
    update Clientes set nome = @nome, senha = @senha where usuario = @usuario;
end

go

create procedure DeletaCliente
    @usuario varchar(20)
as
begin
    delete from clientes
    where usuario = @usuario;
end

-- CRUD Produtos
