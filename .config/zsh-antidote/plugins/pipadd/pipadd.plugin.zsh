pipadd() {
    if [ -z "$1" ]; then
        echo "❌ Uso: pipadd <paquete>"
        return 1
    fi

    echo "📦 Instalando $1..."
    if pip install "$1"; then
        version_line=$(pip freeze | grep -i "^$1==")
        if [ -n "$version_line" ]; then
            # Evitar duplicados: borrar línea previa antes de agregar
            sed -i "/^$1==/Id" requirements.txt 2>/dev/null
            echo "$version_line" >> requirements.txt
            echo "✅ $version_line agregado a requirements.txt"
        else
            echo "⚠️ No se encontró $1 en pip freeze"
        fi
    else
        echo "❌ Falló la instalación de $1"
    fi
}
