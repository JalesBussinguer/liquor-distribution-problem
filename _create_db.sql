LOAD spatial;

CREATE TABLE liquor_sales AS SELECT * FROM 'data\iowa_liquor_sales.csv';

describe liquor_sales;

CREATE TABLE lojas (

    loja_id INT PRIMARY KEY,
    nome VARCHAR(255),
    endereco VARCHAR(255),
    zip VARCHAR(255),
    geometria GEOMETRY

);

CREATE TABLE datas (

    data_id INT PRIMARY KEY,
    data_completa DATE,
    ano INT,
    mes INT,
    dia INT,

);

CREATE TABLE produtos (

    produto_id INT PRIMARY KEY,
    nome VARCHAR(255),
    pack INT,
    volume INT,
    preco_de_custo DECIMAL(10,2),
    preco_de_venda DECIMAL(10,2)

);

CREATE TABLE localidades (

    localidade_id INT PRIMARY KEY,
    county VARCHAR(255),
    cidade VARCHAR(255)

);

CREATE TABLE distribuidores (

    distribuidor_id INT PRIMARY KEY,
    distribuidor VARCHAR(255)

);

CREATE TABLE categoria (

    categoria_id INT PRIMARY KEY,
    categoria VARCHAR(255)

);

CREATE TABLE fato_vendas (

    venda_id INT PRIMARY KEY,
    data_id INT,
    produto_id INT,
    categoria_id INT,
    localidade_id INT,
    distribuidor_id INT,
    garrafas_vendidas INT,
    volume_vendido INT,
    faturamento DECIMAL(10,2),
    
    FOREIGN KEY (data_id) REFERENCES datas(data_id),
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id),
    FOREIGN KEY (categoria_id) REFERENCES categoria(categoria_id),
    FOREIGN KEY (localidade_id) REFERENCES localidades(localidade_id),
    FOREIGN KEY (distribuidor_id) REFERENCES distribuidores(distribuidor_id)
    
);

