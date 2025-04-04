DROP DATABASE academiagin_bd;

CREATE DATABASE academiagin_bd;

use academiagin_bd;

-- Usuário
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    tipo ENUM('Administrador', 'Professor', 'Aluno') NOT NULL,
    PRIMARY KEY (id_usuario, email),
    UNIQUE (email)
);

-- Administrador
CREATE TABLE Administrador (
    id_usuario INT,
    email VARCHAR(100),
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT,
    cargo VARCHAR(100) NOT NULL DEFAULT 'Administrador',
    salario FLOAT NOT NULL,
    PRIMARY KEY (id_usuario, email),
    FOREIGN KEY (id_usuario, email) REFERENCES Usuario(id_usuario, email) ON DELETE CASCADE
);

-- Aluno
CREATE TABLE Aluno (
    id_usuario INT,
    email VARCHAR(100),
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT,
    plano_id INT,
    status_matricula BOOLEAN NOT NULL,
    PRIMARY KEY (id_usuario, email),
    FOREIGN KEY (id_usuario, email) REFERENCES Usuario(id_usuario, email) ON DELETE CASCADE
);

-- Professor
CREATE TABLE Professor (
    id_usuario INT,
    email VARCHAR(100),
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT,
    especialidade VARCHAR(100),
    salario FLOAT NOT NULL,
    PRIMARY KEY (id_usuario, email),
    FOREIGN KEY (id_usuario, email) REFERENCES Usuario(id_usuario, email) ON DELETE CASCADE
);

-- Planos
CREATE TABLE Plano (
    id_plano INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('Basic Gym', 'Plus Gym', 'Ultra Gym') NOT NULL,
    preco FLOAT NOT NULL,
    descricao TEXT
);

-- Aula
CREATE TABLE Aula (
    id_aula INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    horario DATETIME NOT NULL,
    professor_id INT NOT NULL,
    capacidade INT NOT NULL,
    dia ENUM('Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado') NOT NULL,
    modalidade ENUM('Musculação', 'Crossfit', 'Yoga', 'Pilates') NOT NULL,
    FOREIGN KEY (professor_id) REFERENCES Professor(id_usuario) ON DELETE CASCADE
);

-- Receita Financeira
CREATE TABLE Receita (
    id_receita INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Plano', 'Aulas Extras', 'Avaliação Física', 'Outros') NOT NULL,
    descricao VARCHAR(255),
    valor DECIMAL(10,2) NOT NULL,
    data_recebimento DATE NOT NULL,
    status ENUM('Recebido', 'Pendente') NOT NULL
);

-- Despesas Financeiras
CREATE TABLE Despesa (
    id_despesa INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Salários', 'Aluguel', 'Equipamentos', 'Manutenção', 'Outros') NOT NULL,
    descricao VARCHAR(255),
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    status ENUM('Pago', 'Pendente') NOT NULL
);

-- Relatório Financeiro
CREATE TABLE RelatorioFinanceiro (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_registro DATE NOT NULL,
    receita_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    despesa_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    saldo DECIMAL(10,2) GENERATED ALWAYS AS (receita_total - despesa_total) STORED,
    
    status_saldo VARCHAR(20) GENERATED ALWAYS AS (
        CASE 
            WHEN (receita_total - despesa_total) > 0 THEN 'Positivo'
            WHEN (receita_total - despesa_total) < 0 THEN 'Negativo'
            ELSE 'Equilibrado'
        END
    ) STORED
);

-- Relatório Operacional
CREATE TABLE RelatorioOperacional (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_registro DATE NOT NULL,
    total_aulas INT NOT NULL DEFAULT 0,
    total_alunos INT NOT NULL DEFAULT 0,
    aula_mais_popular VARCHAR(100),
    aula_menos_popular VARCHAR(100),
    media_presenca_alunos DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    taxa_ocupacao_aulas DECIMAL(5,2) NOT NULL DEFAULT 0.00
);

-- Relatório Aula
CREATE TABLE PresençaAula (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_aula INT NOT NULL,
    data_aula DATE NOT NULL,
    id_aluno INT NOT NULL,
    nome_aluno VARCHAR(100) NOT NULL,
    status_presenca ENUM('Presente', 'Faltou') NOT NULL,
    modalidade ENUM('Musculação', 'Crossfit', 'Yoga', 'Pilates') NOT NULL,
    FOREIGN KEY (id_aula) REFERENCES Aula(id_aula) ON DELETE CASCADE,
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id_usuario) ON DELETE CASCADE
);

-- Inserindo Usuários
INSERT INTO Usuario (email, nome, senha_hash, tipo) VALUES 
('admin@academia.com', 'Carlos Souza', 'senha123', 'Administrador'),
('prof.joana@gmail.com', 'Joana Silva', 'prof123', 'Professor'),
('aluno.pedro@gmail.com', 'Pedro Santos', 'aluno123', 'Aluno');

-- Inserindo Administradores
INSERT INTO Administrador (id_usuario, email, nome, cpf, telefone, endereco, salario) VALUES 
(1, 'admin@academia.com', 'Carlos Souza', '123.456.789-00', '99999-1234', 'Rua A, 123', 5000.00);

-- Inserindo Professores
INSERT INTO Professor (id_usuario, email, nome, cpf, telefone, endereco, especialidade, salario) VALUES 
(2, 'prof.joana@gmail.com', 'Joana Silva', '987.654.321-00', '99988-5678', 'Av. B, 456', 'Musculação', 3000.00);

-- Inserindo Planos
INSERT INTO Plano (tipo, preco, descricao) VALUES 
('Basic Gym', 99.90, 'Acesso à academia de segunda a sexta'),
('Plus Gym', 149.90, 'Acesso completo + aulas de grupo'),
('Ultra Gym', 199.90, 'Acesso total + personal trainer');

-- Inserindo Alunos
INSERT INTO Aluno (id_usuario, email, nome, cpf, telefone, endereco, plano_id, status_matricula) VALUES 
(3, 'aluno.pedro@gmail.com', 'Pedro Santos', '111.222.333-44', '98877-6655', 'Rua C, 789', 1, TRUE);

-- Inserindo Aulas
INSERT INTO Aula (nome, horario, professor_id, capacidade, dia, modalidade) VALUES 
('Treino de Força', '8:00:00', 2, 20, 'Segunda', 'Musculação'),
('Aula de Yoga', ' 10:00:00', 2, 15, 'Terça', 'Yoga');

-- Inserindo Presença em Aulas
INSERT INTO PresençaAula (id_aula, data_aula, id_aluno, nome_aluno, status_presenca, modalidade) VALUES 
(1, '2025-04-10', 3, 'Pedro Santos', 'Presente', 'Musculação'),
(2, '2025-04-11', 3, 'Pedro Santos', 'Faltou', 'Musculação');

-- Inserindo Receitas
INSERT INTO Receita (tipo, descricao, valor, data_recebimento, status) VALUES 
('Plano', 'Mensalidade - Pedro Santos', 99.90, '2025-04-01', 'Recebido'),
('Aulas Extras', 'Aula Avulsa de Yoga', 50.00, '2025-04-05', 'Pendente');

-- Inserindo Despesas
INSERT INTO Despesa (tipo, descricao, valor, data_vencimento, status) VALUES 
('Salários', 'Pagamento Professor Joana', 3000.00, '2025-04-10', 'Pago'),
('Manutenção', 'Reparo de equipamentos', 500.00, '2025-04-15', 'Pendente');

-- Visualizando os Registros
SELECT * FROM Usuario;
SELECT * FROM Administrador;
SELECT * FROM Professor;
SELECT * FROM Aluno;
SELECT * FROM Plano;
SELECT * FROM Aula;
SELECT * FROM PresençaAula;
SELECT * FROM Receita;
SELECT * FROM Despesa;


