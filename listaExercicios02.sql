1 DELIMITER //
CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT * FROM Autor;
END //
DELIMITER ;


CALL sp_ListarAutores();

exer.2
DELIMITER //
CREATE PROCEDURE sp_LivrosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END //
DELIMITER ;


CALL sp_LivrosPorCategoria('Romance');

exer.3
DELIMITER //
CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    SELECT COUNT(Livro.Titulo) AS TotalLivros
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END //
DELIMITER ;


CALL sp_ContarLivrosPorCategoria('Ciência');

exer.4

DELIMITER //
CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    DECLARE contador INT;
    
    SELECT COUNT(Livro.Titulo) INTO contador
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
    
    IF contador > 0 THEN
        SELECT 'Existem livros nesta categoria.' AS Mensagem;
    ELSE
        SELECT 'Não existem livros nesta categoria.' AS Mensagem;
    END IF;
END //
DELIMITER ;


CALL sp_VerificarLivrosCategoria('Ficção Científica');

exer.5
DELIMITER //
CREATE PROCEDURE sp_LivrosAteAno(IN anoPublicacao INT)
BEGIN
    SELECT Titulo
    FROM Livro
    WHERE Ano_Publicacao <= anoPublicacao;
END //
DELIMITER ;


CALL sp_LivrosAteAno(2010);

exer.6
DELIMITER //
CREATE PROCEDURE sp_TitulosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livroTitulo VARCHAR(255);
    DECLARE cur CURSOR FOR
        SELECT Livro.Titulo
        FROM Livro
        INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
        WHERE Categoria.Nome = categoriaNome;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO livroTitulo;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT livroTitulo AS Titulo;
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;


CALL sp_TitulosPorCategoria('História');

exer.7
DELIMITER //
CREATE PROCEDURE sp_AdicionarLivro(IN livroTitulo VARCHAR(255), IN editoraID INT, IN anoPublicacao INT, IN numeroPaginas INT, IN categoriaID INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Erro: Não foi possível adicionar o livro.' AS Mensagem;
    END;
    
    START TRANSACTION;
    
    INSERT INTO Livro (Titulo, Editora_ID, Ano_Publicacao, Numero_Paginas, Categoria_ID)
    VALUES (livroTitulo, editoraID, anoPublicacao, numeroPaginas, categoriaID);
    
    COMMIT;
    
    SELECT 'Livro adicionado com sucesso.' AS Mensagem;
END //
DELIMITER ;

CALL sp_AdicionarLivro('Novo Livro', 1, 2022, 200, 2);

exer.8 
DELIMITER //
CREATE PROCEDURE sp_AutorMaisAntigo()
BEGIN
    SELECT Nome, Sobrenome
    FROM Autor
    WHERE Data_Nascimento = (SELECT MIN(Data_Nascimento) FROM Autor);
END //
DELIMITER ;


CALL sp_AutorMaisAntigo();
