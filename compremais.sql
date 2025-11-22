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

create table Funcionario(
idFuncionarios int identity not null,
usuario varchar(20) unique,
senha varchar(20),
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

------ === Inserts === -------

-- ADM

insert into Funcionario (usuario, senha) values ('adm1', '2814162')

-- Categorias

insert into categorias (descr) values ('Alimentos');
insert into categorias (descr) values ('Bebidas');
insert into categorias (descr) values ('Limpeza e higiene');

------ === Procedures === -------

-- CRUD Clientes
go

create procedure CriaCliente
    @nome varchar(45),
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
    insert into clientes (nome, endereco, cidade, cep, bairro, complemento, telefone, usuario, senha)
    values (@nome, @endereco, @cidade, @cep, @bairro, @complemento, @telefone, @usuario, @senha);
end

go


create procedure BuscaClientes
as
begin
    select * from clientes;
end

go


create procedure BuscaClientePorID
    @id int
as
begin
    select * from clientes
    where idcliente = @id;
end

go


create procedure AtualizaCliente
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
    where usuario = @usuario;
end

go


create procedure DeletaCliente
    @id int
as
begin
    delete from clientes
    where idcliente = @id;
end

-- CRUD Produtos
go

create procedure CriaProduto
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
    values (@idfornecedor, @idcategoria, @nome, @descr, @preco, @imagem, @unidades);
end

go

create procedure BuscaProduto
as
begin
    select * from produto;
end

go

create procedure BuscaProdutoPorID
    @id int
as
begin
    select * from produto
    where idproduto = @id;
end

go

create procedure AtualizaProduto
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
    where idproduto = @id;
end

go

create procedure DeletaProduto
    @id int
as
begin
    delete from produto
    where idproduto = @id;
end

