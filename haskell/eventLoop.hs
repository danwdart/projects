-- Let's make our own event loop

data EventType = FileEvent | MouseEvent | KeyEvent

data Event = Event {
    eventType :: EventType,
    time :: Int,
    dataString :: String
}


