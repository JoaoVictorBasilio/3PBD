CREATE TABLE CLIENTE (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE PRODUTO (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE PEDIDO (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    data_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE ITEM_PEDIDO (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto)
);

CREATE TABLE AUDITORIA_PEDIDO (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    acao VARCHAR(50),
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido)
);

INSERT INTO CLIENTE (nome) VALUES
('Ana Souza'),
('Carlos Pereira'),
('Beatriz Lima');

INSERT INTO PRODUTO (nome, preco) VALUES
('Notebook', 3500.00),
('Mouse Sem Fio', 80.00),
('Teclado Mecânico', 250.00),
('Cabo HDMI', 30.00),
('Monitor 24', 800.00);

INSERT INTO PEDIDO (id_cliente, data_pedido) VALUES
(2, '2023-10-01'),
(3, CURDATE() - INTERVAL 10 DAY);

INSERT INTO ITEM_PEDIDO (id_pedido, id_produto, quantidade) VALUES
(1, 1, 5),
(1, 3, 15),
(2, 4, 60);

CALL InserirPedido(1, CURDATE(), 2, 3, 4, 2);

SELECT CalcularTotalPedido(3) AS Total_Pedido_SP;
UPDATE PEDIDO SET data_pedido = CURDATE() WHERE id_pedido = 1;

SELECT * FROM AUDITORIA_PEDIDO;

SELECT
    c.nome AS nome_cliente,
    SUM(p.preco * ip.quantidade) AS total_gasto,
    SUM(ip.quantidade) AS quantidade_total
FROM CLIENTE c
JOIN PEDIDO pd ON c.id_cliente = pd.id_cliente
JOIN ITEM_PEDIDO ip ON pd.id_pedido = ip.id_pedido
JOIN PRODUTO p ON ip.id_produto = p.id_produto
GROUP BY
    c.id_cliente,
    c.nome
ORDER BY
    total_gasto DESC;

    SELECT
    pd.id_pedido,
    pd.data_pedido,
    c.nome AS nome_cliente,
    MAX(ap.data_modificacao) AS data_ultima_modificacao
FROM PEDIDO pd
JOIN CLIENTE c ON pd.id_cliente = c.id_cliente
LEFT JOIN AUDITORIA_PEDIDO ap ON pd.id_pedido = ap.id_pedido
WHERE
    pd.data_pedido >= CURDATE() - INTERVAL 30 DAY
GROUP BY
    pd.id_pedido,
    pd.data_pedido,
    c.nome;

    SELECT
    p.nome AS nome_produto,
    SUM(ip.quantidade) AS quantidade_total_vendida,
    IF(SUM(ip.quantidade) > 50, 'Alta Demanda',
        IF(SUM(ip.quantidade) >= 10, 'Média Demanda', 'Baixa Demanda')
    ) AS categoria_ficticia
FROM PRODUTO p
JOIN ITEM_PEDIDO ip ON p.id_produto = ip.id_produto
GROUP BY
    p.id_produto,
    p.nome;