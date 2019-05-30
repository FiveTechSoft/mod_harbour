function Main()

   TEMPLATE
   <!DOCTYPE html>
    <html lang="pt-br">
      <head>
        <!-- Meta tags Obrigatórias -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    
        <title>Harbour</title>

        <style>
        /*
        * Globals
        */
       
       /* Links */
       a,
       a:focus,
       a:hover {
         color: #fff;
       }
       
       /* Botão padrão customizado */
       .btn-secondary,
       .btn-secondary:hover,
       .btn-secondary:focus {
         color: #333;
         text-shadow: none; /* Previne herença do `body` */
         background-color: #fff;
         border: .05rem solid #fff;
       }
       
       
       /*
        * Estrutura base
        */
       
       html,
       body {
         height: 100%;
         background-color: #333;
       }
       
       body {
         display: -ms-flexbox;
         display: flex;
         color: #fff;
         text-shadow: 0 .05rem .1rem rgba(0, 0, 0, .5);
         box-shadow: inset 0 0 5rem rgba(0, 0, 0, .5);
       }
       
       .cover-container {
         max-width: 42em;
       }
       
       
       /*
        * Cabeçalho
        */
       .masthead {
         margin-bottom: 2rem;
       }
       
       .masthead-brand {
         margin-bottom: 0;
       }
       
       .nav-masthead .nav-link {
         padding: .25rem 0;
         font-weight: 700;
         color: rgba(255, 255, 255, .5);
         background-color: transparent;
         border-bottom: .25rem solid transparent;
       }
       
       .nav-masthead .nav-link:hover,
       .nav-masthead .nav-link:focus {
         border-bottom-color: rgba(255, 255, 255, .25);
       }
       
       .nav-masthead .nav-link + .nav-link {
         margin-left: 1rem;
       }
       
       .nav-masthead .active {
         color: #fff;
         border-bottom-color: #fff;
       }
       
       @media (min-width: 48em) {
         .masthead-brand {
           float: left;
         }
         .nav-masthead {
           float: right;
         }
       }
       
       
       /*
        * Capa
        */
       .cover {
         padding: 0 1.5rem;
       }
       .cover .btn-lg {
         padding: .75rem 1.25rem;
         font-weight: 700;
         text-align:center;
       }
       
       
       /*
        * Footer
        */
       .mastfoot {
         text-align: center;
         color: rgba(255, 255, 255, .5);
       }
        </style>
      </head>
      <body>

        <div class="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
        <header class="masthead mb-auto">
          <div class="inner">
            <h3 class="masthead-brand">Harbour Project!</h3>
            <nav class="nav nav-masthead justify-content-center">
              <a class="nav-link active" href="#">Home</a>
              <a class="nav-link" href="#">Features</a>
              <a class="nav-link" href="#">Contatos</a>
            </nav>
          </div>
        </header>
  
        <main role="main" class="inner cover">
          <h1 class="cover-heading">Harbour Module for Apache</h1>
        </main>
  
        <footer class="mastfoot mt-auto">
          <div class="inner">
            <p>Welcome to future! <a href="https://harbour.github.io">Harbour</a>.</p>
          </div>
        </footer>
        </div>
  
        </body>
    </html>
    ENDTEXT

return nil
