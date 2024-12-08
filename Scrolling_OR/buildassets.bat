@echo off
assets2banks assets --firstbank=3 --compile
@if %errorlevel% NEQ 0 goto :EOF