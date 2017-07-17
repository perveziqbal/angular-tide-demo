# HelloWorld

Steps to evaluate [tide]() in emacs with angular/typescript project

1. Clone this repository

        git clone https://github.com/perveziqbal/angular-tide-demo.git

2. Install npm packages

        cd angular-tide-demo
        npm install

3. Open emacs

        emacs -Q -l tide-emacs.el

4. Make sure you edit the tsserver.js

Replace the following line

    var diagnostics = selector(project, file);
with

    var diagnostics = selector(project, file) || [];

4. Open src/app/hello/hello.component.html
5. If needed install typescript's latest stable version globally

        npm uninstall -g typescript
        npm install -g typescript
