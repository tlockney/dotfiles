import Cocoa

class CaptureWindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.stop(nil)
    }
}

class CaptureApp {
    let textView: NSTextView
    let window: NSPanel
    let delegate = CaptureWindowDelegate()
    var captured = false

    init() {
        let width: CGFloat = 480
        let height: CGFloat = 320

        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        let x = (screenFrame.width - width) / 2
        let y = (screenFrame.height - height) / 2

        window = NSPanel(
            contentRect: NSRect(x: x, y: y, width: width, height: height),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Quick Capture"
        window.level = .floating
        window.isReleasedWhenClosed = false

        let contentView = window.contentView!

        // Label
        let label = NSTextField(labelWithString: "Capture to today's daily note:")
        label.frame = NSRect(x: 16, y: height - 50, width: width - 32, height: 20)
        contentView.addSubview(label)

        // Scroll view + text view
        let scrollView = NSScrollView(frame: NSRect(x: 16, y: 52, width: width - 32, height: height - 110))
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.borderType = .bezelBorder

        textView = NSTextView(frame: NSRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height))
        textView.minSize = NSSize(width: 0, height: scrollView.contentSize.height)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize = NSSize(width: scrollView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        textView.font = NSFont.userFixedPitchFont(ofSize: 14)
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true

        scrollView.documentView = textView
        contentView.addSubview(scrollView)

        // Capture button (Cmd+Return)
        let captureBtn = NSButton(frame: NSRect(x: width - 112, y: 12, width: 96, height: 32))
        captureBtn.title = "Capture"
        captureBtn.bezelStyle = .rounded
        captureBtn.keyEquivalent = "\r"
        captureBtn.keyEquivalentModifierMask = [.command]
        captureBtn.target = self
        captureBtn.action = #selector(captureClicked)
        contentView.addSubview(captureBtn)

        // Cancel button (Escape)
        let cancelBtn = NSButton(frame: NSRect(x: width - 216, y: 12, width: 96, height: 32))
        cancelBtn.title = "Cancel"
        cancelBtn.bezelStyle = .rounded
        cancelBtn.keyEquivalent = "\u{1b}"
        cancelBtn.target = self
        cancelBtn.action = #selector(cancelClicked)
        contentView.addSubview(cancelBtn)

        window.delegate = delegate
    }

    @objc func captureClicked() {
        captured = true
        window.close()
    }

    @objc func cancelClicked() {
        captured = false
        window.close()
    }

    func run() -> String? {
        NSApp.setActivationPolicy(.accessory)
        NSApp.activate(ignoringOtherApps: true)

        window.makeKeyAndOrderFront(nil)
        window.makeFirstResponder(textView)

        NSApp.run()

        if captured {
            let text = textView.string.trimmingCharacters(in: .whitespacesAndNewlines)
            return text.isEmpty ? nil : textView.string
        }
        return nil
    }
}

let app = NSApplication.shared
let capture = CaptureApp()

if let text = capture.run() {
    print(text, terminator: "")
} else {
    exit(1)
}
