echo off

set arg1=%~dp0
echo %arg1:~0,-1%

%arg1%ATAC_SVC_NFE.exe /install

