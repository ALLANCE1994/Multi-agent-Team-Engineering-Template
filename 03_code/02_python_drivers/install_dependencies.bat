@echo off
chcp 65001 >nul
echo ================================================
echo   NV色心项目 - Python依赖一键安装脚本
echo ================================================
echo.

:: 设置清华镜像源
set PIP_SOURCE=https://pypi.tuna.tsinghua.edu.cn/simple

echo [1/4] 检查Python环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到Python，请先安装Python 3.8+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)
echo [OK] Python环境正常

echo.
echo [2/4] 升级pip...
python -m pip install --upgrade pip -i %PIP_SOURCE%
if errorlevel 1 (
    echo [警告] pip升级失败，继续安装...
)

echo.
echo [3/4] 安装依赖包（使用清华镜像源）...
echo.

:: 分步安装，避免一次性安装过多包导致超时
echo   - 安装向量数据库 chromadb...
pip install chromadb -i %PIP_SOURCE%
if errorlevel 1 (
    echo [错误] chromadb安装失败
    pause
    exit /b 1
)
echo   [OK] chromadb安装完成

echo.
echo   - 安装文本嵌入模型 sentence-transformers...
echo   [注意] 首次安装会下载模型文件，约400MB，请耐心等待...
pip install sentence-transformers -i %PIP_SOURCE%
if errorlevel 1 (
    echo [错误] sentence-transformers安装失败
    pause
    exit /b 1
)
echo   [OK] sentence-transformers安装完成

echo.
echo   - 安装基础依赖 torch numpy pandas...
pip install torch numpy pandas -i %PIP_SOURCE%
if errorlevel 1 (
    echo [警告] 部分基础依赖安装失败，继续...
)

echo.
echo [4/4] 验证安装...
python -c "import chromadb; import sentence_transformers; print('[OK] 依赖验证通过')" 2>nul
if errorlevel 1 (
    echo [错误] 依赖验证失败，请检查安装日志
    pause
    exit /b 1
)

echo.
echo ================================================
echo   依赖安装完成！
echo ================================================
echo.
echo 下一步运行向量入库：
echo   python 03_code\02_python_drivers\vector_db_ingest.py
echo.
pause
