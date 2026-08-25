import QtQuick

// Tema estático calcado de la Waybar (~/.config/waybar/style.css + config).
// Sin soporte light/dark: una sola paleta fija.
Item {
    id: theme

    readonly property string fontFamily: "FiraCode Nerd Font"

    property var colors: ({
        // superficies (waybar)
        background: "#333333",  // window#waybar
        base:       "#333333",  // fondo de menús del tray (= barra)
        crust:      "#222330",  // fondo de módulos/pastillas
        mantle:     "#161320",  // fondo del tray
        surface0:   "#2a2b3d",
        surface1:   "#3b3d57",
        surface2:   "#454868",
        overlay0:   "#565f89",
        overlay1:   "#6b70a0",

        // texto (waybar: #f1f1f1 en módulos)
        text:       "#f1f1f1",
        foreground: "#f1f1f1",
        subtext0:   "#a9b1d6",
        subtext1:   "#c0caf5",

        // acentos (colores literales de la waybar)
        red:        "#f7768e",  // cpu, power
        maroon:     "#e8a2af",
        peach:      "#f8bd96",
        yellow:     "#e0af68",  // disk, idle-toggle, workspace activo
        green:      "#9ece6a",  // wifi
        teal:       "#b5e8e6",
        sky:        "#7aa2f7",  // icono de volumen
        sapphire:   "#7dcfff",  // memoria, launcher
        blue:       "#7aa2f7",
        lavender:   "#7aa2f7",  // workspaces con ventanas (persistent)
        mauve:      "#bb9af7",
        pink:       "#f5c2e7",
        flamingo:   "#f2cdcd",
        rosewater:  "#f5e0dc"
    })
}
