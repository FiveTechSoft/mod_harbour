@rem --------------------------------------------------------------------------
@rem Empaqueta fuentes 
@rem --------------------------------------------------------------------------

@cd u:/desarrollo/vscode/proyectos
@set cpfic=e:/vscode.copias/mod_harbour/mod_harbour-%date:~-4%-%date:~3,2%-%date:~0,2%-0
@"%programfiles%"\7-zip\7z a -r %cpfic% mod_harbour/* -mx
@"%programfiles%"\7-zip\7z l %cpfic%.7z
