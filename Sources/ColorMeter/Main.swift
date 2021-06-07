import Cocoa

struct Item {
    let red: Int
    let green: Int
    let blue: Int

    init(with color: NSColor) {
        red = lroundf(Float(color.redComponent * 255))
        green = lroundf(Float(color.greenComponent * 255))
        blue = lroundf(Float(color.blueComponent * 255))
    }

    var hex: String {
        String(format: "#%02X%02X%02X", red, green, blue)
    }
}

func run(withDebugMode debug: Bool) -> Int32 {
    let mouseLocation = NSEvent.mouseLocation
    if debug {
        NSLog("[debug] location: %f %f", mouseLocation.x, mouseLocation.y)
    }
    let mousePoint = NSPointToCGPoint(mouseLocation)
    if debug {
        NSLog("[debug] location: %f %f", mousePoint.x, mousePoint.y)
    }
    let cgDirectDisplayId = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: 1)
    defer {
        cgDirectDisplayId.deallocate()
    }
    let displayCount = UnsafeMutablePointer<uint32>.allocate(capacity: 1)
    defer {
        displayCount.deallocate()
    }

    let err = CGGetDisplaysWithPoint(mousePoint, 1, cgDirectDisplayId, displayCount)
    guard err == CGError.success else {
        if debug {
            NSLog("[debug] error to get displays with point %d", Int32(err.rawValue))
        }
        return 1
    }

    if debug {
        NSLog("[debug] display count: %d", displayCount.pointee)
    }

    let bounds = CGDisplayBounds(cgDirectDisplayId.pointee)
    if debug {
        NSLog("[debug] display bounds: width=\(bounds.width), height=\(bounds.height)")
    }

    guard let image = CGDisplayCreateImage(cgDirectDisplayId.pointee, rect: CGRect(x: mousePoint.x, y: bounds.height - mousePoint.y, width: 1, height: 1)) else {
        return 10
    }

    let bitmapImageRep = NSBitmapImageRep(cgImage: image)
    guard let color = bitmapImageRep.colorAt(x: 0, y: 0) else {
        return 100
    }
    let item = Item(with: color)
    print(item.hex)
    return 0
}

func getDebugMode() -> Bool? {
    let arguments = CommandLine.arguments
    if arguments.count == 1 {
        return false
    }
    if arguments.count != 2 {
        return nil
    }
    let option = arguments[1]
    if option == "-d" || option == "--debug" {
        return true
    } else {
        return nil
    }
}

guard let debug = getDebugMode() else {
    print("color-meter")
    print("")
    print("  shows color at the mouse pointer in hex RGB.")
    print("")
    print("options:")
    print("  --debug, -d  debug mode")
    exit(1000)
}
let state = run(withDebugMode: debug)
exit(state)
