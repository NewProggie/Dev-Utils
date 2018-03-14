@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass "& {& '%~dp0install\bootstrap-win-dev-utils.ps1'}"