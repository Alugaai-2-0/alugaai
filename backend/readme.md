Para utlizar o banco de dados com docker, colocar as seguintes informações:

* HOST: localhost
* USER: postgres
* DATABASE: postgres
* PASSWORD: pedraomasculodecalcinharosa

# Aviso importante

Caso haja alteração em alguma entidade, é necessário criar a migration e deletar os containers e imagens, e rodar o docker compose novamente.

## Para se conectar no banco de dados via docker pelo terminal:

* Rode o comando:
     ```sh
  docker compose up -d
  ```
* Rode o comando:
   ```sh
  docker exec -it backend-db-1 bash
  ```
* Em seguida, o comando:
    
   ```sh
   psql -U postgres -d alugaaidb
    ```
* Para listar todas as tabelas:
    
   ```sh
   \dt
    ```
  
# Swagger url
* http://localhost:8080/swagger-ui/index.html