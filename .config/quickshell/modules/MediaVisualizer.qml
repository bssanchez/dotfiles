import QtQuick
import QtQuick.Effects

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Mpris

PanelWindow {
    id: visualizer

    property var targetScreen
    screen: targetScreen

    // Esquina inferior derecha
    anchors {
        right: true
        bottom: true
    }
    margins {
        right: 14
        bottom: 8
    }

    implicitWidth: 360
    implicitHeight: 360
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.namespace: "quickshell-visualizer"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // Click-through: empty input region
    mask: Region {}

    // ---- Mpris ----
    readonly property var players: Mpris.players.values
    readonly property MprisPlayer activePlayer:
        players.find(p => p.isPlaying) ?? (players.length > 0 ? players[0] : null)
    readonly property bool playing: activePlayer !== null && activePlayer.isPlaying

    // ---- Visibility state ----
    // -1 = auto (follow playback), 0 = forced hidden, 1 = forced shown
    property int overrideState: -1
    readonly property bool effectiveShown:
        overrideState === 0 ? false
        : overrideState === 1 ? true
        : playing

    // Cycles: auto -> forced opposite -> back to auto
    function toggle() {
        overrideState = (overrideState !== -1) ? -1 : (effectiveShown ? 0 : 1);
    }

    visible: content.opacity > 0.001

    // ---- Color aleatorio de la ameba ----
    // Cambia con cada canción; los colores derivados se interpolan suave.
    property real hue: Math.random()

    readonly property color accent: Qt.hsla(hue, 0.62, 0.66, 1.0)
    readonly property color accentDeep: Qt.hsla((hue + 0.09) % 1.0, 0.72, 0.44, 1.0)

    Behavior on accent {
        ColorAnimation { duration: 900; easing.type: Easing.InOutQuad }
    }
    Behavior on accentDeep {
        ColorAnimation { duration: 900; easing.type: Easing.InOutQuad }
    }

    function randomizeColor() {
        let h = Math.random();
        let tries = 0;
        // Evita repetir un tono demasiado parecido al anterior.
        while (tries < 12) {
            const d = Math.abs(h - hue);
            if (Math.min(d, 1 - d) > 0.18)
                break;
            h = Math.random();
            tries++;
        }
        hue = h;
    }

    Connections {
        target: visualizer.activePlayer
        ignoreUnknownSignals: true
        function onTrackTitleChanged() { visualizer.randomizeColor(); }
    }

    onActivePlayerChanged: randomizeColor()

    // ---- cava data ----
    property int barCount: 32
    property var targetValues: new Array(barCount).fill(0)
    property var dispValues: []

    // Energía global (0..1) para el "latido" de la ameba
    property real energy: 0

    Process {
        id: cavaProc
        running: visualizer.effectiveShown && visualizer.playing
        command: ["sh", "-c",
            "cat > /tmp/quickshell-cava.conf << 'EOF'\n" +
            "[general]\n" +
            "framerate = 30\n" +
            "bars = " + visualizer.barCount + "\n" +
            "autosens = 1\n" +
            "[input]\n" +
            "method = pulse\n" +
            "[output]\n" +
            "method = raw\n" +
            "raw_target = /dev/stdout\n" +
            "data_format = ascii\n" +
            "ascii_max_range = 100\n" +
            "channels = mono\n" +
            "mono_option = average\n" +
            "[smoothing]\n" +
            "monstercat = 1\n" +
            "noise_reduction = 0.30\n" +
            "EOF\n" +
            "exec cava -p /tmp/quickshell-cava.conf"]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const parts = data.split(";");
                const vals = [];
                for (let i = 0; i < parts.length; i++) {
                    if (parts[i] === "")
                        continue;
                    vals.push(Math.min(100, parseInt(parts[i], 10) || 0) / 100.0);
                }
                if (vals.length > 0)
                    visualizer.targetValues = vals;
            }
        }

        onRunningChanged: {
            if (!running) {
                visualizer.targetValues = new Array(visualizer.barCount).fill(0);
                blobCanvas.requestPaint();
            }
        }
    }

    FrameAnimation {
        running: visualizer.visible
        onTriggered: {
            const t = visualizer.targetValues;
            let d = visualizer.dispValues;
            if (d.length !== t.length)
                d = t.slice();
            let sum = 0;
            for (let i = 0; i < t.length; i++) {
                d[i] = d[i] + (t[i] - d[i]) * 0.25;
                sum += d[i];
            }
            visualizer.dispValues = d;
            visualizer.energy += ((t.length ? sum / t.length : 0) - visualizer.energy) * 0.12;
            blobCanvas.requestPaint();
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: visualizer.effectiveShown ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 450
                easing.type: Easing.InOutQuad
            }
        }

        // ---------- La ameba ----------
        MultiEffect {
            anchors.fill: blobCanvas
            source: blobCanvas
            z: -1
            blurEnabled: true
            blur: 1.0
            blurMax: 48
            opacity: 0.6
        }

        Canvas {
            id: blobCanvas
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative

            property real phase: 0
            NumberAnimation on phase {
                id: blobPhase
                from: 0
                to: Math.PI * 2
                duration: 9000
                loops: Animation.Infinite
                running: visualizer.visible
            }

            onPaint: {
                const ctx = getContext("2d");
                ctx.reset();

                const cx = width / 2;
                const cy = height / 2;

                const src = visualizer.dispValues;
                const n = src.length;

                // Espejamos las barras para cerrar el contorno sin costura.
                const m = [];
                for (let i = 0; i < n; i++)
                    m.push(src[i]);
                for (let i = n - 1; i >= 0; i--)
                    m.push(src[i]);

                const N = Math.max(m.length, 48);
                const baseR = 106 + visualizer.energy * 14;
                const amp = 34;
                const ph = phase;

                // Suavizado circular de las barras (vecinos con envolvente).
                const s = [];
                for (let i = 0; i < N; i++) {
                    if (m.length === 0) {
                        s.push(0);
                        continue;
                    }
                    const j = Math.floor(i * m.length / N);
                    const a = m[(j - 1 + m.length) % m.length];
                    const b = m[j];
                    const c = m[(j + 1) % m.length];
                    s.push((a + 2 * b + c) / 4);
                }

                // Contorno orgánico: audio + ondulaciones lentas desfasadas.
                const pts = [];
                for (let i = 0; i < N; i++) {
                    const th = i * 2 * Math.PI / N - Math.PI / 2;
                    const wobble =
                        0.070 * Math.sin(3 * th + ph)
                        + 0.048 * Math.sin(5 * th - ph * 1.4)
                        + 0.030 * Math.sin(7 * th + ph * 0.6);
                    const r = baseR * (1 + wobble) + s[i] * amp;
                    pts.push({ x: cx + Math.cos(th) * r, y: cy + Math.sin(th) * r });
                }

                function blobPath() {
                    ctx.beginPath();
                    const last = pts[N - 1];
                    ctx.moveTo((last.x + pts[0].x) / 2, (last.y + pts[0].y) / 2);
                    for (let i = 0; i < N; i++) {
                        const cur = pts[i];
                        const nxt = pts[(i + 1) % N];
                        ctx.quadraticCurveTo(cur.x, cur.y,
                                             (cur.x + nxt.x) / 2, (cur.y + nxt.y) / 2);
                    }
                    ctx.closePath();
                }

                const a = Qt.color(visualizer.accent);
                const d = Qt.color(visualizer.accentDeep);
                const rMax = baseR + amp;

                blobPath();
                const grad = ctx.createRadialGradient(
                    cx, cy - rMax * 0.25, rMax * 0.08,
                    cx, cy, rMax * 1.05);
                grad.addColorStop(0.0, Qt.rgba(a.r, a.g, a.b, 0.55));
                grad.addColorStop(0.55, Qt.rgba(d.r, d.g, d.b, 0.38));
                grad.addColorStop(1.0, Qt.rgba(d.r, d.g, d.b, 0.10));
                ctx.fillStyle = grad;
                ctx.fill();

                blobPath();
                ctx.lineWidth = 2;
                ctx.strokeStyle = Qt.rgba(a.r, a.g, a.b, 0.85);
                ctx.stroke();
            }
        }

        // ---------- Now playing — vinilo dentro de la ameba ----------
        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -6
            spacing: 6
            visible: visualizer.activePlayer !== null

            Item {
                id: vinyl
                width: 96
                height: 96
                anchors.horizontalCenter: parent.horizontalCenter

                // Sombra suave para despegar el disco de la ameba
                MultiEffect {
                    anchors.fill: disc
                    source: disc
                    z: -1
                    shadowEnabled: true
                    shadowBlur: 0.9
                    shadowOpacity: 0.6
                    shadowVerticalOffset: 3
                }

                Item {
                    id: disc
                    anchors.fill: parent

                    RotationAnimation on rotation {
                        from: 0
                        to: 360
                        duration: 8000
                        loops: Animation.Infinite
                        running: visualizer.effectiveShown && visualizer.visible
                        paused: running && !visualizer.playing
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "#16141d"
                        border.width: 1
                        border.color: Qt.rgba(visualizer.accent.r, visualizer.accent.g,
                                              visualizer.accent.b, 0.45)
                    }

                    // Grooves
                    Canvas {
                        anchors.fill: parent
                        onPaint: {
                            const ctx = getContext("2d");
                            ctx.reset();
                            const c = width / 2;
                            for (let r = c - 5; r > c * 0.52; r -= 3) {
                                ctx.beginPath();
                                ctx.arc(c, c, r, 0, Math.PI * 2);
                                ctx.lineWidth = 1;
                                ctx.strokeStyle = Qt.rgba(1, 1, 1, (r % 9 < 3) ? 0.09 : 0.04);
                                ctx.stroke();
                            }
                        }
                    }

                    // Label: album art
                    Item {
                        width: parent.width * 0.48
                        height: width
                        anchors.centerIn: parent

                        Image {
                            id: art
                            anchors.fill: parent
                            source: visualizer.activePlayer?.trackArtUrl ?? ""
                            fillMode: Image.PreserveAspectCrop
                            sourceSize.width: 128
                            sourceSize.height: 128
                            asynchronous: true
                            visible: false
                        }

                        Rectangle {
                            id: artMask
                            anchors.fill: parent
                            radius: width / 2
                            visible: false
                            layer.enabled: true
                        }

                        MultiEffect {
                            anchors.fill: parent
                            source: art
                            maskEnabled: true
                            maskSource: artMask
                            maskThresholdMin: 0.5
                            maskSpreadAtMin: 1.0
                            visible: art.status === Image.Ready
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: width / 2
                            color: theme.colors.surface0 || "#313244"
                            visible: art.status !== Image.Ready

                            Text {
                                anchors.centerIn: parent
                                text: "󰎆"
                                font.family: theme.fontFamily
                                font.pixelSize: 20
                                color: visualizer.accent
                            }
                        }
                    }

                    // Spindle hole
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        anchors.centerIn: parent
                        color: theme.colors.crust || "#11111b"
                        border.width: 1
                        border.color: Qt.rgba(1, 1, 1, 0.25)
                    }
                }

                // Static light sheen (doesn't rotate with the disc)
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        const ctx = getContext("2d");
                        ctx.reset();
                        const c = width / 2;
                        ctx.beginPath();
                        ctx.arc(c, c, c * 0.72, -2.5, -1.3);
                        ctx.lineWidth = c * 0.45;
                        ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.06);
                        ctx.stroke();
                        ctx.beginPath();
                        ctx.arc(c, c, c * 0.72, 0.65, 1.85);
                        ctx.lineWidth = c * 0.45;
                        ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.05);
                        ctx.stroke();
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(implicitWidth, 152)
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                font.family: theme.fontFamily
                font.pixelSize: 12
                font.weight: Font.DemiBold
                color: theme.colors.text || "#cdd6f4"
                style: Text.Raised
                styleColor: theme.colors.crust || "#11111b"
                text: visualizer.activePlayer?.trackTitle || "Unknown"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(implicitWidth, 152)
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                visible: text !== ""
                font.family: theme.fontFamily
                font.pixelSize: 10
                color: Qt.lighter(visualizer.accent, 1.15)
                style: Text.Raised
                styleColor: theme.colors.crust || "#11111b"
                text: visualizer.activePlayer?.trackArtist ?? ""
            }
        }
    }
}
