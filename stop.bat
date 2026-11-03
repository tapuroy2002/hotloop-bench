@echo off
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is required to stop the dashboard.
  pause
  exit /b 1
)
node stop.js
